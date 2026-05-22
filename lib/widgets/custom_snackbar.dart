import 'package:flutter/material.dart';

class CustomSnackbar {
  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.blue.shade300.withValues(alpha: 0.7),
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height - 220,
          left: 10,
          right: 10,
        ),
      ),
    );
  }
}
