import 'package:flutter/material.dart';
import '../services/location_service.dart';
import '../models/location_model.dart';

class LocationProvider extends ChangeNotifier {
  final LocationService _locationService;

  LocationModel? _currentLocation;
  String? _error;

  LocationProvider(this._locationService);

  LocationModel? get currentLocation => _currentLocation;
  String? get error => _error;

  Future<void> fetchCurrentLocation() async {
    try {
      final pos = await _locationService.getCurrentLocation();
      final city = await _locationService.getCityName(pos.latitude, pos.longitude);
      _currentLocation = LocationModel(latitude: pos.latitude, longitude: pos.longitude, city: city);
      _error = null;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
