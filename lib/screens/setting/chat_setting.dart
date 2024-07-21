import 'package:flutter/material.dart';
import 'package:messaging/common/theme_manager.dart';
import 'package:messaging/common/utils/utils.dart';
import 'package:messaging/data/hive_theme/hive_theme.dart';
import 'package:messaging/screens/setting/change_wallpaper/change_wallpaper_screen.dart';
import 'package:messaging/screens/setting/theme_change_alert_dialog.dart';

class ChatSettingScreen extends StatefulWidget {
  final String title;

  const ChatSettingScreen({super.key, required this.title});

  @override
  State<ChatSettingScreen> createState() => _ChatSettingScreenState();
}

class _ChatSettingScreenState extends State<ChatSettingScreen> {
  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        physics: defaultScrollPhysics,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
              child: Text(
                'Dispaly',
                style: themeData.textTheme.bodyMedium!,
              ),
            ),
            InkWell(
              onTap: () {
                showDialog<ThemeEnum>(
                    //barrierDismissible: false,
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          'Choose Theme',
                          style: themeData.textTheme.titleLarge,
                        ),
                        content: const ThemeChangeAlertDialog(),
                      );
                    }).then((value) {
                  if (value != null) {
                    themeManager.putTheme(value);
                  }
                });
              },
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, left: 20, right: 20),
                child: Row(
                  children: [
                    const Icon(
                      Icons.brightness_6_outlined,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Column(
                      children: [
                        const Text('Theme'),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          themeManager.getTheme().name,
                          style: const TextStyle(color: Colors.grey),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            InkWell(
              onTap: () {
                 if (context.mounted) {
                   Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) {
                  return const ChangeWallpaperScreen();
                }));
                 }
              },
              child: const Padding(
                padding:
                    EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
                child: Row(
                  children: [
                    Icon(
                      Icons.wallpaper_outlined,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      'Wallpaper',
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
