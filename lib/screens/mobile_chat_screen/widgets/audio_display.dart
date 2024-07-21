import 'dart:async';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:messaging/common/utils/colors.dart';
import 'package:messaging/common/widgets/loader.dart';
import 'package:messaging/models/message.dart';

class AudioDisplay extends StatefulWidget {
  final Message message;
  const AudioDisplay({
    super.key,
    required this.message,
  });

  @override
  State<AudioDisplay> createState() => _AudioDisplayState();
}

class _AudioDisplayState extends State<AudioDisplay> {
  AudioPlayer player = AudioPlayer();
  Duration fileDuration = const Duration();
  PlayerState? _playerState;
  Duration? _duration;
  Duration? _position;
  bool get _isPlaying => _playerState == PlayerState.playing;
  bool get _isPaused => _playerState == PlayerState.paused;
  bool get _isCompleted => _playerState == PlayerState.completed;
  bool get _isStopped => _playerState == PlayerState.stopped;

  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerStateChangeSubscription;

  void _initStreams() {
    _durationSubscription = player.onDurationChanged.listen((duration) {
      setState(() => _duration = duration);
    });

    _positionSubscription = player.onPositionChanged.listen(
      (p) => setState(() => _position = p),
    );

    _playerCompleteSubscription = player.onPlayerComplete.listen((event) {
      setState(() {
        _playerState = PlayerState.stopped;
        _position = Duration.zero;
      });
    });

    _playerStateChangeSubscription =
        player.onPlayerStateChanged.listen((state) {
      setState(() {
        _playerState = state;
      });
    });
  }

  @override
  void initState() {
    initAudioPlayer();
    super.initState();
  }

  @override
  void setState(VoidCallback fn) {
    // Subscriptions only can be closed asynchronously,
    // therefore events can occur after widget has been disposed.
    if (mounted) {
      super.setState(fn);
    }
  }

  initAudioPlayer() async {
    //     WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   await player.setSource(DeviceFileSource(snapshot.data.path));
    // });
    _playerState = player.state;
    _duration = await player.getDuration();
    _position = await player.getCurrentPosition();
    _initStreams();
  }

  @override
  void dispose() {
    _durationSubscription?.cancel();
    _positionSubscription?.cancel();
    _playerCompleteSubscription?.cancel();
    _playerStateChangeSubscription?.cancel();
    player.dispose();
    super.dispose();
  }

  Future<void> _play() async {
    File file = await DefaultCacheManager().getSingleFile(widget.message.text);
    await player.play(DeviceFileSource(file.path));
    setState(() => _playerState = PlayerState.playing);
  }

  Future<void> _pause() async {
    await player.pause();
    setState(() => _playerState = PlayerState.paused);
  }

  @override
  Widget build(BuildContext context) {
    final themedata = Theme.of(context);
    return FutureBuilder<File>(
      future: DefaultCacheManager().getSingleFile(widget.message.text),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasData) {
          return Container(
              padding: const EdgeInsets.only(left: 4, right: 4),
              height: 70,
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.65,
                  minWidth: 35),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(
                        color: Colors.red, shape: BoxShape.circle),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.headphones,
                          color: Colors.white,
                        ),
                        FutureBuilder<Duration?>(
                            future: player.getDuration(),
                            builder: ((context, snapshot) {
                              if (snapshot.hasData) {
                                fileDuration = snapshot.data!;
                                if (_isPlaying || _isPaused) {
                                  return Text(
                                    '${_position!.inMinutes}:${(_position!.inSeconds) % 60}',
                                    style: themedata.textTheme.bodySmall,
                                  );
                                } else {
                                  return Text(
                                    '${fileDuration.inMinutes}:${(fileDuration.inSeconds) % 60}',
                                    style: themedata.textTheme.bodySmall,
                                  );
                                }
                              } else {
                                return Text(
                                  '${fileDuration.inMinutes}:${(fileDuration.inSeconds) % 60}',
                                  style: themedata.textTheme.bodySmall,
                                );
                              }
                            }))
                      ],
                    ),
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Expanded(
                    child: Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              if (_isPlaying) {
                                setState(() {
                                  _pause();
                                });
                              } else {
                                setState(() {
                                  _play();
                                });
                              }
                            },
                            child: Icon(
                              _isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.black54,
                              size: 34,
                            )),
                        Expanded(
                          child: SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: Colors.blue,
                              inactiveTrackColor: Colors.grey,
                              trackShape: const RectangularSliderTrackShape(),
                              trackHeight: 2.0,
                              thumbColor: Colors.orange,
                              thumbShape:
                                  const RoundSliderThumbShape(enabledThumbRadius: 6),
                              overlayColor: Colors.red.withAlpha(32),
                              overlayShape:
                                  const RoundSliderOverlayShape(overlayRadius: 12.0),
                            ),
                            child: Slider(
                              value: (_position != null &&
                                      _duration != null &&
                                      _position!.inMilliseconds > 0 &&
                                      _position!.inMilliseconds <
                                          _duration!.inMilliseconds)
                                  ? _position!.inMilliseconds /
                                      _duration!.inMilliseconds
                                  : 00.00,
                              onChanged: (double value) {
                                final duration = _duration;
                                if (duration == null) {
                                  return;
                                }
                                final position =
                                    value * duration.inMilliseconds;
                                player.seek(
                                    Duration(milliseconds: position.round()));
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ));
        } else {
          return SizedBox(
              height: 100,
              width: MediaQuery.of(context).size.width * 0.65,
              child: Center(child: loader( radius: 10, color: lightTextColor)));
        }
      },
    );
  }
}
