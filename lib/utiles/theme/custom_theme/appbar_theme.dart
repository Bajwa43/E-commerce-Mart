import 'package:flutter/material.dart';

class TAppbarTheme {
  TAppbarTheme._();

  static AppBarTheme appBarMaterialAppLightOrDarkTheme(
      {required BuildContext context,
      required Color appBareOPColorThemeLightOrDark}) {
    return AppBarTheme(
      elevation: 0,
      centerTitle: false,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.black, size: 24),
      actionsIconTheme:
          IconThemeData(color: appBareOPColorThemeLightOrDark, size: 24),
      titleTextStyle: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
          color: appBareOPColorThemeLightOrDark),
    );
  }
}
