import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendoora_mart/utiles/constants/colors.dart';
import 'package:vendoora_mart/utiles/constants/sizes.dart';
import 'package:vendoora_mart/utiles/constants/txt_theme.dart';

class ProfileConatainerWidget extends StatelessWidget {
  const ProfileConatainerWidget(
      {super.key, required this.title, required this.icon, this.onTap});
  final String title;
  final Widget icon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 7.sp),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: TSizes.fullContainerW,
          height: 48.h,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: TColors.darkContainer),
          child: Row(
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.sp),
                  child: icon),
              Text(
                title,
                style: TTextStyle.labelTextStyle,
              ),
              Spacer(),
              Icon(
                Icons.arrow_forward_ios_sharp,
                size: 24.sp,
                color: TColors.labelName,
              )
            ],
          ),
        ),
      ),
    );
  }
}
