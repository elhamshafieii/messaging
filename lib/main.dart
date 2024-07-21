import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:messaging/common/theme_manager.dart';
import 'package:messaging/common/utils/colors.dart';
import 'package:messaging/common/utils/theme.dart';
import 'package:messaging/common/utils/wallpaper_manager.dart';
import 'package:messaging/common/widgets/error_screen.dart';
import 'package:messaging/common/widgets/loader.dart';
import 'package:messaging/data/hive_theme/hive_theme.dart';
import 'package:messaging/data/repository/auth_repository.dart';
import 'package:messaging/data/repository/chat_repository.dart';
import 'package:messaging/screens/landing/landing_screen.dart';
import 'package:messaging/screens/main/bloc/main_bloc.dart';
import 'package:messaging/screens/mobile_layout/bloc/mobile_layout_bloc.dart';
import 'package:messaging/screens/mobile_layout/mobile_layout_screen.dart';
import 'package:messaging/screens/user_information/user_information_screen.dart';
import 'firebase_options.dart';

Future<void> main() async {
  await themeManager.init();
  await wallpaperManager.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Box<ThemeEnum>>(
      valueListenable: themeManager.listenable,
      builder: (BuildContext context, Box<ThemeEnum> box, Widget? child) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<MobileLayoutBloc>(create: (context) {
              final mobileLayoutBloc = MobileLayoutBloc(
                authRepository: authRepository,
              );
              return mobileLayoutBloc;
            }),
          ],
          child: MaterialApp(
              title: 'Flutter Demo',
              debugShowCheckedModeBanner: false,
              theme:
                  getThemeData(themeEnum: box.get('theme') ?? ThemeEnum.system),
              home: BlocProvider<MainBloc>(
                create: (context) {
                  final bloc = MainBloc(
                      authRepository: authRepository,
                      chatRepository: chatRepository);
                  bloc.add(MainStarted());
                  return bloc;
                },
                child: BlocBuilder<MainBloc, MainState>(
                  builder: (context, state) {
                    if (state is MainLoading) {
                      return Container(
                        color: lightBackgroundColor,
                        child: Center(
                          child: loader(radius: 30, color: lightAppBarColor),
                        ),
                      );
                    } else if (state is MainError) {
                      return ErrorScreen(callback: () {
                        BlocProvider.of<MainBloc>(context).add(MainStarted());
                      });
                    } else if (state is MainSuccess) {
                      if (state.userModel == null) {
                        return const LandingScreen();
                      } else {
                        if (state.userModel!.name.isEmpty) {
                          return  UserInformationScreen(defaultWallpaperFile: state.defaultWallpaperFile,);
                        } else {
                          return MobileLayoutScreen(
                              userModel: state.userModel!, defaultWallpaperFile: state.defaultWallpaperFile,);
                        }
                      }
                    } else {
                      throw ('state is not supported');
                    }
                  },
                ),
              )),
        );
      },
    );
  }
}
