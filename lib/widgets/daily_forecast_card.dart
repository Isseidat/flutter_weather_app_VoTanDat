import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/forecast_model.dart';

class DailyForecastList extends StatelessWidget {
  final List<ForecastModel> daily;

  const DailyForecastList({super.key, required this.daily});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: daily.map((f) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  DateFormat('EEEE').format(f.dateTime),
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              Image.network(
                'https://openweathermap.org/img/wn/${f.icon}.png',
                width: 40,
              ),
              const SizedBox(width: 12),

              // Nhiệt độ min/max
              Expanded(
                child: Text(
                  "${f.minTemp.round()}° / ${f.maxTemp.round()}°",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // % mưa
              Text(
                "${(f.pop * 100).toInt()}%",
                style: const TextStyle(
                  color: Colors.lightBlueAccent,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
