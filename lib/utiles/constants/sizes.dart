import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class TSizes {
  TSizes._();

  static double LargeSizeText = 24.sp;

  static double padOfScreen = 16.w;
  static double padbtWidgets = 25.h;
  static double padbttextLabel = 10.h;
  static double padbttextdescroption = 5.h;

  static double cartIconSize = 45.sp;
  static double normalIconSize = 24.sp;

  static double profilePictureW = 48.w;
  static double profilePictureH = 48.h;
  static double profileIconContainer = 48.h;
  static double profileIcon = 20.sp;
  static double searchHomeFirldW = 343.w;
  static double searchHomeFirldH = 48.w;

  static double fullContainerW = 343.w;
  static double adsContainerH = 135.w;

  static double homeProductW = 140.w;
  static double homeProductH = 142.w;
  static double productLabelS = 16.sp;
  static double headingSmallS = 12.sp;
  static double headingMediumS = 14.sp;
  // static double homeProductPriceS = 12.sp;

  static double productContainerW = 155.w;
  static double productContainerH = 178.h;
  static double pageTitleS = 16.sp;

  static double itemNameS = 20.sp;
  static double itemPriceS = 16.sp;
  static double itemReciewS = 12.sp;
  static double itemDescriptionS = 12.sp;
  static double addToCartW = 245.w;
  static double btnHeight = 48.h;
  static double iconContainerW = 90.w;
  static double iconContainerH = 48.w;

  static double cartContainerH = 110.h;
  static double cartItemH = 110.h;
  static double cartDetailH = 206.h;
  static var productLabelL = 20.sp;

  // CHECKOUT
  static double checkOutContainerH = 48.h;
}

// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:todo_app/data/Constants/colors.dart';

class KAppTypoGraphy {
  static final onBoadingTitleSize = 32.w;
  static final onBoadingDescriptionSize = 16.0.w;
  static final trigarLargeBtnWidth = 320.0.w;

  static TextStyle displayTitleLarge = TextStyle(
    color: KColors.txtColor,
    fontSize: 32.w,
    fontWeight: FontWeight.bold,
  );
  static TextStyle displayTitleMedium = TextStyle(
    color: KColors.txtColor,
    fontSize: 20.w,
    fontWeight: FontWeight.bold,
  );

  static TextStyle displayTitleSmall = TextStyle(
    color: KColors.txtColor,
    fontSize: 16.w,
    fontWeight: FontWeight.bold,
  );

  static TextStyle categoryTextStyle15M = TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 15.w,
    fontWeight: FontWeight.w400,
  );
  static TextStyle dayNumber14M = TextStyle(
    color: Colors.white,
    fontSize: 14.w,
    fontWeight: FontWeight.w400,
  );
  static TextStyle dayName15M = TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 12.w,
    fontWeight: FontWeight.w400,
  );

  static TextStyle categoryTextStyle14M = TextStyle(
    color: KColors.txtColor,
    fontSize: 14.w,
    fontWeight: FontWeight.w400,
  );

  static TextStyle descriptionLarge = TextStyle(
    color: KColors.txtColor,
    fontSize: 18.w,
    fontWeight: FontWeight.normal,
  );
  static TextStyle descriptionMedium = TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 16.w,
    fontWeight: FontWeight.normal,
  );
  static TextStyle deleteBtnMedium = TextStyle(
    color: Colors.red,
    fontSize: 16.w,
    fontWeight: FontWeight.normal,
  );
  static TextStyle description2Medium = TextStyle(
    color: KColors.hintTxtColor,
    fontSize: 16.w,
    fontWeight: FontWeight.normal,
  );

  static TextStyle descriptionHintTextLarge = TextStyle(
    color: KColors.hintTxtColor,
    fontSize: 18.w,
    fontWeight: FontWeight.normal,
  );
  static TextStyle descriptionHintTextMedium = TextStyle(
    color: KColors.hintTxtColor,
    fontSize: 12.w,
    fontWeight: FontWeight.normal,
  );
  static TextStyle dateTimeTextStyle14N = TextStyle(
    color: KColors.hintTxtColor,
    fontSize: 14.w,
    fontWeight: FontWeight.normal,
  );
  static TextStyle Month14N = TextStyle(
    color: KColors.txtColor,
    fontSize: 14.w,
    fontWeight: FontWeight.normal,
  );

  static TextStyle descriptionTextMedium = TextStyle(
    color: KColors.txtColor,
    fontSize: 12.w,
    fontWeight: FontWeight.normal,
  );
  static TextStyle year10N = TextStyle(
    color: KColors.hintTxtColor,
    fontSize: 12.w,
    fontWeight: FontWeight.normal,
  );
  // .....

  static TextStyle profileTitleStyle = TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 20.w,
    fontWeight: FontWeight.normal,
  );
  static TextStyle profileNameStyle = TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 20.w,
    fontWeight: FontWeight.w500,
  );
  static TextStyle profileLabelStyle = TextStyle(
    color: Color(0xFFAFAFAF),
    fontSize: 14.w,
    fontWeight: FontWeight.normal,
  );
  static TextStyle profileOptionStyleAndBtnText = TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 16.w,
    fontWeight: FontWeight.normal,
  );

  // .....Timer Coundown

  static TextStyle timerTextStyle = TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 40.w,
    fontWeight: FontWeight.w500,
  );

  static TextStyle dialogeText18Medium = TextStyle(
    color: Color(0xFFFFFFFF),
    fontSize: 18.w,
    fontWeight: FontWeight.w500,
  );
}

class KColors {
  // static const backGround = Color(0x000000);
  static const backGround = Color(0xFF121212);
  static const btn = Color(0xFF8687E7);
  static const txtColor = Colors.white;
  static const sendIconColor = Colors.purple;
  // static const hintTxtColor = Color(0xFF535353);
  static const hintTxtColor = Color(0xFFAFAFAF);
  static const bottomSheetColor = Color(0xFF363636);
  // static const bottomSheetColor = Color(0xFF363636);
  static const dividerColor = Color(0xFF979797);
  static const taskboxColor = Color(0xFF272727);
  static const inerTextFieldColor = Color(0xFF1D1D1D);
  static const timerFillRingColor = Color(0xFF8687E7);
}
