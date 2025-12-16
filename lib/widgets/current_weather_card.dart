import 'package:flutter/material.dart';

class CurrentWeatherCard extends StatelessWidget {
  final String city;
  final int temperature;

  const CurrentWeatherCard({
    super.key,
    required this.city,
    required this.temperature,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(city),
        Text('$temperature°'),
      ],
    );
  }
}
