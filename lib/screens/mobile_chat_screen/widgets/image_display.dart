import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:messaging/common/utils/colors.dart';
import 'package:messaging/common/widgets/loader.dart';
import 'package:messaging/models/message.dart';
import 'package:open_file_plus/open_file_plus.dart';

class ImageDisplay extends StatelessWidget {
  const ImageDisplay({
    super.key,
    required this.message,
  });

  final Message message;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: DefaultCacheManager().getSingleFile(message.text),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return GestureDetector(
              onTap: () async {
                File file =
                    await DefaultCacheManager().getSingleFile(message.text);
                await OpenFile.open(file.path);
              },
              child: Image.file(snapshot.data));
        } else {
          return SizedBox(
            height: 100,
            child: Center(
              child: loader(radius: 10, color: lightTextColor),
            ),
          );
        }
      },
    );
  }
}
