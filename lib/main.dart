import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'providers/settings_provider.dart';
import 'providers/weather_provider.dart';
import 'providers/location_provider.dart';

import 'services/weather_service.dart';
import 'services/location_service.dart';
import 'services/storage_service.dart';
import 'services/connectivity_service.dart';

import 'screens/home_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: 'api.env');

  final weatherService = WeatherService();
  final locationService = LocationService();
  final storageService = StorageService();
  final connectivityService = ConnectivityService();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LocationProvider(locationService),
        ),

        ChangeNotifierProvider(
          create: (_) => WeatherProvider(
            weatherService,
            locationService,
            storageService,
          ),
        ),

        // ✅ FIX ĐÚNG DÒNG NÀY
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(),
        ),

        Provider.value(value: connectivityService),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
