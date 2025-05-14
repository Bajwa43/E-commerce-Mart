import 'package:flutter/material.dart';

class TElevatedBtnTheme {
  TElevatedBtnTheme._();

  static ElevatedButtonThemeData elevatedBtnLightOrDarkTheme(
      {required BuildContext context}) {
    return ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
            elevation: 0,
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            disabledForegroundColor: Colors.grey,
            disabledBackgroundColor: Colors.grey,
            side: BorderSide(color: Colors.blue),
            padding: EdgeInsets.symmetric(vertical: 18),
            textStyle: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600,
                color: Colors.white),
            shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.circular(12))));
  }
}
