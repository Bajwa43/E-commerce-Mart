import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vendoora_mart/utiles/constants/colors.dart';
import 'package:vendoora_mart/utiles/constants/sizes.dart';
import 'package:vendoora_mart/utiles/constants/txt_theme.dart';

class CheckOutWidget extends StatelessWidget {
  const CheckOutWidget(
      {super.key,
      required this.title,
      required this.imageUrl,
      required this.colorLogoContainer,
      this.onTap});
  final String title;
  final String imageUrl;
  final Color colorLogoContainer;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5.h),
      child: InkWell(
        onTap: onTap,
        child: Container(
          // color: Colors.amber,
          width: TSizes.fullContainerW,
          height: TSizes.checkOutContainerH,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  width: 55.w,
                  height: 48.h,
                  decoration: BoxDecoration(
                      color: colorLogoContainer,
                      borderRadius: BorderRadius.all(Radius.circular(40))),
                  child: Center(
                    child: Image.asset(
                      imageUrl.toString(),
                      fit: BoxFit.fill,
                    ),
                  )),
              Padding(
                padding: EdgeInsets.only(left: 10.sp),
                child: Text(
                  title,
                  style: TTextStyle.labelCheckOutTextStyle,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
