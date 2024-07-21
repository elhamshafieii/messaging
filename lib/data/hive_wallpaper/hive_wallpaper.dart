import 'package:hive_flutter/hive_flutter.dart';
part 'hive_wallpaper.g.dart';

@HiveType(typeId: 1)
class Wallpaper {
  @HiveField(0)
  final String wallpaperPath;
  Wallpaper({required this.wallpaperPath});
}
