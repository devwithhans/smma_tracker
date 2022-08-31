import 'package:flutter/material.dart';

class AppTextStyle {
  const AppTextStyle();
  static TextStyle smallRed = const TextStyle(color: Colors.red);

  static TextStyle medium = const TextStyle(fontSize: 16);
  static TextStyle small = const TextStyle();

  static TextStyle boldSmall =
      const TextStyle(fontSize: 16, fontWeight: FontWeight.w600);
  static TextStyle boldMedium =
      const TextStyle(fontSize: 20, fontWeight: FontWeight.w600);
  static TextStyle boldLarge =
      const TextStyle(fontSize: 40, fontWeight: FontWeight.w600);
}
