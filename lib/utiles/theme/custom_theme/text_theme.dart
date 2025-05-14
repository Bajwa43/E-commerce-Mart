import 'package:flutter/material.dart';

class TTextTheme {
  TTextTheme._();

  static TextTheme textMaterialAppLightOrDarkTheme(
      {required BuildContext context, required Color textColortheme}) {
    return TextTheme(
      // .
      headlineLarge: TextStyle().copyWith(
          fontSize: 32.0, fontWeight: FontWeight.bold, color: textColortheme),
      headlineMedium: TextStyle().copyWith(
          fontSize: 24.0, fontWeight: FontWeight.w600, color: textColortheme),
      headlineSmall: TextStyle().copyWith(
          fontSize: 16.0, fontWeight: FontWeight.w600, color: textColortheme),

      // ..
      titleLarge: TextStyle().copyWith(
          fontSize: 16.0, fontWeight: FontWeight.w600, color: textColortheme),
      titleMedium: TextStyle().copyWith(
          fontSize: 16.0, fontWeight: FontWeight.w500, color: textColortheme),
      titleSmall: TextStyle().copyWith(
          fontSize: 16.0, fontWeight: FontWeight.w400, color: textColortheme),

      // ...
      bodyLarge: TextStyle().copyWith(
          fontSize: 14.0, fontWeight: FontWeight.w500, color: textColortheme),
      bodyMedium: TextStyle().copyWith(
          fontSize: 14.0, fontWeight: FontWeight.normal, color: textColortheme),
      bodySmall: TextStyle().copyWith(
          fontSize: 14.0,
          fontWeight: FontWeight.w500,
          color: textColortheme.withOpacity(0.5)),

      // ....
      labelLarge: TextStyle().copyWith(
          fontSize: 12.0, fontWeight: FontWeight.normal, color: textColortheme),
      labelMedium: TextStyle().copyWith(
          fontSize: 12.0,
          fontWeight: FontWeight.normal,
          color: textColortheme.withOpacity(0.5)),
    );
  }

  // static TextTheme darkTextTheme = TextTheme();
}
