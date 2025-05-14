import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vendoora_mart/features/auth/domain/models/user_model.dart';
import 'package:vendoora_mart/features/user/home/screens/home_screen.dart';
import 'package:vendoora_mart/features/vendor/home/screens/vendor_home_Screen.dart';
import 'package:vendoora_mart/helper/enum.dart';
import 'package:vendoora_mart/helper/firebase_helper/firebase_helper.dart';
import 'package:vendoora_mart/helper/helper_functions.dart';

class AuthService {
  static logOut(BuildContext context) async {
    await FirebaseAuth.instance
        .signOut()
        .then((value) => HelperFunctions.popBack(context: context));
  }

  // static late AuthStatus _status;
  //login with pass and email function

  // // FORGET PASSWORD
  // static Future forgetPasswordWithEmail(
  //     String email, BuildContext context) async {
  //   // FirebaseAuth.instance.confirmPasswordReset(code: code, newPassword: newPassword)
  //   await FirebaseAuth.instance.sendPasswordResetEmail(email: email).then(
  //     (value) {
  //       showDialog(
  //           context: context,
  //           builder: (context) => Dialog(
  //                 child: InformDialogWidget(
  //                   heightOfDialog: 200.h,
  //                   trigarBtnName: 'Ok',
  //                   dialogTitle: 'Email Conformation!',
  //                   onPressed: () {
  //                     Get.back();
  //                     Get.back();
  //                   },
  //                   child: TextWidget(
  //                     padHori: 0,
  //                     padVerti: 0,
  //                     text: 'Message send your Email box! If it is Exist.',
  //                     textStyle: KAppTypoGraphy.dialogeText18Medium,
  //                     textAlign: TextAlign.center,
  //                   ),
  //                   //
  //                 ),
  //               ));
  //     },
  //   );
  //   //  .then(
  //   // (value) {
  //   //   _status == AuthStatus.successful;
  //   //   // Get.to();
  //   // },
  //   // );
  // }

  // LOGIN
  static Future<void> loginUserWithEmailAndPassword(
      BuildContext context,
      TextEditingController emailController,
      TextEditingController passwordController) async {
    // try {
    // print('Enter in TRY BLOck ');
    // Show loading dialog
    // showDialog(
    //   context: context,
    //   barrierDismissible: false,
    //   builder: (context) => const Center(
    //     child: CircularProgressIndicator.adaptive(
    //       valueColor: AlwaysStoppedAnimation(Colors.amberAccent),
    //     ),
    //   ),
    // );

    // Authenticate user
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text.trim(),
              password: passwordController.text.trim());

      // Successfully logged in
      // HelperFunctions.showToast('Login Successful');
      Fluttertoast.showToast(
          msg: 'Login Succes Full',
          toastLength: Toast.LENGTH_SHORT,
          // gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);

      QuerySnapshot snapshot = await HelperFirebase.userInstance
          .where('email', isEqualTo: emailController.text)
          .where('userType', isEqualTo: UserType.vendor.value)
          .get();

      print('After CHECK INSTANCE ');

      // Close loading dialog

      print('After CHECK INSTANCE AND POP CIRCULAR');

      // Navigate based on user type
      if (snapshot.docs.isNotEmpty) {
        print('ENTER IN WITH VENDER INSTANCE ');

        // Vendor user
        HelperFunctions.navigateToScreen(
            context: context, screen: VendorHomeScreen());
      } else {
        print('✅ Navigating to UserHomeScreen');
        print('Snapshot empty, treating as customer.');

        await Future.delayed(
            Duration(milliseconds: 500)); // Small delay for UI updates

        await Navigator.of(context, rootNavigator: true).push(
          MaterialPageRoute(builder: (context) => UserHomeScreen()),
        );

        print('✅ Navigation should have occurred.');

        // Regular user

        // Navigator.pop(context);

        // HelperFunctions.navigateToScreen(
        //     context: context, screen: UserHomeScreen());

        // await Get.off(() => UserHomeScreen());
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        HelperFunctions.showToast('No user found with this email.');
      } else if (e.code == 'wrong-password') {
        HelperFunctions.showToast('Incorrect password. Try again.');
      } else if (e.code == 'user-disabled') {
        HelperFunctions.showToast('This account has been disabled.');
      } else if (e.code == 'invalid-email') {
        HelperFunctions.showToast('Invalid email format.');
      } else if (e.code == 'too-many-requests') {
        HelperFunctions.showToast('Too many attempts. Try again later.');
      } else if (e.code == 'network-request-failed') {
        HelperFunctions.showToast(
            'No internet connection. Please check your network.');
      } else {
        HelperFunctions.showToast('Login failed: ${e.message}');
      }
    } catch (e) {
      HelperFunctions.showToast(
          'An unexpected error occurred. Please try again.');
    }

    // Fetch user data from Firestore for is this vender or user

    // Navigator.pop(context);

    // Show success toast
    // HelperFunctions.showToast(
    //     '${userCredential.user!.email} logged in successfully');
    // } on FirebaseAuthException catch (e) {
    //   print('ENTER IN FIRST CATCH');

    //   // Close loading dialog
    //   // Navigator.pop(context);

    //   // Handle authentication error
    //   AuthStatus status = AuthExceptionHandler.handleAuthException(e);
    //   String error = AuthExceptionHandler.generateErrorMessage(status);
    //   HelperFunctions.showToast(error);
    // } catch (e) {
    //   // Close loading dialog for any unexpected errors
    //   // Navigator.pop(context);
    //   print('ENTER IN SECOND CATCH');

    //   HelperFunctions.showToast(
    //       'An unexpected error occurred. Please try again.');
    //   debugPrint('Error: $e');
    // }

    // Navigator.pop(context);
  }

  // static loginUserWithEmailAndPassword(
  //     BuildContext context, var emailController, var passwordController) async {
  //   try {
  //     showModalBottomSheet(
  //         context: context,
  //         isDismissible: false,
  //         scrollControlDisabledMaxHeightRatio: 10,
  //         sheetAnimationStyle: AnimationStyle(
  //           duration: const Duration(milliseconds: 600),
  //         ),
  //         constraints: BoxConstraints(
  //             maxHeight: MediaQuery.sizeOf(context).height,
  //             maxWidth: MediaQuery.sizeOf(context).width),
  //         builder: (context) => Scaffold(
  //               body: Center(
  //                 child: SizedBox(
  //                   height: MediaQuery.sizeOf(context).height * 1,
  //                   child: const Column(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       CircularProgressIndicator.adaptive(
  //                         valueColor:
  //                             AlwaysStoppedAnimation(Colors.amberAccent),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ));

  //     var user = await FirebaseAuth.instance
  //         .signInWithEmailAndPassword(
  //             email: emailController.text, password: passwordController.text)
  //         .then(
  //       (value) {
  //         HelperFirebase.userInstance
  //             .where('userType', isEqualTo: UserType.vendor.value)
  //             .where('email',
  //                 isEqualTo: emailController.text) // Check for city = New York
  //             .get()
  //             .then((QuerySnapshot snapshot) {
  //           // Handle the vendors data
  //           HelperFunctions.navigateToScreen(
  //               context: context, screen: VendorHomeScreen());
  //         });

  //         HelperFunctions.navigateToScreen(
  //             context: context, screen: DashboardScreen());
  //       },
  //     );

  //     // Get.back();
  //     HelperFunctions.popBack(context: context);
  //     // Get.back();
  //     // Get.to(const HomeScreen());
  //     HelperFunctions.showToast('${user.user!.email} >> is Login sucessFuly');
  //     HelperFunctions.navigateToScreen(
  //         context: context, screen: DashboardScreen());
  //   } on FirebaseAuthException catch (e) {
  //     // Get.back();
  //     HelperFunctions.popBack(context: context);
  //     AuthStatus status = AuthExceptionHandler.handleAuthException(e);
  //     String error = AuthExceptionHandler.generateErrorMessage(status);
  //     HelperFunctions.showToast(error);
  //   }
  // }

// GET IMAGEURL
  static Future<String> getImageUrl(String filePath) async {
    try {
      Reference storageRef = FirebaseStorage.instance.ref().child(filePath);
      String downloadUrl = await storageRef.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw Exception("Error retrieving image: ${e.toString()}");
    }
  }

// UPLOADING IMAGE
  static Future<String> uploadImageToStorage(
      File? imageFile, String? userCredential, String header) async {
    try {
      String fileName = '$header/$userCredential.jpg';
      Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
      UploadTask uploadTask = storageRef.putFile(imageFile!);

      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      throw Exception("Image upload failed: ${e.toString()}");
    }
  }

//  REGISTER
  static Future<String?> registerUserWithFirebaseAuth(
      BuildContext context,
      TextEditingController emailController,
      TextEditingController fullNameController,
      TextEditingController phoneController,
      TextEditingController passwordController,
      UserCredential userCredential,
      UserModel user) async {
    try {
      showModalBottomSheet(
          context: context,
          constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height,
              maxWidth: MediaQuery.sizeOf(context).width),
          builder: (context) => const Scaffold(
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator.adaptive(
                        valueColor: AlwaysStoppedAnimation(Colors.amberAccent),
                      ),
                    ],
                  ),
                ),
              ));
      // Get.back();
      print("Full Name Before: ${fullNameController.text}");

      // UserModel userModel = UserModel(
      //     userId: userCredential.user!.uid,
      //     email: userCredential.user!.email.toString(),
      //     fullName: fullNameController.text.trim(),
      //     phone: phoneController.text.trim());

      user.userId = userCredential.user!.uid;

      // print("Full Name After: ${fullNameController.text}");
      await HelperFirebase.userInstance
          .doc(userCredential.user!.uid)
          .set(user.toMap());

      // // .collection('Tasks');
      // // .doc();
      // // .set();
      // Get.back();
      HelperFunctions.popBack(context: context);

      // Get.back();
      // HelperFunctions.popBack(context: context);

      HelperFunctions.showToast(
          '${userCredential.user!.email} >> is Registerd');
      // print("Full Name Last: ${fullNameController.text}");

      return userCredential.user!.uid;
    } catch (e) {
      fullNameController.clear();
      emailController.clear();
      phoneController.clear();
      passwordController.clear();
      // Get.back();
      HelperFunctions.popBack(context: context);
      HelperFunctions.showToast(e.toString());
      print('>>>>>>>>>>>>>>>>>>> ${e.toString()}');
      HelperFunctions.showToast('Issue');
    }
  }
}
