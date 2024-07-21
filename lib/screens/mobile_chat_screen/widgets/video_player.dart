import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:messaging/common/utils/colors.dart';
import 'package:messaging/common/widgets/loader.dart';
import 'package:messaging/models/message.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerWidget extends StatefulWidget {
  const VideoPlayerWidget({
    super.key,
    required this.message,
  });

  final Message message;

  @override
  State<VideoPlayerWidget> createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;

  @override
  void initState() {
    if (mounted) {
      initialVideoPlayer();
    }
    super.initState();
  }

  initialVideoPlayer() async {
    videoPlayerController = await cacheFile();
    videoPlayerController!
      ..initialize().then((value) {
        setState(() {
          chewieController = ChewieController(
            videoPlayerController: videoPlayerController!,
            autoPlay: false,
            looping: false,
          );
        });
      });
  }

  Future<VideoPlayerController?> cacheFile() async {
    File file = await DefaultCacheManager().getSingleFile(widget.message.text);
    VideoPlayerController? controller = VideoPlayerController.file(file);
    return controller;
  }

  @override
  void dispose() {
    if (videoPlayerController != null) {
      videoPlayerController!.dispose();
    }
    if (chewieController != null) {
      chewieController!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (chewieController != null && videoPlayerController != null) {
      return SizedBox(
        width: MediaQuery.of(context).size.width * 0.65,
        child: AspectRatio(
          aspectRatio: videoPlayerController!.value.aspectRatio,
          child: Chewie(
            controller: chewieController!,
          ),
        ),
      );
    } else {
      return SizedBox(height: 100, child: Center(child: loader( radius: 10, color: lightTextColor)));
    }
  }
}
