class LocationModel {
  final double latitude;
  final double longitude;
  final String? city;

  LocationModel({
    required this.latitude,
    required this.longitude,
    this.city,
  });

  Map<String, dynamic> toJson() => {
    'lat': latitude,
    'lon': longitude,
    'city': city,
  };

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
    latitude: (json['lat'] as num).toDouble(),
    longitude: (json['lon'] as num).toDouble(),
    city: json['city'],
  );
}
