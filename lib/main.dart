import 'package:flutter/material.dart';
import 'package:min_weather_app/pages/home_page.dart';
import 'package:min_weather_app/services/local_storage.dart';
import 'package:min_weather_app/services/service_locator.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  await getIt<LocalStorage>().init();
  runApp(const MinWeatherApp());
}

class MinWeatherApp extends StatelessWidget {
  const MinWeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const HomePage(),
    );
  }
}
