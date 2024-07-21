import 'package:flutter/material.dart';

class OTPScreen extends StatelessWidget
{final String verificationId;
  const OTPScreen({super.key, required this.verificationId});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
    
        title: const Text('Verify your  number'),
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text('We have sent an SMS with a code.'),
            SizedBox(
              width: size.width * 0.5,
              child: TextField(
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  if (value.length == 6) {
                    Navigator.pop(context, value);
                  }
                },
                textAlign: TextAlign.center,
                decoration: const InputDecoration(
                    hintText: '- - - - - -',
                    hintStyle: TextStyle(fontSize: 30)),
              ),
            )
          ],
        ),
      ),
    );
  }
}