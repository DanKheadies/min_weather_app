import 'dart:convert';

import 'package:http/http.dart';
import 'package:min_weather_app/models/weather.dart';

abstract interface class WebApi {
  Future<Weather> getWeather({
    required double latitude,
    required double longitude,
  });
}

class FccApi implements WebApi {
  @override
  Future<Weather> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    final url = Uri.parse(
        'https://fcc-weather-api.glitch.me/api/current?lat=$latitude&lon=$longitude');
    final result = await get(url);
    final jsonString = result.body;
    final jsonMap = jsonDecode(jsonString);
    final temperature = jsonMap['main']['temp'] as double;
    final weather = jsonMap['weather'][0]['main'] as String;
    print(jsonMap);
    return Weather(
      temperature: temperature.toInt(),
      description: weather,
    );
  }
}

class OpenMeteoApi implements WebApi {
  @override
  Future<Weather> getWeather({
    required double latitude,
    required double longitude,
  }) async {
    final url = Uri.parse(
        'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current=temperature_2m');
    final result = await get(url);
    final jsonString = result.body;
    final jsonMap = jsonDecode(jsonString);
    final temperature = jsonMap['current']['temperature_2m'] as double;
    // final weather = jsonMap['weather'][0]['main'] as String;
    const weather = 'n_n';
    print(jsonMap);
    return Weather(
      temperature: temperature.toInt(),
      description: weather,
    );
  }
}
