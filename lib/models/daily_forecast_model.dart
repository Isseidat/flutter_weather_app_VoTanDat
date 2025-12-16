class DailyForecastModel {
  final DateTime date;
  final double minTemp;
  final double maxTemp;
  final String icon;
  final String description;

  DailyForecastModel({
    required this.date,
    required this.minTemp,
    required this.maxTemp,
    required this.icon,
    required this.description,
  });
}
