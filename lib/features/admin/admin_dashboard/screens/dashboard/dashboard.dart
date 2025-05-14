import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vendoora_mart/features/admin/controller/admin_controller.dart';

class AdminDashboardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminNavController>();
    print('>>ORDER>> ${controller.listOfOrderProducts.length}');
    print('>>PRODUCTS>> ${controller.listOfProducts.length}');

    return Obx(() {
      final user = controller.adminUser.value;

      return Scaffold(
        backgroundColor: Colors.grey[100],
        body: SingleChildScrollView(
          child: SafeArea(
            child: user == null
                ? Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Section
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 35,
                              backgroundImage: user.imageUrl != null &&
                                      user.imageUrl!.isNotEmpty
                                  ? (user.imageUrl!.startsWith('http')
                                      ? NetworkImage(user.imageUrl!)
                                      : FileImage(File(user.imageUrl!))
                                          as ImageProvider)
                                  : AssetImage(
                                      'assets/images/default_avatar.png'),
                            ),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.fullName ?? "Admin",
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  user.email ?? '',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),

                                // Show Approve/Reject buttons if user is not approved
                              ],
                            ),
                          ],
                        ),

                        SizedBox(height: 30),

                        // Title
                        Text(
                          "📊 Dashboard Summary",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),

                        // Dashboard Cards
                        Row(
                          children: [
                            _buildDashboardCard(
                              title: "Orders",
                              value: controller.listOfOrderProducts.length
                                  .toString(),
                              icon: Icons.shopping_cart_outlined,
                              color: Colors.blue,
                            ),
                            SizedBox(width: 16),
                            _buildDashboardCard(
                              title: "Vendors",
                              value: controller.listOfVendors.length.toString(),
                              icon: Icons.store_mall_directory_outlined,
                              color: Colors.green,
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            _buildDashboardCard(
                              title: "Products",
                              value:
                                  controller.listOfProducts.length.toString(),
                              icon: Icons.inventory_2_outlined,
                              color: Colors.orange,
                            ),
                            SizedBox(width: 16),
                            _buildDashboardCard(
                              title: "Revenue",
                              value: "\$${controller.adminTotalEarning}",
                              icon: Icons.attach_money,
                              color: Colors.purple,
                            ),
                          ],
                        ),

                        SizedBox(height: 30),

                        // Welcome Text
                        Text(
                          "Welcome back, ${user.fullName?.split(' ').first ?? 'Admin'} 👋",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Manage everything from your admin panel — from vendors to product inventory and order processing.",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      );
    });
  }

  Widget _buildDashboardCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(fontSize: 16, color: color),
            ),
          ],
        ),
      ),
    );
  }
}
