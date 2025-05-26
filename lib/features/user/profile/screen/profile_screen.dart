import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vendoora_mart/features/admin/controller/admin_controller.dart';
import 'package:vendoora_mart/features/auth/auth_wraper.dart';
import 'package:vendoora_mart/features/auth/domain/models/user_model.dart';
import 'package:vendoora_mart/features/auth/screens/loginScreen.dart';
import 'package:vendoora_mart/features/user/home/controller/home_controller.dart';
import 'package:vendoora_mart/features/user/home/controller/product_cart_controller.dart';
import 'package:vendoora_mart/features/user/profile/widget/profile_containers_widget.dart';
import 'package:vendoora_mart/features/vendor/controller/vender_controller.dart';
import 'package:vendoora_mart/helper/firebase_helper/firebase_helper.dart';
import 'package:vendoora_mart/helper/helper_functions.dart';
import 'package:vendoora_mart/services/auth_service.dart';
import 'package:vendoora_mart/utiles/constants/colors.dart';
import 'package:vendoora_mart/utiles/constants/image_string.dart';
import 'package:vendoora_mart/utiles/constants/sizes.dart';
import 'package:vendoora_mart/utiles/constants/txt_theme.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/route_manager.dart';
import 'package:vendoora_mart/features/auth/screens/dayn_night_animate.dart';
import 'package:vendoora_mart/features/user/profile/screen/widgets/address_screen.dart';
import 'package:vendoora_mart/features/user/profile/screen/widgets/edit_profile_screen.dart';
import 'package:vendoora_mart/helper/firebase_helper/firebase_helper.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var auth;

  // late UserModel user;
  @override
  void initState() {
    super.initState();
    // await controller.getUserProfile();
    auth = FirebaseAuth.instance;
  }

  @override
  Widget build(BuildContext context) {
    // final ProductCartController productController = Get.find();
    final HomeController homeController = Get.find();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: TSizes.padOfScreen, vertical: TSizes.padOfScreen),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Obx(() => SizedBox(
                        width: 80.w,
                        height: 80.h,
                        child:
                            (homeController.currentUserModel.value?.imageUrl ??
                                        '')
                                    .isNotEmpty
                                ? Image.network(
                                    homeController
                                        .currentUserModel.value!.imageUrl!,
                                    fit: BoxFit.fill,
                                    errorBuilder: (_, __, ___) =>
                                        Image.asset(TImageString.person),
                                  )
                                : Image.asset(TImageString.person),
                      ))),
              // Text(
              //   user.fullName.toString(),
              //   style: TTextStyle.profileHeader,
              // ),

              Text(auth.currentUser?.email.toString() ?? 'No emial',
                  style: TTextStyle.brandTextStyle),

              SizedBox(
                height: 20.h,
              ),
              // CONTAINERS
              ProfileConatainerWidget(
                icon: Icon(
                  Icons.person,
                  size: 24.sp,
                  color: TColors.labelName,
                ),
                title: 'Person',
                onTap: () {
                  return HelperFunctions.navigateToScreen(
                      context: context, screen: EditProfileScreen());
                },
              ),
              ProfileConatainerWidget(
                icon: Icon(
                  Icons.settings,
                  size: 24.sp,
                  color: TColors.labelName,
                ),
                title: 'Setting',
                onTap: () {
                  HelperFunctions.navigateToScreen(
                      context: context, screen: AddressScreen());
                },
              ),
              ProfileConatainerWidget(
                icon: Icon(
                  Icons.email,
                  size: 24.sp,
                  color: TColors.labelName,
                ),
                title: 'Contact',
              ),
              ProfileConatainerWidget(
                icon: Icon(
                  Icons.share_outlined,
                  size: 24.sp,
                  color: TColors.labelName,
                ),
                title: 'Share App',
              ),
              ProfileConatainerWidget(
                icon: Icon(
                  Icons.help_outline_sharp,
                  size: 24.sp,
                  color: TColors.labelName,
                ),
                title: 'Help',
              ),

              // SIGNOUT
              Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 30.h),
                child: TextButton(
                    onPressed: () async {
                      try {
                        // Sign out user
                        await FirebaseAuth.instance.signOut();

                        // Reset GetX controller to avoid keeping previous user state
                        Get.delete<HomeController>(); // dispose controller
                        Get.delete<ProductCartController>();
                        Get.delete<VendorOrderController>();
                        Get.delete<AdminNavController>();

                        // Navigate to login/auth screen
                        HelperFunctions.navigateToScreen(
                            context: context, screen: AuthWrapper());
                      } catch (e) {
                        HelperFunctions.showToast('Network Issue');
                      }
                    },
                    child: Text(
                      'Sign Out',
                      style: TextStyle(color: Colors.red, fontSize: 16.sp),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

//

