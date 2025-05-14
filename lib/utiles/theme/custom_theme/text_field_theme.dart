import 'package:flutter/material.dart';

class TTextFieldTheme {
  TTextFieldTheme._();

  static InputDecorationTheme inputDecorationLightOrDarkTheme(
      {required BuildContext context,
      required Color inputDecorationOPLightOrDarkTheme}) {
    return InputDecorationTheme(
      errorMaxLines: 3,
      //
      prefixIconColor: Colors.grey,
      suffixIconColor: Colors.grey,
      //
      labelStyle: TextStyle()
          .copyWith(fontSize: 14, color: inputDecorationOPLightOrDarkTheme),
      hintStyle: TextStyle()
          .copyWith(fontSize: 14, color: inputDecorationOPLightOrDarkTheme),
      errorStyle: TextStyle().copyWith(fontStyle: FontStyle.normal),
      floatingLabelStyle: TextStyle()
          .copyWith(color: inputDecorationOPLightOrDarkTheme.withOpacity(0.8)),
      //
      border: OutlineInputBorder().copyWith(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(width: 1, color: Colors.grey)),
      enabledBorder: OutlineInputBorder().copyWith(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(width: 1, color: Colors.grey)),
      focusedBorder: OutlineInputBorder().copyWith(
          borderRadius: BorderRadius.circular(14),
          borderSide:
              BorderSide(width: 1, color: inputDecorationOPLightOrDarkTheme)),
      errorBorder: OutlineInputBorder().copyWith(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(width: 1, color: Colors.red)),
      focusedErrorBorder: OutlineInputBorder().copyWith(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(width: 2, color: Colors.orange)),
    );
  }
}
