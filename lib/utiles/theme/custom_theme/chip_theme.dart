import 'package:flutter/material.dart';

class TChipTheme {
  TChipTheme._();

  static ChipThemeData chipThemeDataLightOrDark(
      {required BuildContext context, required Color chipOPColorLightOrDark}) {
    return ChipThemeData(
      disabledColor: Colors.grey,
      labelStyle: TextStyle(color: chipOPColorLightOrDark),
      selectedColor: Colors.blue,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      checkmarkColor: Colors.white,
    );
  }
}
