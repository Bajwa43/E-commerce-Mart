import 'package:flutter/material.dart';

class TBottomSheetTheme {
  TBottomSheetTheme._();

  static BottomSheetThemeData bottomAppBarLightOrDarkTheme(
      {required BuildContext context,
      required Color bottomSheetColorsDarkOrLight}) {
    return BottomSheetThemeData(
        showDragHandle: true,
        backgroundColor: bottomSheetColorsDarkOrLight,
        modalBackgroundColor: bottomSheetColorsDarkOrLight,
        constraints: BoxConstraints(minWidth: double.infinity),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)));
  }
}
