import 'package:flutter/material.dart';

class AppColor {
  //BRANDCOLOR

  static const MaterialColor purplePrimary = MaterialColor(
    _purplePrimaryValue,
    <int, Color>{
      50: Color(0xFFFFF0E5),
      100: Color(0xFFFFE1CC),
      200: Color(0xFFFFC399),
      300: Color(0xFFFFA566),
      400: Color(0xFFFF8733),
      500: Color(_purplePrimaryValue),
      600: Color(0xFFC75200),
      700: Color(0xFF8F3B00),
      800: Color(0xFF572400),
    },
  );

  static const int _purplePrimaryValue = 0xff7F2AA8;

  static const MaterialColor primaryColor = MaterialColor(
    _primaryColorValue,
    <int, Color>{
      50: Color(0xFFD7DEE4),
      100: Color(0xFF9BBDDD),
      200: Color(0xFF9BBDDD),
      300: Color(0xFF70A6D9),
      400: Color(0xFF5296D6),
      500: Color(_primaryColorValue),
      // 600: Color(0xFF8A0F14),
      // 700: Color(0xFF4F090C),
      // 800: Color(0xFF130203),
    },
  );
  static const int _primaryColorValue = 0xFF699CCC;

  static const MaterialColor secondColor = MaterialColor(
    _secondColorValue,
    <int, Color>{
      50: Color(0xFFFEF2F2),
      100: Color(0xFFFAD6D8),
      200: Color(0xFFF49FA3),
      300: Color(0xFFEE686D),
      400: Color(0xFFE83138),
      500: Color(_secondColorValue),
      600: Color(0xFF8A0F14),
      700: Color(0xFF4F090C),
      800: Color(0xFF130203),
    },
  );
  static const int _secondColorValue = 0xFFC6161D;

  //NEUTRAL
  static const MaterialColor bodyColor = MaterialColor(
    _bodyColorValue,
    <int, Color>{
      50: Color(0xFFFFFFFF),
      100: Color(0xFFFAFAFA),
      200: Color(0xFFE1E1E1),
      300: Color(0xFFC7C7C7),
      400: Color(0xFFAEAEAE),
      500: Color(0xFF949494),
      600: Color(0xFF787878),
      700: Color(0xFF5c5c5c),
      800: Color(0xFF404040),
      900: Color(0xFF242424),
    },
  );
  static const int _bodyColorValue = 0xFF242424;

  //ACCENT
  // PRIMARY COLOR
  static const Color purpleColor = Color(0xff7F2AA8);
  static const Color redColor = Color(0xffFF0000);
  static const Color brownColor = Color(0xffF08519);
  static const Color errorColor = Color(0xffFF0000); //Danger - Use for errors
  static const Color successColor = Color(0xff0B9444); //Succes - Use for Succes
  static const Color successColor2 = Color(0xff1EEB4B); //Succes 2 - Use for Succes
  static const Color warningColor = Color(0xffFFBC26);

  // BASE COLOR
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color whiteColor2 = Color(0xffF9F9F9);

  // SECONDARY COLOR
  static const Color secondaryColor = Color(0xff6C6C6C);
  static const Color secondaryColor2 = Color(0xff838383);

  // TEXT COLOR
  static const Color textBlackColor = Color(0xff292929);
  static const Color textWhiteColor = Color(0xffF8F8F8);



  static const Color weakColor =
      Color(0xFFBDBDBD); //Weak - Use for secondary text
  static const Color weak2Color =
      Color(0xFFF6F4F4); //Weak - Use for secondary text
  static const Color bgForm = Color(0xfff9f9f9);

  static const Color bluePrimary2 = Color(0xff29B7E8);

  //GRADIENT
  static const LinearGradient gradientPrimary = LinearGradient(colors: [
    Color(0xff7F2AA8),
    Color(0xffE10053),
  ], begin: Alignment.topLeft, end: Alignment.bottomRight);
  
  static const LinearGradient gradientPurple = LinearGradient(colors: [
    Color(0xFF7F2AA8),
    Color(0XFFE1A3FF),
  ], begin: Alignment.topLeft, end: Alignment.bottomRight);

  static const LinearGradient gradientRed = LinearGradient(colors: [
    Color(0xffFF0000),
    Color(0xff751111),
  ], begin: Alignment.topLeft, end: Alignment.bottomRight);

  static const LinearGradient gradientBrown = LinearGradient(colors: [
    Color(0xffF08519),
    Color(0xffFFB162),
  ], begin: Alignment.topLeft, end: Alignment.bottomRight);


  static BoxShadow shadow = BoxShadow(
    color: Colors.black.withValues(alpha:0.055),
    spreadRadius: 2,
    blurRadius: 7,
    offset: const Offset(3, 5),
  );
}
