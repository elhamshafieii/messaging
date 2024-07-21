import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:messaging/data/hive_theme/hive_theme.dart';

final themeManager = ThemeManager();
const String boxName = 'theme';

class ThemeManager {
  ValueListenable<Box<ThemeEnum>> get listenable =>
      Hive.box<ThemeEnum>(boxName).listenable();

  init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(ThemeEnumAdapter());
    await Hive.openBox<ThemeEnum>(boxName);
  }

  ThemeEnum getTheme() {
    final box = Hive.box<ThemeEnum>(boxName);
    return box.get('theme') ?? ThemeEnum.system;
  }

  putTheme(ThemeEnum themeEnum) async {
    final box = Hive.box<ThemeEnum>(boxName);
    await box.put('theme', themeEnum);
  }
}
