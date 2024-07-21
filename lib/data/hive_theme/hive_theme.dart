import 'package:hive_flutter/hive_flutter.dart';
part 'hive_theme.g.dart';

@HiveType(typeId: 0)
enum ThemeEnum {
  @HiveField(0)
  system,
  @HiveField(1)
  light,
  @HiveField(2)
  dark,
}
