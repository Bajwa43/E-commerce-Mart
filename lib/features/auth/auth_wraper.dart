import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vendoora_mart/features/admin/admin_dashboard/admin_dashboard.dart';
import 'package:vendoora_mart/features/admin/controller/admin_controller.dart';
import 'package:vendoora_mart/features/auth/screens/dayn_night_animate.dart';
import 'package:vendoora_mart/features/auth/screens/loginScreen.dart';
import 'package:vendoora_mart/features/user/home/controller/home_controller.dart';
import 'package:vendoora_mart/features/user/home/screens/home_screen.dart';
import 'package:vendoora_mart/features/vendor/home/screens/vendor_home_Screen.dart';
import 'package:vendoora_mart/helper/enum.dart';
import 'package:vendoora_mart/helper/firebase_helper/firebase_helper.dart';
import 'package:vendoora_mart/main.dart';
import 'package:vendoora_mart/utiles/constants/colors.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  Future<QuerySnapshot> checkUser(String email) async {
    QuerySnapshot snapshot = await HelperFirebase.userInstance
        .where('email', isEqualTo: email)
        .where('userType', isEqualTo: UserType.vendor.value)
        .get();

    return snapshot;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.none ||
            snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: TColors.accent,
            body: const Center(
              child: CircularProgressIndicator.adaptive(
                backgroundColor: Colors.blueAccent,
              ),
            ),
          );
        }
        var user = snapshot.data;

        if (user != null) {
          return FutureBuilder(
            future: checkUser(user.email.toString()),
            builder: (context, snapShot) {
              if (snapShot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  backgroundColor: TColors.accent,
                  body: const Center(
                    child: CircularProgressIndicator.adaptive(
                      backgroundColor: Colors.blueAccent,
                    ),
                  ),
                );
              }

              if (snapShot.hasError) {
                return Scaffold(
                  body: Center(child: Text("Error: ${snapShot.error}")),
                );
              }

              if (snapShot.hasData &&
                  snapShot.data!.docs.isNotEmpty &&
                  snapShot.data!.docs[0]['userType'] != 'admin') {
                return const VendorHomeScreen();
              } else if (user.email == 'admin@gmail.com') {
                Get.put(AdminNavController());
                return AnimatedAdminDashboard();
              } else {
                Get.put(
                  HomeController(),
                );
                return const UserHomeScreen();
              }
            },
          );
        } else {
          return const DayAndNightLoginAnimation();
        }
      },
    );
  }
}
