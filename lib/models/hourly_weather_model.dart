class HourlyWeatherModel {
  final DateTime dateTime;
  final double temp;
  final String description;
  final String icon;
  final double pop; // probability of precipitation (0..1)

  HourlyWeatherModel({
    required this.dateTime,
    required this.temp,
    required this.description,
    required this.icon,
    required this.pop,
  });

  factory HourlyWeatherModel.fromJson(Map<String, dynamic> json) {
    return HourlyWeatherModel(
      dateTime: DateTime.fromMillisecondsSinceEpoch((json['dt'] as int) * 1000),
      temp: (json['temp'] as num).toDouble(),
      description: (json['weather'] as List).isNotEmpty ? json['weather'][0]['description'] : '',
      icon: (json['weather'] as List).isNotEmpty ? json['weather'][0]['icon'] : '01d',
      pop: (json['pop'] != null) ? (json['pop'] as num).toDouble() : 0.0,
    );
  }
}



