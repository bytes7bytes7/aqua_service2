import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../constants/colors.dart' as constant_colors;

ThemeData lightTheme = ThemeData(
  primaryColor: constant_colors.primaryColor,
  shadowColor: constant_colors.shadowColor,
  scaffoldBackgroundColor: constant_colors.scaffoldBackgroundColor,
  disabledColor: constant_colors.disabledColor,
  errorColor: constant_colors.errorColor,
  textTheme: const TextTheme(
    headline1: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: constant_colors.shadowColor,
    ),
    headline2: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.bold,
      color: constant_colors.shadowColor,
    ),
    bodyText1: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.normal,
      color: constant_colors.shadowColor,
    ),
    subtitle1: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.normal,
      color: constant_colors.shadowColor,
    ),
  ),
);
