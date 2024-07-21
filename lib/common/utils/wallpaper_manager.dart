import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:messaging/data/hive_wallpaper/hive_wallpaper.dart';

final wallpaperManager = WallpaperManager();
const String wallpaperBoxName = 'wallpaper';

class WallpaperManager {
  ValueListenable<Box<Wallpaper>> get listenable =>
      Hive.box<Wallpaper>(wallpaperBoxName).listenable();

  init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(WallpaperAdapter());
    await Hive.openBox<Wallpaper>(wallpaperBoxName);
  }

  Future<Wallpaper?> getWallpaper() async {
    final box = Hive.box<Wallpaper>(wallpaperBoxName);
    return box.get('wallpaper');
  }

  Future putWallpaper(Wallpaper wallpaper) async {
    final box = Hive.box<Wallpaper>(wallpaperBoxName);
    await box.put('wallpaper', wallpaper).then((value) {
      return true;
    });
  }
}
