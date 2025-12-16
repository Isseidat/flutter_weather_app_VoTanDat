import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/services/weather_service.dart';

void main() {
  // Load env trực tiếp cho test, không cần rootBundle
  dotenv.testLoad(
    fileInput: '''
OPENWEATHER_API_KEY=fa96f60e9b309758a89f12e3b7e435a3
WEATHER_API_KEY=b7e4f271607ac2456c6045c0a8d79111
''',
  );

  group('WeatherService Tests', () {
    late WeatherService weatherService;

    setUpAll(() {
      // Khởi tạo WeatherService sau khi dotenv đã load
      weatherService = WeatherService();
    });

    test('Fetch current weather by city', () async {
      final weather = await weatherService.getCurrentWeatherByCity('Ho Chi Minh City');

      expect(weather.cityName, 'Ho Chi Minh City');
      expect(weather.temperature, isNotNull);
      expect(weather.description, isNotNull);
    });

    test('Fetch current weather by coordinates', () async {
      final weather = await weatherService.getCurrentWeatherByCoordinates(10.7769, 106.7009);

      expect(weather.cityName, isNotEmpty);
      expect(weather.temperature, isNotNull);
      expect(weather.description, isNotNull);
    });

    test('Handle invalid city gracefully', () async {
      expect(
            () => weatherService.getCurrentWeatherByCity('InvalidCityName123'),
        throwsA(isA<Exception>()),
      );
    });

    test('Fetch hourly forecast', () async {
      final forecast = await weatherService.getHourlyForecastByCity('Ho Chi Minh City');

      expect(forecast, isNotEmpty);
      expect(forecast.first.temperature, isNotNull);
      expect(forecast.first.description, isNotNull);
    });

    test('Fetch 5-day daily forecast', () async {
      final dailyForecast = await weatherService.getDailyForecastByCity('Ho Chi Minh City');

      expect(dailyForecast, isNotEmpty);
      expect(dailyForecast.first.minTemp, isNotNull);
      expect(dailyForecast.first.maxTemp, isNotNull);
    });
  });
}
