import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendoora_mart/features/user/home/controller/home_controller.dart';
import 'package:vendoora_mart/utiles/constants/sizes.dart';

class AdsCrouselSliderWidget extends StatelessWidget {
  const AdsCrouselSliderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: TSizes.fullContainerW,
      height: TSizes.adsContainerH,
      child: CarouselView(
          scrollDirection: Axis.horizontal,
          itemExtent: double.infinity,
          children: List.generate(
            HomeController.adsList.length,
            (index) {
              return HomeController.adsList[index];
            },
          )),
    );
  }
}
