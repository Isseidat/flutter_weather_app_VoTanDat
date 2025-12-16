import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'weather_service_test.dart' as weather_tests;

void main() {
  // Load env trực tiếp, không dùng rootBundle
  dotenv.testLoad(
    fileInput: '''
OPENWEATHER_API_KEY=fa96f60e9b309758a89f12e3b7e435a3
WEATHER_API_KEY=b7e4f271607ac2456c6045c0a8d79111
''',
  );

  // Chạy test
  weather_tests.main();
}
