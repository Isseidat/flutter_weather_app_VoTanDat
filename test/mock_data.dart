// test/mock_data.dart

final sampleWeatherJson = {
  "main": {
    "temp": 25.0,
    "feels_like": 27.0,
    "humidity": 70
  },
  "weather": [
    {"main": "Clear", "description": "clear sky", "icon": "01d"}
  ],
  "name": "Ho Chi Minh City",
  "sys": {"country": "VN"},
  "wind": {"speed": 3.5, "deg": 180},
  "dt": 1699999999
};


final sampleForecastJson = {
  "list": [
    {
      "dt": 1699999999,
      "main": {"temp": 25.0, "temp_min": 24.0, "temp_max": 26.0},
      "weather": [{"icon": "01d", "description": "clear sky"}],
      "pop": 0.0
    },
    {
      "dt": 1699999999 + 3600 * 3,
      "main": {"temp": 26.0, "temp_min": 25.0, "temp_max": 27.0},
      "weather": [{"icon": "02d", "description": "few clouds"}],
      "pop": 0.1
    }
  ]
};
