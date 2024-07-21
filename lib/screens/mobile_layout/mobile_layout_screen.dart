import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messaging/common/utils/utils.dart';
import 'package:messaging/models/user_model.dart';
import 'package:messaging/screens/chat_contact_list/chat_contact_list.dart';
import 'package:messaging/screens/mobile_layout/bloc/mobile_layout_bloc.dart';
import 'package:messaging/screens/mobile_layout/pop_up_menu_button/pop_up_menu.dart';
import 'package:messaging/screens/select_contact/select_contact_screen.dart';

class MobileLayoutScreen extends StatefulWidget {
  final File defaultWallpaperFile;
  final UserModel userModel;
  const MobileLayoutScreen({super.key, required this.userModel, required this.defaultWallpaperFile});

  @override
  State<MobileLayoutScreen> createState() => _MobileLayoutScreenState();
}

class _MobileLayoutScreenState extends State<MobileLayoutScreen>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        context.read<MobileLayoutBloc>().add(MobileLayoutResumed());
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.paused:
      case AppLifecycleState.hidden:
        context
            .read<MobileLayoutBloc>()
            .add(MobileLayoutInactiveDetachedPausedHidden());
        break;
    }
  }

  late TabController tabBarController;
  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    tabBarController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (tabBarController.index == 0) {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                return SelectContactScreen(
                  userModel: widget.userModel, defaultWallpaperFile: widget.defaultWallpaperFile,
                );
              }));
            }
          },
          child: const Icon(
            Icons.comment,
            color: Colors.white,
          ),
        ),
        appBar: AppBar(
          centerTitle: false,
          title: const Text(
            'Messaging',
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.camera_alt_outlined,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(
                Icons.search,
              ),
              onPressed: () {},
            ),
            const PopupMenuButtonScreen()
          ],
          bottom: TabBar(
            physics: defaultScrollPhysics,
            controller: tabBarController,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
            tabs: const [
              Tab(text: 'CHAtS'),
              Tab(text: 'STATUS'),
              Tab(text: 'CALLS')
            ],
          ),
        ),
        body: TabBarView(
          physics: defaultScrollPhysics,
          controller: tabBarController,
          children: [
            ChatContactsList(
              userModel: widget.userModel, defaultWallpaperFile: widget.defaultWallpaperFile,
            ),
            const Text('status'),
            const Text('calls'),
          ],
        ),
      ),
    );
  }
}
