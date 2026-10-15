import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Veritabanı ve yerel ayarları yöneten servis.
class LocalStorageService {
  static const String tasksBoxName = 'tasks_box_v2';
  static const String habitsBoxName = 'habits_box_v2';

  static const String _keyDarkMode = 'dark_mode';
  static const String _keyNotificationsEnabled = 'notifications_enabled';

  late final Box _tasksBox;
  late final Box _habitsBox;
  late final SharedPreferences _prefs;

  Future<void> init() async {
    await Hive.initFlutter();

    // Olası veri yapısı uyuşmazlıklarına karşı güvenli kutu açma
    try {
      _tasksBox = await Hive.openBox(tasksBoxName);
      _habitsBox = await Hive.openBox(habitsBoxName);
    } catch (_) {
      await Hive.deleteBoxFromDisk(tasksBoxName);
      await Hive.deleteBoxFromDisk(habitsBoxName);
      _tasksBox = await Hive.openBox(tasksBoxName);
      _habitsBox = await Hive.openBox(habitsBoxName);
    }

    _prefs = await SharedPreferences.getInstance();
  }

  Box get tasksBox => _tasksBox;
  Box get habitsBox => _habitsBox;

  bool get isDarkMode => _prefs.getBool(_keyDarkMode) ?? false;
  Future<void> setDarkMode(bool value) => _prefs.setBool(_keyDarkMode, value);

  bool get areNotificationsEnabled =>
      _prefs.getBool(_keyNotificationsEnabled) ?? true;
  Future<void> setNotificationsEnabled(bool value) =>
      _prefs.setBool(_keyNotificationsEnabled, value);
}
