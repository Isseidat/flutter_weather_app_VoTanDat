import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Cài đặt"),
      ),
      body: ListView(
        children: [
          _sectionTitle("Đơn vị"),

          _radioTile(
            title: "Nhiệt độ",
            options: const {
              TemperatureUnit.celsius: "Celsius (°C)",
              TemperatureUnit.fahrenheit: "Fahrenheit (°F)",
            },
            groupValue: settings.temperatureUnit,
            onChanged: settings.setTemperatureUnit,
          ),

          _radioTile(
            title: "Tốc độ gió",
            options: const {
              WindSpeedUnit.ms: "m/s",
              WindSpeedUnit.kmh: "km/h",
            },
            groupValue: settings.windSpeedUnit,
            onChanged: settings.setWindSpeedUnit,
          ),

          const Divider(),

          _sectionTitle("Thời gian"),

          SwitchListTile(
            title: const Text("Định dạng 24 giờ"),
            value: settings.timeFormat == TimeFormat.h24,
            onChanged: (v) => settings.setTimeFormat(
              v ? TimeFormat.h24 : TimeFormat.h12,
            ),
          ),

          const Divider(),

          _sectionTitle("Ngôn ngữ"),

          _radioTile(
            title: "Ngôn ngữ",
            options: const {
              AppLanguage.vi: "Tiếng Việt",
              AppLanguage.en: "English",
            },
            groupValue: settings.language,
            onChanged: settings.setLanguage,
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _radioTile<T>({
    required String title,
    required Map<T, String> options,
    required T groupValue,
    required ValueChanged<T> onChanged,
  }) {
    return ExpansionTile(
      title: Text(title),
      children: options.entries.map((e) {
        return RadioListTile<T>(
          title: Text(e.value),
          value: e.key,
          groupValue: groupValue,
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        );
      }).toList(),
    );
  }
}
