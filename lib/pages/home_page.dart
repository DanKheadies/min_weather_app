import 'package:flutter/material.dart';
import 'package:min_weather_app/pages/home_page_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final manager = HomePageManager();

  @override
  void initState() {
    super.initState();
    manager.loadWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: ValueListenableBuilder<LoadingStatus>(
          valueListenable: manager.loadingNotifier,
          builder: (_, loadingStatus, __) {
            switch (loadingStatus) {
              case Loading():
                return const CircularProgressIndicator();
              case LoadingError():
                return ErrorWidget(
                  errorMessage: loadingStatus.message,
                  onRetry: manager.loadWeather,
                );
              case LoadingSuccess():
                return WeatherWidget(
                  manager: manager,
                  weather: loadingStatus.weather,
                );
            }
          },
        ),
      ),
    );
  }
}

class ErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetry;

  const ErrorWidget({
    super.key,
    required this.errorMessage,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(errorMessage),
        TextButton(
          onPressed: onRetry,
          child: const Text('Try again'),
        ),
      ],
    );
  }
}

class WeatherWidget extends StatelessWidget {
  final HomePageManager manager;
  final String weather;

  const WeatherWidget({
    super.key,
    required this.manager,
    required this.weather,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Stack(
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: TextButton(
              onPressed: manager.convertTemperature,
              child: ValueListenableBuilder(
                valueListenable: manager.buttonNotifier,
                builder: (_, buttonText, __) {
                  return Text(
                    buttonText,
                    style: textTheme.bodyLarge,
                  );
                },
              ),
            ),
          ),
        ),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ValueListenableBuilder(
                valueListenable: manager.temperatureNotifier,
                builder: (_, temperature, __) {
                  return Text(
                    temperature,
                    style: const TextStyle(fontSize: 56),
                  );
                },
              ),
              Text(
                weather,
                style: textTheme.headlineMedium,
              ),
              Text(
                'Durham, NC',
                style: textTheme.headlineSmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
