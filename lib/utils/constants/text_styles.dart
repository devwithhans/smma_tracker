import 'package:flutter/material.dart';

class AppTextStyle {
  const AppTextStyle();
  static TextStyle smallRed = const TextStyle(color: Colors.red);
  static TextStyle small = const TextStyle();
  static TextStyle medium = const TextStyle(fontSize: 16);
  static TextStyle mediumBold =
      const TextStyle(fontSize: 16, fontWeight: FontWeight.w600);

  static TextStyle largeBold =
      const TextStyle(fontSize: 40, fontWeight: FontWeight.w600);
}
