import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utiles/constants/sizes.dart';

class TopAppBarWidget extends StatelessWidget {
  const TopAppBarWidget(
      {super.key,
      required this.label,
      this.onBackCLick,
      this.onMenuClick,
      this.isMenuShow = false});
  final String label;
  final void Function()? onBackCLick;
  final void Function()? onMenuClick;
  final bool isMenuShow;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton.filled(
          onPressed: onBackCLick,
          icon: Icon(
            Icons.arrow_back,
            size: TSizes.normalIconSize,
            color: Colors.black,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: TSizes.productLabelL,
            fontWeight: FontWeight.bold,
          ),
        ),
        isMenuShow
            ? IconButton(
                onPressed: onMenuClick,
                icon: Icon(
                  Icons.more_vert_rounded,
                  size: TSizes.normalIconSize,
                  color: Colors.black,
                ))
            : SizedBox(
                width: 25.w,
                height: 25.h,
              )
      ],
    );
  }
}
