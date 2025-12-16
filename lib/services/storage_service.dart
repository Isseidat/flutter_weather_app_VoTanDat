import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather_model.dart';

class StorageService {
  static const _weatherKey = 'cached_weather';
  static const _lastUpdateKey = 'last_update';

  // HISTORY
  static const _searchHistoryKey = 'search_history';

  // FAVORITE CITIES
  static const _favoriteCitiesKey = 'favorite_cities';

  // =======================================================
  // WEATHER CACHE
  // =======================================================
  Future<void> saveWeatherData(WeatherModel weather) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_weatherKey, json.encode(weather.toJson()));
    await prefs.setInt(_lastUpdateKey, DateTime.now().millisecondsSinceEpoch);
  }

  Future<WeatherModel?> getCachedWeather() async {
    final prefs = await SharedPreferences.getInstance();
    final s = prefs.getString(_weatherKey);
    if (s == null) return null;
    return WeatherModel.fromJson(json.decode(s));
  }

  Future<bool> isCacheValid() async {
    final prefs = await SharedPreferences.getInstance();
    final last = prefs.getInt(_lastUpdateKey);
    if (last == null) return false;
    return DateTime.now().millisecondsSinceEpoch - last < 30 * 60 * 1000;
  }

  // =======================================================
  // SEARCH HISTORY
  // =======================================================
  Future<List<String>> getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_searchHistoryKey) ?? [];
  }

  Future<void> addSearchHistory(String city) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_searchHistoryKey) ?? [];

    city = city.trim();
    history.remove(city);
    history.insert(0, city);

    if (history.length > 10) {
      history = history.sublist(0, 10);
    }

    await prefs.setStringList(_searchHistoryKey, history);
  }

  Future<void> removeSearchItem(String city) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> history = prefs.getStringList(_searchHistoryKey) ?? [];
    history.remove(city);
    await prefs.setStringList(_searchHistoryKey, history);
  }

  Future<void> clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_searchHistoryKey);
  }

  // =======================================================
  // FAVORITE CITIES (MAX 5)
  // =======================================================
  Future<List<String>> getFavoriteCities() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoriteCitiesKey) ?? [];
  }

  Future<bool> toggleFavoriteCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favs = prefs.getStringList(_favoriteCitiesKey) ?? [];

    city = city.trim();

    if (favs.contains(city)) {
      favs.remove(city);
      await prefs.setStringList(_favoriteCitiesKey, favs);
      return false; // removed
    }

    // limit 5
    if (favs.length >= 5) return false;

    favs.add(city);
    await prefs.setStringList(_favoriteCitiesKey, favs);
    return true; // added
  }

  Future<void> removeFavoriteCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favs = prefs.getStringList(_favoriteCitiesKey) ?? [];
    favs.remove(city);
    await prefs.setStringList(_favoriteCitiesKey, favs);
  }

  Future<void> clearFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_favoriteCitiesKey);
  }
}
