import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messaging/data/repository/auth_repository.dart';
import 'package:messaging/screens/landing/landing_screen.dart';
import 'package:messaging/screens/mobile_layout/pop_up_menu_button/bloc/pop_up_menu_bloc.dart';
import 'package:messaging/screens/setting/setting_screen/setting_screen.dart';

class PopupMenuButtonScreen extends StatelessWidget {
  const PopupMenuButtonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PopUpMenuBloc>(
      create: (context) {
        final bloc = PopUpMenuBloc(authRepository: authRepository);
        return bloc;
      },
      child: BlocBuilder<PopUpMenuBloc, PopUpMenuState>(
        builder: (context, state) {
          return PopupMenuButton(
            itemBuilder: (BuildContext context) {
              return [
                const PopupMenuItem(
                  child: Text(
                    'Create Group',
                  ),
                ),
                PopupMenuItem(
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return const SettingScreen();
                    }));
                  },
                  child: const Text(
                    'Setting',
                  ),
                ),
                PopupMenuItem(
                  onTap: () {
                    BlocProvider.of<PopUpMenuBloc>(context)
                        .add(PopUpMenuExitClicked());
                    Navigator.of(context).pushAndRemoveUntil(
                        (MaterialPageRoute(builder: (context) {
                          return const LandingScreen();
                        })),
                        (route) => true);
                  },
                  child: const Text(
                    'Exit',
                  ),
                )
              ];
            },
          );
        },
      ),
    );
  }
}
