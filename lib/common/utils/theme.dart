import 'package:flutter/material.dart';
import 'package:messaging/common/utils/colors.dart';
import 'package:messaging/data/hive_theme/hive_theme.dart';

ThemeData getThemeData({required ThemeEnum themeEnum}) {
  if (themeEnum == ThemeEnum.dark) {
    return ThemeData.dark().copyWith(
      colorScheme: const ColorScheme.dark(primary: tabColor),
      textTheme: const TextTheme(
          bodySmall: TextStyle(fontSize: 12),
          bodyMedium:
              TextStyle(fontSize: 15, color: Color.fromRGBO(37, 45, 49, 1))),
      appBarTheme: const AppBarTheme(
          backgroundColor: darkAppBarColor, foregroundColor: Colors.white),
      tabBarTheme: const TabBarTheme(
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: darkAppBarColor,
          labelColor: Colors.white,
          unselectedLabelColor: Color.fromARGB(255, 207, 205, 205)),
      scaffoldBackgroundColor: darkBackgroundColor,
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
        textStyle: WidgetStateProperty.all(
            const TextStyle(fontWeight: FontWeight.bold)),
        foregroundColor: WidgetStateProperty.all(tabColor),
      )),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: tabColor,
      ),
      snackBarTheme: const SnackBarThemeData(
          backgroundColor: darkAppBarColor,
          contentTextStyle: TextStyle(color: Colors.white)),
      cardTheme: const CardTheme(color: darkMessageColor),
    );
  } else {
    return ThemeData.light().copyWith(
      primaryColor: tabColor,
      colorScheme: const ColorScheme.light(primary: tabColor),
      textTheme: const TextTheme(
        titleLarge:
            TextStyle(fontSize: 23, color: Color.fromRGBO(37, 45, 49, 1)),
        bodySmall: TextStyle(fontSize: 12),
        bodyMedium:
            TextStyle(fontSize: 15, color: Color.fromRGBO(37, 45, 49, 1)),
        bodyLarge:
            TextStyle(fontSize: 18, color: Color.fromRGBO(37, 45, 49, 1)),
        labelSmall: TextStyle(fontSize: 12, color: Colors.grey),
        labelMedium:
            TextStyle(fontSize: 13, color: Color.fromRGBO(87, 96, 100, 1)),
      ),
      appBarTheme: const AppBarTheme(
          backgroundColor: lightAppBarColor, foregroundColor: Colors.white),
      tabBarTheme: const TabBarTheme(
          indicatorSize: TabBarIndicatorSize.tab,
          dividerColor: lightAppBarColor,
          labelColor: Colors.white,
          unselectedLabelColor: Color.fromARGB(255, 207, 205, 205)),
      scaffoldBackgroundColor: lightBackgroundColor,
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
        textStyle: WidgetStateProperty.all(
            const TextStyle(fontWeight: FontWeight.bold)),
        foregroundColor: WidgetStateProperty.all(tabColor),
      )),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: tabColor,
      ),
      snackBarTheme: const SnackBarThemeData(
          backgroundColor: lightAppBarColor,
          contentTextStyle: TextStyle(color: Colors.white)),
      cardTheme: const CardTheme(color: lightMessageColor),
    );
  }
}
