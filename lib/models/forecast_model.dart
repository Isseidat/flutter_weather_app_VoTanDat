class ForecastModel {
  final DateTime dateTime;
  final double temperature;
  final String icon;
  final String description;
  final double minTemp;
  final double maxTemp;
  final double pop; // probability of precipitation

  ForecastModel({
    required this.dateTime,
    required this.temperature,
    required this.icon,
    required this.description,
    required this.minTemp,
    required this.maxTemp,
    required this.pop,
  });

  factory ForecastModel.fromHourly(Map<String, dynamic> json) {
    return ForecastModel(
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: (json['temp'] as num).toDouble(),
      icon: json['weather'][0]['icon'],
      description: json['weather'][0]['description'],
      minTemp: (json['temp'] as num).toDouble(),
      maxTemp: (json['temp'] as num).toDouble(),
      pop: (json['pop'] ?? 0).toDouble(),
    );
  }

  factory ForecastModel.fromDaily(Map<String, dynamic> json) {
    return ForecastModel(
      dateTime: DateTime.fromMillisecondsSinceEpoch(json['dt'] * 1000),
      temperature: (json['temp']['day'] as num).toDouble(),
      minTemp: (json['temp']['min'] as num).toDouble(),
      maxTemp: (json['temp']['max'] as num).toDouble(),
      icon: json['weather'][0]['icon'],
      description: json['weather'][0]['description'],
      pop: (json['pop'] ?? 0).toDouble(),
    );
  }
}
