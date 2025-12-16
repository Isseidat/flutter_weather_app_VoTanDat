import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/forecast_model.dart';

class HourlyForecast extends StatelessWidget {
  final List<ForecastModel> hourly;

  const HourlyForecast({super.key, required this.hourly});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: hourly.length,
        itemBuilder: (context, i) {
          final h = hourly[i];
          return Container(
            width: 90,
            margin: const EdgeInsets.only(right: 12),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  DateFormat('HH:mm').format(h.dateTime),
                  style: const TextStyle(color: Colors.white),
                ),
                Image.network(
                  'https://openweathermap.org/img/wn/${h.icon}.png',
                  width: 40,
                ),
                Text(
                  '${h.temperature.round()}°C',
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  '${(h.pop * 100).round()}%',
                  style: const TextStyle(color: Colors.blueAccent),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
