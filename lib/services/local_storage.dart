import 'package:shared_preferences/shared_preferences.dart';

abstract interface class LocalStorage {
  Future<void> init();

  bool get isCelcius;
  Future<void> saveIsCelsius(bool value);
}

class SharedPrefsStorage implements LocalStorage {
  static const isCelsiusKey = 'isCelsius';
  static const latitudeKey = 'latitude';
  static const longitudeKey = 'longitude';

  late SharedPreferences prefs;

  @override
  Future<void> init() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  bool get isCelcius => prefs.getBool(isCelsiusKey) ?? true;

  @override
  Future<void> saveIsCelsius(bool value) async {
    await prefs.setBool(isCelsiusKey, value);
  }
}
