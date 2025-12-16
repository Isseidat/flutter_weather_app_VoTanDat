import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';
import '../services/storage_service.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  final StorageService _storage = StorageService();

  List<String> history = [];
  List<String> favorites = [];
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadLists();
  }

  void _loadLists() async {
    history = await _storage.getSearchHistory();
    favorites = await _storage.getFavoriteCities();
    setState(() {});
  }

  // ================== SEARCH ==================
  Future<void> _search(String text) async {
    text = text.trim();
    final provider = context.read<WeatherProvider>();

    setState(() => _error = null);

    if (text.isEmpty) {
      setState(() => _error = "Vui lòng nhập tên thành phố");
      return;
    }

    final regex = RegExp(r"^[a-zA-ZÀ-ỹ0-9\s\-]+$");
    if (!regex.hasMatch(text)) {
      setState(() => _error = "Tên thành phố không hợp lệ");
      return;
    }

    await _storage.addSearchHistory(text);
    _loadLists();

    try {
      await provider.fetchWeatherByCity(text);

      if (provider.state == WeatherState.error) {
        setState(() => _error = provider.errorMessage);
      } else {
        if (mounted) Navigator.pop(context);
      }
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  // ================== FAVORITE TOGGLE ==================
  void _toggleFavorite(String city) async {
    final added = await _storage.toggleFavoriteCity(city);

    if (!added && !favorites.contains(city)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tối đa 5 thành phố yêu thích")),
      );
    }

    _loadLists();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text("Search City")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ================= INPUT =================
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Nhập tên thành phố",
                border: OutlineInputBorder(),
                errorText: _error,
              ),
              onSubmitted: _search,
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed:
              provider.state == WeatherState.loading ? null : () => _search(_controller.text),
              child: provider.state == WeatherState.loading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text("Search"),
            ),

            const SizedBox(height: 20),

            // ================= FAVORITES =================
            if (favorites.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Favorite Cities", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...favorites.map((city) => ListTile(
                    leading: const Icon(Icons.star, color: Colors.orange),
                    title: Text(city),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () async {
                        await _storage.removeFavoriteCity(city);
                        _loadLists();
                      },
                    ),
                    onTap: () => _search(city),
                  )),
                  const SizedBox(height: 20),
                ],
              ),

            // ================= HISTORY =================
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Search History", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                if (history.isNotEmpty)
                  TextButton(
                    onPressed: () async {
                      await _storage.clearSearchHistory();
                      _loadLists();
                    },
                    child: const Text("Clear All"),
                  )
              ],
            ),

            Expanded(
              child: history.isEmpty
                  ? const Center(child: Text("Không có lịch sử"))
                  : ListView.builder(
                itemCount: history.length,
                itemBuilder: (_, i) {
                  final city = history[i];
                  return ListTile(
                    leading: const Icon(Icons.history),
                    title: Text(city),
                    trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () async {
                        await _storage.removeSearchItem(city);
                        _loadLists();
                      },
                    ),
                    onTap: () => _search(city),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
