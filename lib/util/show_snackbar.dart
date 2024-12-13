import 'package:flutter/material.dart';

void showSnackBar(
    {required BuildContext context,
    required String message,
    Color backgroundColor = Colors.red,
    Duration duration = const Duration(seconds: 5)}) {
  // showing snackbar here
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(message),
    backgroundColor: backgroundColor,
    duration: duration,
  ));
}
