import 'package:flutter/material.dart';

class AppColors {
  static Color getBackgroundColor(String condition) {
    final c = condition.toLowerCase();

    // CLEAR / SUNNY
    if (c.contains("clear")) {
      return const Color(0xFF95D6EA);
    }

    // RAIN / DRIZZLE
    if (c.contains("rain") || c.contains("drizzle")) {
      return const Color(0xFF7BC7DD);
    }

    // THUNDER / STORM
    if (c.contains("thunder") || c.contains("storm")) {
      return const Color(0xFF528AB4);
    }

    // FOG / MIST / HAZE / SMOKE / CLOUD
    if (c.contains("fog") || c.contains("mist") || c.contains("haze") || c.contains("smoke") || c.contains("cloud")) {
      return const Color(0xFF62A1C7);
    }

    // DEFAULT
    return const Color(0xFF15719F);
  }
}
