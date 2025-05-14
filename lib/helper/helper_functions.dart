import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HelperFunctions {
  static void popBack({required BuildContext context}) {
    Navigator.pop(context);
  }

  static void popWithRemoveAllStates(BuildContext context, Widget screen) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => screen),
      (route) => false, // This removes all previous routes from the stack
    );
  }

  static void navigateToScreen(
      {required BuildContext context, required Widget screen}) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => screen));
  }

  static showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        // gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  static showBottomSheet(BuildContext context) {
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
  }
}
