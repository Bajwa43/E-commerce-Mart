import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vendoora_mart/features/auth/auth_wraper.dart';
import 'package:vendoora_mart/features/user/home/controller/home_controller.dart';
import 'package:vendoora_mart/features/user/home/controller/product_cart_controller.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:vendoora_mart/features/vendor/add_Product/vender_add_item_screen.dart';
import 'package:vendoora_mart/features/vendor/controller/vender_controller.dart';
import 'package:vendoora_mart/features/vendor/widgets/icon_text_btn.dart';
import 'package:vendoora_mart/helper/firebase_helper/firebase_helper.dart';
import 'package:vendoora_mart/helper/helper_functions.dart';
import 'package:vendoora_mart/services/auth_service.dart';

class VendorHomeScreen extends StatefulWidget {
  const VendorHomeScreen({super.key});

  @override
  State<VendorHomeScreen> createState() => _VendorHomeScreenState();
}

class _VendorHomeScreenState extends State<VendorHomeScreen> {
  late VendorOrderController controller;
  @override
  void initState() {
    super.initState();
    controller = Get.put(VendorOrderController()); // Register Controller
  }

  @override
  Widget build(BuildContext context) {
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendor Dashboard'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: HelperFirebase.userInstance.doc(uid).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error fetching user data'));
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('User data not found'));
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>;
          final isApproved = userData['approved'] == true;

          if (!isApproved) {
            return Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(16)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.pending_actions,
                                  size: 50, color: Colors.orange),
                              SizedBox(height: 16),
                              Text(
                                'Approval Pending',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Your vendor account is currently under review by the admin. Please wait until approval.',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Spacer(),
                      ElevatedButton.icon(
                        onPressed: () => AuthService.logOut(context),
                        icon: const Icon(Icons.logout),
                        label: const Text(' Logout '),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          textStyle: const TextStyle(fontSize: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ]),
              ),
            );
          }

          // Approved UI
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildVendorCategoryBtn(
                  icon: Icons.checkroom,
                  label: 'Fashion',
                  onTap: () {
                    // controller.typeOfProduct.value = 'fashion';
                    HelperFunctions.navigateToScreen(
                      context: context,
                      screen: VendorDashboardScreen(),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildVendorCategoryBtn(
                  icon: Icons.directions_car,
                  label: 'Electronics',
                  onTap: () {
                    // controller.typeOfProduct.value = 'electronics';
                    HelperFunctions.navigateToScreen(
                      context: context,
                      screen: VendorDashboardScreen(),
                    );
                  },
                ),
                const SizedBox(height: 16),
                _buildVendorCategoryBtn(
                  icon: Icons.house,
                  label: 'Real Estate',
                  onTap: () {},
                ),
                const Spacer(),
                ElevatedButton.icon(
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
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildVendorCategoryBtn({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 24),
      label: Text(label, style: const TextStyle(fontSize: 18)),
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple.shade400,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
      ),
    );
  }
}
