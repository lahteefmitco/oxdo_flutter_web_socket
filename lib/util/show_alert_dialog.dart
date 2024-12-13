import 'package:flutter/material.dart';

void showAlertDialog(
    {required BuildContext context,
    required String message,
    required VoidCallback callback,
    required VoidCallback listenClickOutside}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => PopScope(
      onPopInvokedWithResult: (result, value) {
        listenClickOutside();
      },
      child: AlertDialog(
        title: const Text("You can't connect"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: callback,
            style: TextButton.styleFrom(
              foregroundColor: Colors.amber,
            ),
            child: const Text("OK"),
          )
        ],
      ),
    ),
  );
}
