import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:vendoora_mart/features/vendor/add_Product/screens/earning_screen.dart';
import 'package:vendoora_mart/features/vendor/add_Product/screens/edit_product/edit_products.dart';
import 'package:vendoora_mart/features/vendor/add_Product/screens/orders_screen/order_screen.dart';
import 'package:vendoora_mart/features/vendor/add_Product/screens/upload_product/upload_product_screen.dart';
import 'package:vendoora_mart/features/vendor/controller/vender_controller.dart';
import 'package:vendoora_mart/helper/firebase_helper/firebase_helper.dart';

class VendorDashboardScreen extends StatefulWidget {
  const VendorDashboardScreen({super.key});

  @override
  State<VendorDashboardScreen> createState() => _VendorDashboardScreenState();
}

class _VendorDashboardScreenState extends State<VendorDashboardScreen> {
  int _currentIndex = 0;
  DocumentSnapshot? userAllData;
  bool isLoading = true; // To track loading state
  bool hasError = false; // To track error state

  @override
  void initState() {
    super.initState();
    fetchUserData(); // Fetch Firestore data
  }

  Future<void> fetchUserData() async {
    try {
      // Fetch Firestore data for the current user
      DocumentSnapshot userData = await HelperFirebase.userInstance
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      // Update state with the fetched data
      setState(() {
        userAllData = userData;
        isLoading = false; // Stop loading
      });
    } catch (e) {
      setState(() {
        hasError = true; // Mark as error
        isLoading = false; // Stop loading
      });
      debugPrint("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final VendorOrderController vController = Get.find<VendorOrderController>();
    int totalOrders = 0;
    double totalEarning = 0;
    for (var i = 0; i < vController.orders.length; i++) {
      if (vController.orders[i].orderSatus == true) {
        totalEarning += vController.orders[i].totalAmount;
        totalOrders++;
      }
    }
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      );
    }

    if (hasError) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Failed to load user data.',
                  style: TextStyle(fontSize: 18)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: fetchUserData,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final List<Widget> _screens = [
      EarningScreen(
          totalEarning: totalEarning,
          totalOrders: totalOrders,
          userData: userAllData!), // Pass fetched data to EarningScreen
      const UploadProductScreen(),
      EditProductScreen(),
      Center(child: VendorOrdersPage()),
      const Center(
          child: Text('Logout Screen', style: TextStyle(fontSize: 24))),
    ];

    return Scaffold(
      body: Center(
        child:
            _screens[_currentIndex], // Show screen based on the selected index
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Update the current index
          });
        },
        selectedItemColor: Colors.amber, // Highlighted color for active tab
        unselectedItemColor: Colors.grey, // Color for inactive tabs
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.currency_exchange),
            label: 'Earnings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.edit_outlined),
            label: 'Edit',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_travel),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
      ),
    );
  }
}
