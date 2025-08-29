import 'package:flutter/material.dart';

class AppStyle {
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: 30,
    vertical: 16,
  );
  static const EdgeInsets sreenPaddingHome = EdgeInsets.symmetric(
    horizontal: 35,
    vertical: 40,
  );
  static const EdgeInsets contentPadding = EdgeInsets.all(12);

  static const SizedBox h16 = SizedBox(height: 16);
  static const SizedBox w16 = SizedBox(width: 16);
  static const TextStyle appBarTitle = TextStyle(
    color: Colors.black,
    fontSize: 20,
  );
  static const TextStyle styleW900 = TextStyle(
    fontWeight: FontWeight.w900,
    fontSize: 19,
  );
  static const TextStyle style17Bold = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 17,
  );
}
