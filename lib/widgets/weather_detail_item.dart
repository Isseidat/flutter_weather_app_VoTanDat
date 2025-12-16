import 'package:flutter/material.dart';
import '../models/weather_model.dart';

class WeatherDetailsSection extends StatelessWidget {
  final WeatherModel weather;

  const WeatherDetailsSection({
    super.key,
    required this.weather,
  });

  // đổi độ → hướng gió
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

  Widget _buildItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildItem('Wind', '${weather.windSpeed} m/s'),
          _buildItem('Direction', getWindDirection(weather.windDegree)),
        ],
      ),
    );
  }
}
