import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:messaging/common/theme_manager.dart';
import 'package:messaging/common/utils/colors.dart';
import 'package:messaging/common/utils/utils.dart';
import 'package:messaging/common/widgets/error_screen.dart';
import 'package:messaging/common/widgets/loader.dart';
import 'package:messaging/data/hive_theme/hive_theme.dart';
import 'package:messaging/data/repository/chat_repository.dart';
import 'package:messaging/screens/setting/change_wallpaper/bloc/change_wallpaper_bloc.dart';
import 'package:messaging/screens/setting/change_wallpaper/choose_wallpaper_items.dart';

class ChangeWallpaperScreen extends StatelessWidget {
  const ChangeWallpaperScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final width = MediaQuery.of(context).size.width;
    ThemeEnum theme = themeManager.getTheme();
    return Scaffold(
      appBar: AppBar(
        title: Text('${theme.name} Theme Wallpaper'),
      ),
      body: BlocProvider<ChangeWallpaperBloc>(
        create: (BuildContext context) {
          final bloc = ChangeWallpaperBloc(
            chatRepository: chatRepository,
          );
          bloc.add(ChangeWallpaperStrted());
          return bloc;
        },
        child: BlocBuilder<ChangeWallpaperBloc, ChangeWallpaperState>(
          builder: (context, state) {
            if (state is ChangeWallpaperError) {
              return ErrorScreen(callback: () {
                BlocProvider.of<ChangeWallpaperBloc>(context)
                    .add(ChangeWallpaperStrted());
              });
            } else if (state is ChangeWallpaperLoading) {
              return Center(
                child:
                    Align(child: loader(radius: 30, color: lightAppBarColor)),
              );
            } else if (state is ChangeWallpaperSuccess) {
              final List<File> lightWallpaperFiles = [];
              final List<File> darkWallpaperFiles = [];
              final List<File> solidWallpaperFiles = [];
              final future = getwallpaperFiles(
                  state: state,
                  lightWallpaperFiles: lightWallpaperFiles,
                  darkWallpaperFiles: darkWallpaperFiles,
                  solidWallpaperFiles: solidWallpaperFiles);
              return FutureBuilder(
                future: future,
                builder:
                    (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.hasData) {
                    var (
                      lightWallpaperFiles,
                      darktWallpaperFiles,
                      solidWallpaperFiles
                    ) = snapshot.data;
                    return Column(children: [
                      SizedBox(
                        height: width * 1.1,
                        child: GridView.builder(
                            physics: defaultScrollPhysics,
                            padding: const EdgeInsets.all(12),
                            itemCount: 4,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio: 0.9, crossAxisCount: 2),
                            itemBuilder: (context, index) {
                              File file;
                              switch (index) {
                                case 0:
                                  file = lightWallpaperFiles[0];
                                  break;
                                case 1:
                                  file = darktWallpaperFiles[0];
                                  break;
                                case 2:
                                  file = solidWallpaperFiles[0];
                                  break;
                                default:
                                  file = lightWallpaperFiles[0];
                              }

                              List<File> wallPaperFiles = [];
                              switch (index) {
                                case 0:
                                  wallPaperFiles = lightWallpaperFiles;
                                  break;
                                case 1:
                                  wallPaperFiles = darktWallpaperFiles;
                                  break;
                                case 2:
                                  wallPaperFiles = solidWallpaperFiles;
                                  break;
                                default:
                                  wallPaperFiles = lightWallpaperFiles;
                              }

                              String titleString;
                              switch (index) {
                                case 0:
                                  titleString = 'Light';
                                  break;
                                case 1:
                                  titleString = 'Dark';
                                  break;
                                case 2:
                                  titleString = 'Solid';
                                  break;
                                default:
                                  titleString = 'My Files';
                              }
                              return GridViewItem(
                                width: width,
                                index: index,
                                file: file,
                                callback: () {
                                  Navigator.of(context).push(
                                      MaterialPageRoute(builder: (context) {
                                    return ChooseWallpaperItem(
                                      title: titleString,
                                      wallPaperFiles: wallPaperFiles,
                                    );
                                  }));
                                },
                              );
                            }),
                      ),
                      InkWell(
                        onTap: () async {
                          // BlocProvider.of<MobileChatScreenBloc>(context)
                          //     .add(MobileChatScreenStarted());
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.wallpaper_outlined,
                                color: lightAppBarColor,
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Text(
                                'Default Wallpaper',
                                style: themeData.textTheme.titleLarge!
                                    .copyWith(fontSize: 16),
                              )
                            ],
                          ),
                        ),
                      )
                    ]);
                  } else {
                    return Center(
                      child: loader(radius: 30, color: lightAppBarColor),
                    );
                  }
                },
              );
            } else {
              throw ('state is not supported');
            }
          },
        ),
      ),
    );
  }

  Future<(List<File>, List<File>, List<File>)> getwallpaperFiles(
      {required ChangeWallpaperSuccess state,
      required List<File> lightWallpaperFiles,
      required List<File> darkWallpaperFiles,
      required List<File> solidWallpaperFiles}) async {
    final List<String> lightWallpaperUrls = state.lightWallpaperUrls;
    final List<String> darkWallpaperUrls = state.darktWallpaperUrls;
    final List<String> solidWallpaperUrls = state.solidWallpaperUrls;
    for (var url in lightWallpaperUrls) {
      File file = await DefaultCacheManager().getSingleFile(url);
      lightWallpaperFiles.add(file);
    }
    for (var url in darkWallpaperUrls) {
      File file = await DefaultCacheManager().getSingleFile(url);
      darkWallpaperFiles.add(file);
    }
    for (var url in solidWallpaperUrls) {
      File file = await DefaultCacheManager().getSingleFile(url);
      solidWallpaperFiles.add(file);
    }
    return (lightWallpaperFiles, darkWallpaperFiles, solidWallpaperFiles);
  }
}

class GridViewItem extends StatelessWidget {
  final int index;
  final File file;
  final VoidCallback callback;
  const GridViewItem({
    super.key,
    required this.width,
    required this.index,
    required this.file,
    required this.callback,
  });

  final double width;

  @override
  Widget build(BuildContext context) {
    String title = '';
    switch (index) {
      case 0:
        title = 'Light';
        break;
      case 1:
        title = 'Dark';
        break;
      case 2:
        title = 'Solid Colors';
        break;
      case 3:
        title = 'My Photos';
        break;
      default:
    }
    return Column(
      children: [
        InkWell(
          onTap: callback,
          child: Container(
              width: (width * 0.8) / 2,
              height: (width * 0.8) / 2,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(24)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Image.file(
                  fit: BoxFit.cover,
                  file,
                ),
              )),
        ),
        const SizedBox(
          height: 12,
        ),
        Text(title)
      ],
    );
  }
}
