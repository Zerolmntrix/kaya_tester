import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import 'constants.dart';

void showMessage(BuildContext context, String msg) {
  Flushbar(
    icon: const Icon(Icons.info_outline, size: 28.0, color: kPrimaryColor),
    maxWidth: 350,
    flushbarPosition: FlushbarPosition.TOP,
    flushbarStyle: FlushbarStyle.FLOATING,
    message: msg,
    leftBarIndicatorColor: kPrimaryColor,
    duration: const Duration(seconds: 3),
    margin: const EdgeInsets.all(12),
    borderRadius: BorderRadius.circular(8),
  ).show(context);
}

void printInfo(String text) {
  print('\x1B[34m$text\x1B[0m');
}

void printWarning(String text) {
  final String msg = 'Warning: $text';
  print('\x1B[33m$msg\x1B[0m');
}

void printError(String text) {
  final String msg = 'Error: $text';
  print('\x1B[31m$msg\x1B[0m');
}
