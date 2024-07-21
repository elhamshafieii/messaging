// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_theme.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ThemeEnumAdapter extends TypeAdapter<ThemeEnum> {
  @override
  final int typeId = 0;

  @override
  ThemeEnum read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ThemeEnum.system;
      case 1:
        return ThemeEnum.light;
      case 2:
        return ThemeEnum.dark;
      default:
        return ThemeEnum.system;
    }
  }

  @override
  void write(BinaryWriter writer, ThemeEnum obj) {
    switch (obj) {
      case ThemeEnum.system:
        writer.writeByte(0);
        break;
      case ThemeEnum.light:
        writer.writeByte(1);
        break;
      case ThemeEnum.dark:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeEnumAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
