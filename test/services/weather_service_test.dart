import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_testing/models/weather_model.dart';
import 'package:flutter_testing/services/weather_service.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../fixtures/weather_fixture.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  WeatherService service;

  group('getCurrentWeatherForecat', () {
    test('returns a Weather if http call completes with success', () async {
      final http.Client mockClient = MockClient();
      when(mockClient.get(argThat(contains('q=cidade')))).thenAnswer(
        (_) async => http.Response(weatherJsonResponse, 200),
      );

      service = WeatherService(apiKey: 'anyapikey', client: mockClient);
      Weather weather = await service.getCurrentWeatherForecat(
        cityName: 'cidade',
      );

      expect(weather, isNot(null));
      expect(weather.cityName, 'Mountain View');
    });

    test('returns null if http call completes with no body result', () async {
      final http.Client mockClient = MockClient();
      when(mockClient.get(argThat(contains('q=cidade')))).thenAnswer(
        (_) async => http.Response('', 404),
      );

      service = WeatherService(apiKey: 'anyapikey', client: mockClient);
      Weather weather = await service.getCurrentWeatherForecat(
        cityName: 'cidade',
      );

      expect(weather, null);
    });
  });

  group('buildUrl', () {
    setUp(() {
      service = WeatherService(apiKey: 'anyapikey');
    });

    test('returns correct url when no params is passed', () {
      String url = service.buildUrl();
      expect(
        url,
        'https://api.openweathermap.org/data/2.5/weather?appid=anyapikey&lang=pt_br&units=metric',
      );
    });

    test('returns correct url when there is space in the params string', () {
      String url = service.buildUrl(params: 'name=new york');
      expect(url, contains('name=new%20york'));
    });
  });
}
