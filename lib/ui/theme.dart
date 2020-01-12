import 'package:flutter/material.dart';

//final mCustomTheme = ThemeData.from()

ThemeData themeData(BuildContext context) {
  return Theme.of(context).brightness == Brightness.light
      ? Theme.of(context).copyWith(
          primaryColor: Color(0xFFAEB6BF),
          highlightColor: Color(0xFF34495E),
          accentColor: Color(0xFF5D6D7E),
          backgroundColor: Color(0xFFeeeeee))
      : Theme.of(context).copyWith(
          primaryColor: Color(0xFFD2E3FC),
          highlightColor: Color(0xFF4285F4),
          accentColor: Color(0xFF8AB4F8),
          backgroundColor: Color(0xFF3C4043));
}
