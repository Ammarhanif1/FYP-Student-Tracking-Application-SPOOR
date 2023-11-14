import 'dart:async';

import 'package:flutter/material.dart';

import 'package:fyp/screens/auth/app_screen.dart';

// ?? @SupremeDeity: Tip. Refer to [https://pub.dev/packages/flutter_native_splash]
// for a better replacement.

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(seconds: 5),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const AppScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff5c5cff),
        body: Column(
          children: [
            const SizedBox(height: 180),
            Center(
              child: SizedBox(
                height: 320,
                width: 250,
                child: Image.asset(
                  "assets/images/logo.png",
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
