import 'package:flutter/material.dart';
import 'package:messaging/common/theme_manager.dart';
import 'package:messaging/data/hive_theme/hive_theme.dart';

class ThemeChangeAlertDialog extends StatefulWidget {
  const ThemeChangeAlertDialog({
    super.key,
  });

  @override
  State<ThemeChangeAlertDialog> createState() => _ThemeChangeAlertDialogState();
}

class _ThemeChangeAlertDialogState extends State<ThemeChangeAlertDialog> {
  ThemeEnum theme = themeManager.getTheme();
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    return SizedBox(
      height: 180,
      child: Column(
        children: [
          RadioListTile<ThemeEnum>(
            title: Text(
              'System default',
              style: themeData.dialogTheme.contentTextStyle,
            ),
            groupValue: theme,
            onChanged: (ThemeEnum? value) async {
              await themeManager.putTheme(ThemeEnum.system);
              theme = ThemeEnum.system;
              setState(() {});
              if (context.mounted) {
                Navigator.of(context).pop(value);
              }
            },
            value: ThemeEnum.system,
          ),
          RadioListTile<ThemeEnum>(
            title: Text(
              'Light',
              style: themeData.dialogTheme.contentTextStyle,
            ),
            groupValue: theme,
            onChanged: (ThemeEnum? value) async {
              await themeManager.putTheme(ThemeEnum.light);
              theme = ThemeEnum.light;
              setState(() {});
              if (context.mounted) {
                Navigator.of(context).pop(value);
              }
            },
            value: ThemeEnum.light,
          ),
          RadioListTile<ThemeEnum>(
            title: Text(
              'Dark',
              style: themeData.dialogTheme.contentTextStyle,
            ),
            groupValue: theme,
            onChanged: (ThemeEnum? value) async {
              await themeManager.putTheme(ThemeEnum.dark);
              theme = ThemeEnum.dark;
              setState(() {});
              if (context.mounted) {
                Navigator.of(context).pop(value);
              }
            },
            value: ThemeEnum.dark,
          ),
        ],
      ),
    );
  }
}
