import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_testing/models/weather_model.dart';
import 'package:http/http.dart' as http;

const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';

class WeatherService {
  String _apiKey;
  http.Client _client;

  WeatherService({String apiKey, http.Client client}) {
    this._apiKey = apiKey ?? DotEnv().env['OPEN_WEATHER_MAP_API_KEY'];
    this._client = client ?? http.Client();
  }

  Future<Weather> getCurrentWeatherForecat({String cityName}) async {
    assert(cityName != null, 'city name should not be null');
    String params = 'q=$cityName';

    try {
      var response = await _client.get('${buildUrl(params: params)}');
      var decodedJson = json.decode(response.body);
      return Weather.fromJson(decodedJson);
    } catch (e) {
      return null;
    }
  }

  String buildUrl({String params = ''}) {
    String separator = '&';
    if (params == null || params.isEmpty) {
      separator = '';
    }
    return Uri.encodeFull(
      '$BASE_URL?$params${separator}appid=$_apiKey&lang=pt_br&units=metric',
    );
  }
}
