import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendoora_mart/utiles/constants/sizes.dart';
import 'package:vendoora_mart/utiles/constants/txt_theme.dart';

class TextValueWidget extends StatelessWidget {
  const TextValueWidget(
      {super.key,
      required this.label,
      required this.value,
      this.isHighlighted = false});
  final String label;
  final String value;
  final isHighlighted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isHighlighted
                ? TTextStyle.labelTextStyle
                : TTextStyle.brandTextStyle,
          ),
          Text(
            value,
            style: isHighlighted
                ? TTextStyle.labelTextStyle
                : TTextStyle.brandTextStyle,
          )
        ],
      ),
    );
  }
}
