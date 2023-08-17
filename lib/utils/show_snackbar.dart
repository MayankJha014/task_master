import 'package:flutter/material.dart';

void showSnackbar(context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Padding(
        padding: const EdgeInsets.all(3.0),
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}
