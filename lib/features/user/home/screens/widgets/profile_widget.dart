import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vendoora_mart/features/user/home/controller/home_controller.dart';
import 'package:vendoora_mart/utiles/constants/image_string.dart';
import 'package:vendoora_mart/utiles/constants/sizes.dart';

class ProfileWidget extends StatelessWidget {
  const ProfileWidget({super.key});
  // final String url;

  @override
  Widget build(BuildContext context) {
    HomeController contr = Get.find();

    return Padding(
      padding: EdgeInsets.only(top: 64.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(30.sp),
            child: Obx(() {
              final user = contr.currentUserModel.value;

              print('>>>>> >>  $user');

              if (user == null) {
                return const CircularProgressIndicator(); // or a placeholder
              }

              final imageUrl = user.imageUrl ?? '';

              return Container(
                width: TSizes.profilePictureW,
                height: TSizes.profilePictureH,
                child: imageUrl.isNotEmpty
                    ? Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                              TImageString.person); // fallback on error
                        },
                      )
                    : Image.asset(TImageString.person),
              );
            }),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'hello!',
                style: TextStyle(fontSize: TSizes.headingSmallS),
              ),
              Text(
                FirebaseAuth.instance.currentUser?.email.toString() ??
                    'No emial',
                style: TextStyle(fontSize: TSizes.headingMediumS),
              ),
            ],
          ),
          SizedBox(
              width: TSizes.profileIconContainer,
              height: TSizes.iconContainerH,
              child: Icon(
                Icons.add_alert_sharp,
                size: TSizes.profileIcon,
              ))
        ],
      ),
    );
  }
}
