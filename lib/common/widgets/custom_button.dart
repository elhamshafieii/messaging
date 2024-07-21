
import 'package:flutter/material.dart';
import 'package:messaging/common/utils/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          minimumSize: WidgetStateProperty.all(
              Size(MediaQuery.of(context).size.width * 0.75, 50)),
          backgroundColor: WidgetStateProperty.all(tabColor),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              // Change your radius here
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: blackColor,
          ),
        ));
  }
}
