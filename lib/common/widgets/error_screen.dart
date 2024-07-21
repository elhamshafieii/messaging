import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  final VoidCallback callback;

  const ErrorScreen({super.key, required this.callback});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('Check Your Internet Connection ...'),
            const SizedBox(
              height: 16,
            ),
            GestureDetector(
              onTap: callback,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Please try again ...',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.white),
                  ),
                  const Icon(CupertinoIcons.refresh, color: Colors.white)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
