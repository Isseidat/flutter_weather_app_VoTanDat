import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../providers/weather_provider.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../models/daily_forecast_model.dart';
import '../utils/constants.dart';
import 'search_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherProvider>().fetchWeatherByLocation();
    });
  }

  Widget _floatingSearchButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withOpacity(0.3), width: 1.2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.search, size: 26, color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  Widget _floatingSettingsButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black.withOpacity(0.3), width: 1.2),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(Icons.settings, size: 26, color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }

  // đổi độ -> hướng gió
  String getWindDirection(int deg) {
    if (deg >= 337.5 || deg < 22.5) return "N";
    if (deg < 67.5) return "NE";
    if (deg < 112.5) return "E";
    if (deg < 157.5) return "SE";
    if (deg < 202.5) return "S";
    if (deg < 247.5) return "SW";
    if (deg < 292.5) return "W";
    return "NW";
  }

  // ================= HOURLY FORECAST =================
  Widget _hourlyForecast(List<ForecastModel> forecast) {
    if (forecast.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          "Hourly Forecast (24h)",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 130,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: forecast.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final f = forecast[index];
              return Container(
                width: 85,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat.Hm().format(f.dateTime),
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(height: 6),
                    Image.network(
                      "https://openweathermap.org/img/wn/${f.icon}@2x.png",
                      width: 45,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "${f.temperature.round()}°",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ================= DAILY FORECAST =================
  Widget _dailyForecast(List<DailyForecastModel> forecast) {
    if (forecast.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 20),
        const Text(
          "5-Day Forecast",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 150,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: forecast.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final f = forecast[index];
              return Container(
                width: 100,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat.E().format(f.date),
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                    ),
                    const SizedBox(height: 6),
                    Image.network(
                      "https://openweathermap.org/img/wn/${f.icon}@2x.png",
                      width: 50,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "${f.maxTemp.round()}° / ${f.minTemp.round()}°",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WeatherProvider>();

    if (provider.state == WeatherState.loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.state == WeatherState.error) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text("Weather App"),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: _floatingSearchButton(context),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: _floatingSettingsButton(context),
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(provider.errorMessage, textAlign: TextAlign.center),
              const SizedBox(height: 15),
              ElevatedButton(
                onPressed: () => provider.fetchWeatherByLocation(),
                child: const Text("Retry"),
              ),
            ],
          ),
        ),
      );
    }

    final WeatherModel? w = provider.currentWeather;
    if (w == null) {
      return const Scaffold(
        body: Center(child: Text("No data available")),
      );
    }

    final cardColor = AppColors.getBackgroundColor(w.mainCondition);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text("Weather App"),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: _floatingSearchButton(context),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: _floatingSettingsButton(context),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => provider.refreshWeather(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 20), // tránh overflow
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 12,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        icon: Icon(
                          provider.isFavoriteCity(w.cityName)
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () async {
                          final success =
                          await provider.toggleFavoriteCity(w.cityName);
                          if (!success && mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Đã quá số lượng lưu trữ (tối đa 5 thành phố)!",
                                ),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                    Text(
                      "${w.cityName}, ${w.country}",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white.withOpacity(0.95),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      DateFormat.yMMMEd().add_Hm().format(w.dateTime),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.85),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Image.network(
                      'https://openweathermap.org/img/wn/${w.icon}@4x.png',
                      height: 140,
                    ),
                    Text(
                      "${w.temperature.round()}°C",
                      style: TextStyle(
                        fontSize: 58,
                        fontWeight: FontWeight.w600,
                        color: Colors.white.withOpacity(0.95),
                      ),
                    ),
                    Text(
                      w.description,
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white.withOpacity(0.90),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      "Feels like: ${w.feelsLike}°C · Humidity: ${w.humidity}%",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.85),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Wind: ${w.windSpeed} m/s · Direction: ${getWindDirection(w.windDegree)}",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.85),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    // HOURLY FORECAST
                    _hourlyForecast(provider.hourlyForecast),
                    // DAILY FORECAST
                    _dailyForecast(provider.dailyForecast),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
