import 'package:flutter/material.dart';
import 'package:vendoora_mart/utiles/constants/colors.dart';
import 'package:vendoora_mart/utiles/constants/sizes.dart';

class TTextStyle {
  static TextStyle profileHeader = TextStyle(
      fontSize: TSizes.LargeSizeText,
      color: Colors.black,
      fontWeight: FontWeight.w500);

  static TextStyle tableHeader = TextStyle(
      fontSize: TSizes.productLabelL,
      color: Colors.black,
      fontWeight: FontWeight.w500);
  static TextStyle labelTextStyle = TextStyle(
    fontSize: TSizes.headingMediumS,
    color: TColors.labelName,
    fontWeight: FontWeight.w500,
    // fontFamily: 'Poppins'
  );
  static TextStyle labelCheckOutTextStyle = TextStyle(
    fontSize: TSizes.headingMediumS,
    color: TColors.labelName,
    fontWeight: FontWeight.w600,
    // fontFamily: 'Poppins'
  );

  static TextStyle OrderPaymentTextStyle = TextStyle(
    fontSize: TSizes.productLabelS,
    color: TColors.labelName,
    fontWeight: FontWeight.w600,
    // fontFamily: 'Poppins'
  );

  static TextStyle brandTextStyle = TextStyle(
    fontSize: TSizes.headingSmallS,
    color: TColors.labelBrand,
    fontWeight: FontWeight.w500,
    // fontFamily: 'Poppins'
  );
  static TextStyle priceTextStyle = TextStyle(
    fontSize: TSizes.headingSmallS,
    color: TColors.IconColor,
    fontWeight: FontWeight.w500,
    // fontFamily: 'Poppins'
  );
}
