import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

showFlushBar(
    String title,
    BuildContext context,
    Color color1,
    ) {
  Flushbar(
    message: title,
    messageText: Text(
      title,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      textAlign: TextAlign.center,
    ),
    flushbarPosition: FlushbarPosition.TOP,
    flushbarStyle: FlushbarStyle.FLOATING,
    backgroundColor: color1,
    shouldIconPulse: false,
    boxShadows: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 2,
        blurRadius: 7,
        offset: const Offset(0, 2),
      ),
    ],

    duration: const Duration(seconds: 6),
    padding: const EdgeInsets.all(5),
    margin: const EdgeInsets.all(50),
    maxWidth: (70 / 100) * MediaQuery.of(context).size.width,
  ).show(context);
}