import 'package:flutter/material.dart';

import '../utiles/constants/colors.dart';

class IconBtnWidget extends StatelessWidget {
  const IconBtnWidget(
      {super.key,
      this.onTap,
      this.width = 28,
      this.height = 28,
      this.iconSize = 20,
      this.icon = Icons.add});
  final void Function()? onTap;
  final double width;
  final double height;
  final double iconSize;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
            onTap: onTap,
            child: Container(
                width: width,
                height: height,
                color: TColors.IconColor,
                child: Icon(icon, color: TColors.white))));
  }
}
