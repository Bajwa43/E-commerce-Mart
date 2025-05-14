import 'package:flutter/material.dart';

class TOutlintTheme {
  TOutlintTheme._();

  static OutlinedButtonThemeData outlinedButtonLightOrDarkThemeData(
      {required BuildContext context,
      required Color outlineBtnOPColorLightorDark,
      required Color outlineSideBorderBlueOrAccentblueColor}) {
    return OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
            elevation: 0,
            foregroundColor: outlineBtnOPColorLightorDark,
            textStyle: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: outlineBtnOPColorLightorDark),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14))));
  }
}
