import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vendoora_mart/features/user/home/controller/home_controller.dart';
// import 'package:vendoora_mart/features/user/home/screens/widgets/drawer.dart';
import 'package:vendoora_mart/helper/helper_functions.dart';
import 'package:vendoora_mart/utiles/constants/colors.dart';
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
          Material(
            elevation: 4,
            color: Colors.grey,
            shape: const CircleBorder(),
            child: Obx(() {
              final user = contr.currentUserModel.value;
              if (user == null) return const CircularProgressIndicator();
              final imageUrl = user.imageUrl ?? '';
              return Container(
                width: TSizes.profilePictureW,
                height: TSizes.profilePictureH,
                child: imageUrl.isNotEmpty
                    ? Image.network(imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Image.asset(TImageString.person))
                    : Image.asset(TImageString.person),
              );
              // return IconButton(
              //   icon: const Icon(Icons.menu, color: Colors.white),
              //   onPressed: () {
              //     // TODO: Implement menu action (drawer, dialog, etc.)
              //     HelperFunctions.navigateToScreen(
              //         context: context, screen: DemoMWDrawerScreen5());
              //     Get.snackbar("Menu", "Menu button clicked!",
              //         snackPosition: SnackPosition.TOP);
              //   },
              // );
            }),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hello 👋',
                    style: TextStyle(
                        fontSize: TSizes.headingSmallS,
                        fontWeight: FontWeight.w600)),
                Text(
                  FirebaseAuth.instance.currentUser?.email ?? 'No email',
                  style: TextStyle(
                      fontSize: TSizes.headingMediumS, color: Colors.grey[600]),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Icon(Icons.notifications_active_outlined,
              size: TSizes.profileIcon, color: TColors.IconColor),
        ],
      ),
    );
  }
}
