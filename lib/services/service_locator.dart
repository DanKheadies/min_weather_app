import 'package:get_it/get_it.dart';
import 'package:min_weather_app/services/local_storage.dart';
import 'package:min_weather_app/services/web_api.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<WebApi>(() => OpenMeteoApi());
  getIt.registerLazySingleton<LocalStorage>(() => SharedPrefsStorage());
}
