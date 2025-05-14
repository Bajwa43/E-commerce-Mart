import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vendoora_mart/app.dart';
import 'package:vendoora_mart/features/admin/controller/admin_controller.dart';
import 'package:vendoora_mart/firebase_options.dart';
import 'package:vendoora_mart/helper/firebase_helper/firebase_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Get.put(AdminNavController(), permanent: true);
  runApp(MyApp());
}
// void main() {
//   runApp(GetMaterialApp(
//     debugShowCheckedModeBanner: false,
//     home: AnimatedAdminDashboard(),
//   ));
// }




