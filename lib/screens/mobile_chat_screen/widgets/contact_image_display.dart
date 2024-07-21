import 'dart:io';

import 'package:flutter/material.dart';

class ContactImageDisplay extends StatelessWidget {
  final String contactName;
  final File imageFile;

  const ContactImageDisplay(
      {super.key, required this.imageFile, required this.contactName});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(contactName),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Center(child: Image.file(imageFile)),
    );
  }
}
