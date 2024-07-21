import 'dart:io';

import 'package:flutter/material.dart';

class ProfilePhotoScreen extends StatelessWidget {
  final File imageFile;

  const ProfilePhotoScreen(
      {super.key, required this.imageFile});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile Photo'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Center(child: Image.file(imageFile)),
    );
  }
}
