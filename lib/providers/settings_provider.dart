import 'package:flutter/material.dart';

enum TemperatureUnit { celsius, fahrenheit }
enum WindSpeedUnit { ms, kmh }
enum TimeFormat { h24, h12 }
enum AppLanguage { vi, en }

class SettingsProvider extends ChangeNotifier {
  TemperatureUnit temperatureUnit = TemperatureUnit.celsius;
  WindSpeedUnit windSpeedUnit = WindSpeedUnit.ms;
  TimeFormat timeFormat = TimeFormat.h24;
  AppLanguage language = AppLanguage.vi;

  void setTemperatureUnit(TemperatureUnit value) {
    temperatureUnit = value;
    notifyListeners();
  }

  void setWindSpeedUnit(WindSpeedUnit value) {
    windSpeedUnit = value;
    notifyListeners();
  }

  void setTimeFormat(TimeFormat value) {
    timeFormat = value;
    notifyListeners();
  }

  void setLanguage(AppLanguage value) {
    language = value;
    notifyListeners();
  }
}
