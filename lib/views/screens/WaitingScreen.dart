import 'package:flutter/material.dart';

class WaitingScreen extends StatelessWidget {
  const WaitingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
