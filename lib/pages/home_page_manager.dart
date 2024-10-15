import 'package:flutter/foundation.dart';
import 'package:min_weather_app/services/local_storage.dart';
import 'package:min_weather_app/services/service_locator.dart';
import 'package:min_weather_app/services/web_api.dart';

class HomePageManager {
  late WebApi _webApi;
  late LocalStorage _storage;

  HomePageManager({
    WebApi? webApi,
    LocalStorage? storage,
  }) {
    _webApi = webApi ?? getIt<WebApi>();
    _storage = storage ?? getIt<LocalStorage>();
  }

  final loadingNotifier = ValueNotifier<LoadingStatus>(const Loading());
  final temperatureNotifier = ValueNotifier<String>('');
  final buttonNotifier = ValueNotifier<String>('˚C');

  late int _temperature;

  Future<void> loadWeather() async {
    loadingNotifier.value = const Loading();
    final isCelsius = _storage.isCelcius;
    buttonNotifier.value = (isCelsius) ? '˚C' : '˚F';
    try {
      final weather = await _webApi.getWeather(
        latitude: 35.902710,
        longitude: -78.948180,
      );
      _temperature = weather.temperature;
      final temperature =
          (isCelsius) ? _temperature : _convertToFahrenheit(_temperature);
      temperatureNotifier.value = '$temperature';
      loadingNotifier.value = LoadingSuccess(
        weather: weather.description,
      );
    } catch (err) {
      print(err);
      loadingNotifier.value = const LoadingError(
        'There was an error loading the weather.',
      );
    }
  }

  int _convertToFahrenheit(int celsius) {
    return (celsius * 9 / 5 + 32).toInt();
  }

  void convertTemperature() {
    final isCelsius = !_storage.isCelcius;
    _storage.saveIsCelsius(isCelsius);
    final temperature =
        (isCelsius) ? _temperature : _convertToFahrenheit(_temperature);
    temperatureNotifier.value = '$temperature';
    buttonNotifier.value = (isCelsius) ? '˚C' : '˚F';
  }
}

sealed class LoadingStatus {
  const LoadingStatus();
}

class Loading extends LoadingStatus {
  const Loading();
}

class LoadingError extends LoadingStatus {
  final String message;

  const LoadingError(this.message);
}

class LoadingSuccess extends LoadingStatus {
  final String weather;

  const LoadingSuccess({
    required this.weather,
  });
}
