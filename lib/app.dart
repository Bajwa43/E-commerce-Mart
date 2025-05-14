import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:vendoora_mart/features/auth/auth_wraper.dart';
import 'package:vendoora_mart/features/auth/screens/loginScreen.dart';
import 'package:vendoora_mart/features/auth/screens/registration.dart';
import 'package:vendoora_mart/features/auth/screens/dayn_night_animate.dart';
import 'package:vendoora_mart/features/user/home/screens/home_screen.dart';
import 'package:vendoora_mart/features/vendor/add_Product/vender_add_item_screen.dart';
import 'package:vendoora_mart/features/vendor/home/screens/vendor_home_Screen.dart';
import 'package:vendoora_mart/utiles/constants/colors.dart';

import 'utiles/theme/theme.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 640),
      builder: (context, child) => GetMaterialApp(
        themeMode: ThemeMode.system,
        // theme: TAppTheme.eCommerceAppTheme(context: context, brightnessLightOrDark: Br, outlineSideBorderBlueOrAccentblueColor: outlineSideBorderBlueOrAccentblueColor, themeColorBaseOnBrightnessUsingAtManyNeededlocation: themeColorBaseOnBrightnessUsingAtManyNeededlocation, themeOPColorBaseOnBrightnessUsingAtManyNeededLocation: themeOPColorBaseOnBrightnessUsingAtManyNeededLocation),
        darkTheme: TAppTheme.eCommerceAppTheme(
            context: context,
            brightnessLightOrDark: Brightness.dark,
            outlineSideBorderBlueOrAccentblueColor: Colors.blueAccent,
            themeColorBaseOnBrightnessUsingAtManyNeededlocation: TColors.accent,
            themeOPColorBaseOnBrightnessUsingAtManyNeededLocation:
                Colors.white),
        // home: const UserHomeScreen(),
        // home: const VendorHomeScreen(),
        // home: const LoginScreen(),
        // home: RegistrationScreen(),
        home: AuthWrapper(),
        // home: DayAndNightLoginAnimation(),

        // home: const SeeAllProductsScreen(productType: TTextString.clotheCategory),

        // getPages: [],
      ),
    );
  }
}
