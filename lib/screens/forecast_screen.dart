import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/weather_provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  String? _error;

  void _search() async {
    final text = _controller.text.trim();
    final provider = context.read<WeatherProvider>();

    setState(() => _error = null);

    // EMPTY search
    if (text.isEmpty) {
      setState(() => _error = "Vui lòng nhập tên thành phố");
      return;
    }

    // SPECIAL characters check
    final regex = RegExp(r"^[a-zA-ZÀ-ỹ0-9\s\-]+$");
    if (!regex.hasMatch(text)) {
      setState(() => _error = "Tên thành phố chứa ký tự không hợp lệ");
      return;
    }

    try {
      await provider.fetchWeatherByCity(text);

      if (provider.state == WeatherState.error) {
        setState(() => _error = provider.errorMessage);
      } else {
        // SEARCH SUCCESS → NAVIGATE BACK
        if (mounted) Navigator.pop(context);
      }
    } catch (e) {
      setState(() => _error = e.toString());
    }
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
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: "Nhập tên thành phố",
                border: OutlineInputBorder(),
                errorText: _error,
              ),
              onSubmitted: (_) => _search(),
            ),

            const SizedBox(height: 16),

            ElevatedButton(
              onPressed: provider.state == WeatherState.loading ? null : _search,
              child: provider.state == WeatherState.loading
                  ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
                  : const Text("Search"),
            ),
          ],
        ),
      ),
    );
  }
}
