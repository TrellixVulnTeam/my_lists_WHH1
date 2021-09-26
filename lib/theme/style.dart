import 'package:flutter/material.dart';
import 'package:my_lists/constants.dart';

ThemeData appTheme() {
  return ThemeData(
    primaryColor: kPrimaryColour,
    // visualDensity: VisualDensity.adaptivePlatformDensity,
    scaffoldBackgroundColor: kPrimaryColour,
    fontFamily: 'Roboto',
    textTheme: TextTheme(
      bodyText1: TextStyle(color: kPrimaryTextColour),
      bodyText2: TextStyle(color: kSecondaryTextColour),
      subtitle1: TextStyle(color: kPrimaryTextColour),
    ).apply(bodyColor: kPrimaryTextColour, displayColor: kSecondaryTextColour),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(),
    ),
  );
}
