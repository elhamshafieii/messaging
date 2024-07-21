import 'package:flutter/material.dart';
import 'package:messaging/common/utils/colors.dart';
import 'package:messaging/common/widgets/custom_button.dart';
import 'package:messaging/screens/auth/login/login_screen.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Welcome To Messaging',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: size.height / 15,
            ),
            Image.asset(
              'assets/images/bg.png',
              color: tabColor,
              height: size.width - 50,
              width: size.width - 50,
            ),
            SizedBox(
              height: size.height / 15,
            ),
            const Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                'Read our Privacy Policy. Tap "Agree and continue" to accept the Terms of Service.',
                style: TextStyle(color: greyColor),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            CustomButton(
                text: 'AGREE AND CONTINUE',
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: ((context) {
                    return const LoginScreen();
                  })));
                })
          ],
        ),
      )),
    );
  }
}
