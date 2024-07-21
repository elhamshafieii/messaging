import 'dart:async';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:messaging/common/utils/colors.dart';
import 'package:messaging/common/utils/utils.dart';
import 'package:messaging/common/widgets/loader.dart';
import 'package:messaging/models/message.dart';
import 'package:open_file_plus/open_file_plus.dart';

class DocumentDisplay extends StatefulWidget {
  final bool isMyMessage;
  const DocumentDisplay({
    super.key,
    required this.message,
    required this.isMyMessage,
  });

  final Message message;

  @override
  State<DocumentDisplay> createState() => _DocumentDisplayState();
}

class _DocumentDisplayState extends State<DocumentDisplay> {
  final Completer<PDFViewController> completer = Completer<PDFViewController>();
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    String formattedTime = DateFormat.Hm().format(widget.message.dateTime);
    return FutureBuilder<File>(
        future: DefaultCacheManager().getSingleFile(widget.message.text),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final String fileSuffix =
                getFileExtension(fileName: snapshot.data!);
            switch (fileSuffix) {
              case 'pdf':
                final pdfView = PDFView(
                  filePath: snapshot.data!.path,
                  enableSwipe: false,
                  swipeHorizontal: true,
                  autoSpacing: false,
                  pageFling: false,
                  onViewCreated: (PDFViewController pdfViewController) {
                    completer.complete(pdfViewController);
                  },
                );
                if (snapshot.hasData) {
                  return GestureDetector(
                    onTap: () async {
                      await OpenFile.open(snapshot.data!.path);
                    },
                    child: SizedBox(
                        height: 200,
                        child: Stack(children: [
                          pdfView,
                          Positioned(
                              bottom: 0,
                              right: 0,
                              left: 0,
                              child: Container(
                                height: 90,
                                decoration: BoxDecoration(
                                    color: widget.isMyMessage
                                        ? lightMyChatBubbleBackgroundColor
                                        : Colors.white),
                              )),
                          Positioned(
                              bottom: 20,
                              right: 0,
                              left: 0,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                height: 70,
                                decoration: BoxDecoration(
                                    color: widget.isMyMessage
                                        ? lightMyChatBubbleForgroundColor
                                        : Colors.grey.shade300,
                                    borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(6),
                                        bottomRight: Radius.circular(6))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(widget.message.fileName,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: themeData.textTheme.labelMedium),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Row(
                                      children: [
                                        getFileSize(snapshot, themeData),
                                        Text(
                                          ' kB . PDF',
                                          style: themeData.textTheme.labelSmall,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              )),
                          Positioned(
                            bottom: 0,
                            right: 10,
                            child: Text(
                              formattedTime,
                              style: themeData.textTheme.labelSmall,
                            ),
                          ),
                        ])),
                  );
                } else {
                  return SizedBox(
                    height: 100,
                    child: Center(
                      child: loader(radius: 10, color: lightTextColor),
                    ),
                  );
                }

              case 'docx':
                return GestureDetector(
                  onTap: () async {
                    await OpenFile.open(snapshot.data!.path);
                  },
                  child: SizedBox(
                    height: 90,
                    child: Stack(children: [
                      Positioned(
                        top: 0,
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: widget.isMyMessage
                                  ? lightMyChatBubbleForgroundColor
                                  : lightSenderChatBubbleForgroundColor,
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(6),
                                  bottomRight: Radius.circular(6))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.message.fileName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: themeData.textTheme.labelMedium),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                children: [
                                  Text(
                                    ' page . ',
                                    style: themeData.textTheme.labelSmall,
                                  ),
                                  getFileSize(snapshot, themeData),
                                  Text(
                                    ' kB . $fileSuffix',
                                    style: themeData.textTheme.labelSmall,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 10,
                        child: Text(
                          formattedTime,
                          style: themeData.textTheme.labelSmall,
                        ),
                      ),
                    ]),
                  ),
                );

              default:
                return GestureDetector(
                  onTap: () async {
                    await OpenFile.open(snapshot.data!.path);
                  },
                  child: SizedBox(
                    height: 90,
                    child: Stack(children: [
                      Positioned(
                        top: 0,
                        bottom: 20,
                        left: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              color: widget.isMyMessage
                                  ?lightMyChatBubbleForgroundColor
                                  : lightSenderChatBubbleForgroundColor,
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(6),
                                  bottomRight: Radius.circular(6))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(widget.message.fileName,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: themeData.textTheme.labelMedium),
                              const SizedBox(
                                height: 4,
                              ),
                              Row(
                                children: [
                                  getFileSize(snapshot, themeData),
                                  Text(
                                    ' . $fileSuffix',
                                    style: themeData.textTheme.labelSmall,
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 10,
                        child: Text(
                          formattedTime,
                          style: themeData.textTheme.labelSmall,
                        ),
                      ),
                    ]),
                  ),
                );
            }

            //return Text(fileSuffix);
          } else {
            return SizedBox(height: 90, child: Center(child: loader(radius: 10, color: lightTextColor)));
          }
        });
  }
}

getPdfViewPageCount(
    Completer<PDFViewController> completer, ThemeData themeData) {
  return FutureBuilder(
      future: completer.future,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return FutureBuilder(
              future: snapshot.data!.getPageCount(),
              builder: (context, snapshot1) {
                if (snapshot1.hasData) {
                  return Text(
                    snapshot1.data.toString(),
                    style: themeData.textTheme.labelSmall,
                  );
                } else {
                  return Container();
                }
              });
        } else {
          return Container();
        }
      });
}

getFileSize(AsyncSnapshot<File> snapshot, ThemeData themeData) {
  return FutureBuilder(
      future: snapshot.data!.length(),
      builder: ((context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data! / 1000 >= 1000) {
            return Text(
              '${double.parse((snapshot.data! / 1000000).toStringAsFixed(2))} MB',
              style: themeData.textTheme.labelSmall,
            );
          } else {
            return Text(
              '${snapshot.data! / 1000} kB',
              style: themeData.textTheme.labelSmall,
            );
          }
        } else {
          return Container();
        }
      }));
}
