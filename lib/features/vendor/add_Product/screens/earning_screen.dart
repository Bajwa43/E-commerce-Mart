import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:vendoora_mart/features/auth/auth_wraper.dart';
import 'package:vendoora_mart/features/user/home/controller/home_controller.dart';
import 'package:vendoora_mart/features/user/home/controller/product_cart_controller.dart';
import 'package:vendoora_mart/features/vendor/controller/vender_controller.dart';
import 'package:vendoora_mart/features/vendor/widgets/earning_container_widget.dart';
import 'package:vendoora_mart/helper/helper_functions.dart';
import 'package:vendoora_mart/services/auth_service.dart';

class EarningScreen extends StatefulWidget {
  final DocumentSnapshot userData;
  const EarningScreen(
      {super.key,
      required this.userData,
      required this.totalOrders,
      required this.totalEarning});
  final int totalOrders;
  final double totalEarning;

  @override
  State<EarningScreen> createState() => _EarningScreenState();
}

class _EarningScreenState extends State<EarningScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.topCenter, children: [
      Container(
        color: Colors.purple,
        height: 80,
        width: MediaQuery.of(context).size.width,
        child: Center(
            child: Text('Eaxrning: Shopping',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold))),
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Hi,${widget.userData['business']} Shop',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          EarningContainerWidget(
              label: 'TOTAL EARNING',
              value: 'Rs.${widget.totalEarning.toString()}'),
          EarningContainerWidget(
              label: 'TOTAL ORDERS', value: widget.totalOrders.toString()),
          ElevatedButton(
              onPressed: () async {
                try {
                  // Sign out user
                  await FirebaseAuth.instance.signOut();

                  // Reset GetX controller to avoid keeping previous user state
                  Get.delete<VendorOrderController>(); // dispose controller
                  // Get.delete<ProductCartController>();
                  Get.delete<HomeController>(); // dispose controller
                  Get.delete<ProductCartController>();

                  // Navigate to login/auth screen
                  HelperFunctions.navigateToScreen(
                      context: context, screen: AuthWrapper());
                } catch (e) {
                  HelperFunctions.showToast('Network Issue');
                }
              },
              child: const Text('Logout'))
        ],
      ),
    ]);
  }
}
