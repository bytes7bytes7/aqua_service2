import 'package:flutter/material.dart';
import '../constants/constant_colors.dart';

ThemeData lightTheme = ThemeData(
  primaryColor: ConstantColors.primaryColor,
  shadowColor: ConstantColors.shadowColor,
  scaffoldBackgroundColor: ConstantColors.scaffoldBackgroundColor,
  disabledColor: ConstantColors.disabledColor,
  errorColor: ConstantColors.errorColor,
  textTheme: const TextTheme(
    headline1: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: ConstantColors.shadowColor,
    ),
    headline2: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.bold,
      color: ConstantColors.shadowColor,
    ),
    subtitle1: TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.normal,
      color: ConstantColors.shadowColor,
    ),
    bodyText1: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.normal,
      color: ConstantColors.shadowColor,
    ),
  ),
);