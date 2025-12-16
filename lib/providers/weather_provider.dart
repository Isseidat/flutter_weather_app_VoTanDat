import 'package:flutter/material.dart';
import '../models/daily_forecast_model.dart';

import '../models/weather_model.dart';
import '../models/forecast_model.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';

enum WeatherState { initial, loading, success, error }

class WeatherProvider extends ChangeNotifier {
  final WeatherService _weatherService;
  final LocationService _locationService;
  final StorageService _storageService;

  WeatherModel? _currentWeather;

  // 🔥 24h forecast (3h × 8)
  List<ForecastModel> _hourlyForecast = [];

  // 🔥 5-day forecast
  List<DailyForecastModel> _dailyForecast = [];

  WeatherState _state = WeatherState.initial;
  String _errorMessage = '';

  List<String> _favoriteCities = [];

  WeatherProvider(
      this._weatherService,
      this._locationService,
      this._storageService,
      ) {
    _loadFavorites();
  }

  // ================== GETTERS ==================
  WeatherModel? get currentWeather => _currentWeather;
  List<ForecastModel> get hourlyForecast => _hourlyForecast;
  List<DailyForecastModel> get dailyForecast => _dailyForecast;

  WeatherState get state => _state;
  String get errorMessage => _errorMessage;
  List<String> get favoriteCities => _favoriteCities;

  // ======================================================
  // LOAD FAVORITES
  // ======================================================
  Future<void> _loadFavorites() async {
    _favoriteCities = await _storageService.getFavoriteCities();
    notifyListeners();
  }

  // ======================================================
  // FETCH WEATHER BY CITY
  // ======================================================
  Future<void> fetchWeatherByCity(String cityName) async {
    _state = WeatherState.loading;
    notifyListeners();

    try {
      _currentWeather =
      await _weatherService.getCurrentWeatherByCity(cityName);

      // 24h
      _hourlyForecast =
      await _weatherService.getHourlyForecastByCity(cityName);

      // 🔥 5 days
      _dailyForecast =
      await _weatherService.getDailyForecastByCity(cityName);

      await _storageService.saveWeatherData(_currentWeather!);

      _state = WeatherState.success;
      _errorMessage = '';
    } catch (e) {
      _state = WeatherState.error;
      _errorMessage = e.toString();
    }

    notifyListeners();
  }

  // ======================================================
  // FETCH WEATHER BY LOCATION
  // ======================================================
  Future<void> fetchWeatherByLocation() async {
    _state = WeatherState.loading;
    notifyListeners();

    try {
      final pos = await _locationService.getCurrentLocation();

      _currentWeather =
      await _weatherService.getCurrentWeatherByCoordinates(
        pos.latitude,
        pos.longitude,
      );

      // 24h
      _hourlyForecast =
      await _weatherService.getHourlyForecastByCity(
        _currentWeather!.cityName,
      );

      // 🔥 5 days
      _dailyForecast =
      await _weatherService.getDailyForecastByCity(
        _currentWeather!.cityName,
      );

      await _storageService.saveWeatherData(_currentWeather!);

      _state = WeatherState.success;
      _errorMessage = '';
    } catch (e) {
      _state = WeatherState.error;
      _errorMessage = e.toString();
      await loadCachedWeather();
    }

    notifyListeners();
  }

  // ======================================================
  // LOAD CACHED WEATHER
  // ======================================================
  Future<void> loadCachedWeather() async {
    final cached = await _storageService.getCachedWeather();
    if (cached != null) {
      _currentWeather = cached;
      _state = WeatherState.success;
      notifyListeners();
    }
  }

  // ======================================================
  // REFRESH
  // ======================================================
  Future<void> refreshWeather() async {
    if (_currentWeather != null) {
      fetchWeatherByCity(_currentWeather!.cityName);
    } else {
      fetchWeatherByLocation();
    }
  }

  // ======================================================
  // FAVORITES
  // ======================================================
  bool isFavoriteCity(String city) => _favoriteCities.contains(city);

  Future<bool> toggleFavoriteCity(String city) async {
    final result = await _storageService.toggleFavoriteCity(city);
    _favoriteCities = await _storageService.getFavoriteCities();
    notifyListeners();
    return result;
  }
}
