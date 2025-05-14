import 'package:flutter/material.dart';
import 'package:vendoora_mart/utiles/theme/custom_theme/chip_theme.dart';
import 'package:vendoora_mart/utiles/theme/custom_theme/text_theme.dart';

import 'custom_theme/appbar_theme.dart';
import 'custom_theme/bottom_sheet_theme.dart';
import 'custom_theme/check_box_theme.dart';
import 'custom_theme/elevated_btn_theme.dart';
import 'custom_theme/outline_btn_theme.dart';
import 'custom_theme/text_field_theme.dart';

class TAppTheme {
  TAppTheme._();

  static ThemeData eCommerceAppTheme(
      {required BuildContext context,
      required Brightness brightnessLightOrDark,
      required Color outlineSideBorderBlueOrAccentblueColor,
      // required Color inputDecorationOPLightOrDarkTheme,
      required Color themeColorBaseOnBrightnessUsingAtManyNeededlocation,
      required Color themeOPColorBaseOnBrightnessUsingAtManyNeededLocation}) {
    return ThemeData(
        useMaterial3: true,
        fontFamily: 'Poppins',
        brightness: brightnessLightOrDark,
        primaryColor: Colors.blue,
        textTheme: TTextTheme.textMaterialAppLightOrDarkTheme(
            context: context,
            textColortheme:
                themeOPColorBaseOnBrightnessUsingAtManyNeededLocation),
        chipTheme: TChipTheme.chipThemeDataLightOrDark(
            context: context,
            chipOPColorLightOrDark:
                themeOPColorBaseOnBrightnessUsingAtManyNeededLocation),
        scaffoldBackgroundColor:
            themeColorBaseOnBrightnessUsingAtManyNeededlocation,
        appBarTheme: TAppbarTheme.appBarMaterialAppLightOrDarkTheme(
            context: context,
            appBareOPColorThemeLightOrDark:
                themeOPColorBaseOnBrightnessUsingAtManyNeededLocation),
        checkboxTheme:
            TCheckBoxTheme.checkboxLightOrDarkTheme(context: context),
        bottomSheetTheme: TBottomSheetTheme.bottomAppBarLightOrDarkTheme(
            context: context,
            bottomSheetColorsDarkOrLight:
                themeColorBaseOnBrightnessUsingAtManyNeededlocation),
        elevatedButtonTheme:
            TElevatedBtnTheme.elevatedBtnLightOrDarkTheme(context: context),
        outlinedButtonTheme: TOutlintTheme.outlinedButtonLightOrDarkThemeData(
            context: context,
            outlineBtnOPColorLightorDark:
                themeOPColorBaseOnBrightnessUsingAtManyNeededLocation,
            outlineSideBorderBlueOrAccentblueColor:
                outlineSideBorderBlueOrAccentblueColor),
        inputDecorationTheme: TTextFieldTheme.inputDecorationLightOrDarkTheme(
            context: context,
            inputDecorationOPLightOrDarkTheme:
                themeOPColorBaseOnBrightnessUsingAtManyNeededLocation));
  }
}
