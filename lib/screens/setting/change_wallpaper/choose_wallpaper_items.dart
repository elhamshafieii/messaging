import 'dart:io';

import 'package:flutter/material.dart';
import 'package:messaging/common/utils/colors.dart';
import 'package:messaging/common/utils/utils.dart';
import 'package:messaging/common/utils/wallpaper_manager.dart';
import 'package:messaging/common/widgets/loader.dart';
import 'package:messaging/data/hive_wallpaper/hive_wallpaper.dart';

class ChooseWallpaperItem extends StatefulWidget {
  final List<File> wallPaperFiles;
  final String title;
  const ChooseWallpaperItem(
      {super.key, required this.title, required this.wallPaperFiles});

  @override
  State<ChooseWallpaperItem> createState() => _ChooseWallpaperItemState();
}

class _ChooseWallpaperItemState extends State<ChooseWallpaperItem> {
  bool isWallpaperSet = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(children: [
        GridView.builder(
            physics: defaultScrollPhysics,
            padding: const EdgeInsets.all(4),
            itemCount: widget.wallPaperFiles.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 4,
              crossAxisSpacing: 4,
              crossAxisCount: 3,
              childAspectRatio: 0.5,
            ),
            itemBuilder: (context, index) {
              return InkWell(
                onTap: () async {
                  setState(() {
                    isWallpaperSet = false;
                  });
                  await wallpaperManager.putWallpaper(Wallpaper(
                      wallpaperPath: widget.wallPaperFiles[index].path));
                  setState(() {
                    isWallpaperSet = true;
                  });
                  showSnackBar(
                      context: context, content: 'New wallpaper set ...');
                },
                child: Image.file(
                  widget.wallPaperFiles[index],
                  fit: BoxFit.cover,
                ),
              );
            }),
        isWallpaperSet
            ? const SizedBox()
            : Center(
                child: loader(radius: 30, color: lightAppBarColor),
              )
      ]),
    );
  }
}
