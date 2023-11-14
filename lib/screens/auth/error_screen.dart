import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen(this.error, this.stacktrace, {super.key});
  final Object error;
  final StackTrace stacktrace;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text(error.toString())),
    );
  }
}
