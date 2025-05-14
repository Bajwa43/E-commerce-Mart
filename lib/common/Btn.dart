import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendoora_mart/utiles/constants/colors.dart';
import 'package:vendoora_mart/utiles/constants/sizes.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget(
      {super.key,
      required this.widthOfContainer,
      // required this.heightOfContainer,
      required this.textOfBtn,
      this.onTap,
      this.isFocus = true});
  final double widthOfContainer;
  // final double heightOfContainer;
  final String textOfBtn;
  final Function()? onTap;
  final bool isFocus;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isFocus ? onTap : () {},
      child: Container(
        height: 45.h,
        width: widthOfContainer,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.sp),
          color: isFocus ? TColors.IconColor : TColors.grey,
        ),
        child: Center(
            child: Text(
          textOfBtn.toString(),
          style: TextStyle(fontSize: TSizes.productLabelL),
        )),
      ),
    );
  }
}
