import 'dart:convert';
import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../models/daily_forecast_model.dart';

class WeatherService {
  WeatherService();


  // ======================================================
  // CURRENT WEATHER BY CITY
  // ======================================================
  Future<WeatherModel> getCurrentWeatherByCity(String city) async {
    final url = ApiConfig.buildUrl(
      ApiConfig.currentWeather,
      {'q': city},
    );

    final response = await http
        .get(Uri.parse(url))
        .timeout(const Duration(seconds: 12));

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(response.body));
    }

    if (response.statusCode == 404) {
      throw Exception("City not found");
    }

    if (response.statusCode == 401) {
      throw Exception("Invalid API Key");
    }

    throw Exception("Failed to load weather");
  }

  // ======================================================
  // CURRENT WEATHER BY GPS
  // ======================================================
  Future<WeatherModel> getCurrentWeatherByCoordinates(
      double lat,
      double lon,
      ) async {
    final url = ApiConfig.buildUrl(
      ApiConfig.currentWeather,
      {
        'lat': lat.toString(),
        'lon': lon.toString(),
      },
    );

    final response = await http
        .get(Uri.parse(url))
        .timeout(const Duration(seconds: 12));

    if (response.statusCode == 200) {
      return WeatherModel.fromJson(json.decode(response.body));
    }

    throw Exception("Failed to load weather");
  }

  // ======================================================
  // HOURLY FORECAST (24H)
  // ======================================================
  Future<List<ForecastModel>> getHourlyForecastByCity(
      String cityName,
      ) async {
    final url = ApiConfig.buildUrl(
      ApiConfig.forecast,
      {'q': cityName},
    );

    final response = await http
        .get(Uri.parse(url))
        .timeout(const Duration(seconds: 12));

    if (response.statusCode != 200) {
      throw Exception("Failed to load forecast");
    }

    final data = json.decode(response.body);
    final List list = data['list'];

    return list.take(8).map<ForecastModel>((item) {
      return ForecastModel(
        dateTime:
        DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000),
        temperature:
        (item['main']['temp'] as num).toDouble(),
        minTemp:
        (item['main']['temp_min'] as num).toDouble(),
        maxTemp:
        (item['main']['temp_max'] as num).toDouble(),
        icon: item['weather'][0]['icon'],
        description: item['weather'][0]['description'],
        pop: (item['pop'] ?? 0).toDouble(),
      );
    }).toList();
  }

  // ======================================================
  // 🔥 DAILY FORECAST (5 DAYS) - BY CITY
  // ======================================================
  Future<List<DailyForecastModel>> getDailyForecastByCity(
      String cityName,
      ) async {
    final url = ApiConfig.buildUrl(
      ApiConfig.forecast,
      {'q': cityName},
    );

    final res = await http.get(Uri.parse(url));
    if (res.statusCode != 200) {
      throw Exception('Failed to load 5-day forecast');
    }

    final data = jsonDecode(res.body);
    final List list = data['list'];

    final Map<String, List> groupByDay = {};

    for (final item in list) {
      final dt =
      DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000);
      final key = "${dt.year}-${dt.month}-${dt.day}";
      groupByDay.putIfAbsent(key, () => []).add(item);
    }

    final List<DailyForecastModel> result = [];

    for (final day in groupByDay.values.take(5)) {
      final temps =
      day.map((e) => e['main']['temp'] as num).toList();
      final mid = day[day.length ~/ 2];

      result.add(
        DailyForecastModel(
          date:
          DateTime.fromMillisecondsSinceEpoch(mid['dt'] * 1000),
          minTemp:
          temps.reduce((a, b) => a < b ? a : b).toDouble(),
          maxTemp:
          temps.reduce((a, b) => a > b ? a : b).toDouble(),
          icon: mid['weather'][0]['icon'],
          description: mid['weather'][0]['description'],
        ),
      );
    }

    return result;
  }

  ForecastModel parseForecastItem(Map<String, dynamic> item) {
    return ForecastModel(
      dateTime: DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000),
      temperature: (item['main']['temp'] as num).toDouble(),
      minTemp: (item['main']['temp_min'] as num).toDouble(),
      maxTemp: (item['main']['temp_max'] as num).toDouble(),
      icon: item['weather'][0]['icon'],
      description: item['weather'][0]['description'],
      pop: (item['pop'] ?? 0).toDouble(),
    );
  }

  // ======================================================
  // ICON URL
  // ======================================================
  String getIconUrl(String icon) {
    return "https://openweathermap.org/img/wn/$icon@4x.png";
  }
}
