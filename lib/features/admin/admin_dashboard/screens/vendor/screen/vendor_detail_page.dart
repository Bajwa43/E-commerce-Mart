import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vendoora_mart/features/admin/admin_dashboard/screens/dashboard/dashboard.dart';
import 'package:vendoora_mart/features/admin/controller/admin_controller.dart';
import 'package:vendoora_mart/features/auth/domain/models/user_model.dart';
import 'package:vendoora_mart/utiles/constants/image_string.dart';

class VendorDetailPage extends StatelessWidget {
  final UserModel vendor;

  const VendorDetailPage({super.key, required this.vendor});

  @override
  Widget build(BuildContext context) {
    AdminNavController controller = Get.find<AdminNavController>();
    // controller.bindOrdersStream(vendorId);
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          vendor.fullName ?? "Vendor Details",
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade900, Colors.black],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.only(top: 100, bottom: 24, left: 16, right: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🏬 Shop Image with Logo overlay
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: vendor.shopImageUrl != null
                        ? Image.network(
                            vendor.shopImageUrl!,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          )
                        : Image.asset(
                            TImageString.greyShoeImage,
                            height: 180,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                  ),
                  if (vendor.logoUrl != null)
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(vendor.logoUrl!),
                    )
                  else
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.white,
                      backgroundImage: AssetImage(TImageString.person),
                    ),
                ],
              ),
              const SizedBox(height: 30),

              // 📊 Vendor Stats (Total Orders, Products, Earnings)
              Row(
                children: [
                  _buildDashboardCard(
                    title: "Orders",
                    value: "85", // Replace with actual count
                    icon: Icons.shopping_cart_outlined,
                    color: Colors.blueAccent,
                  ),
                  const SizedBox(width: 12),
                  _buildDashboardCard(
                    title: "Products",
                    value: "26", // Replace with actual count
                    icon: Icons.inventory_2_outlined,
                    color: Colors.orangeAccent,
                  ),
                  const SizedBox(width: 12),
                  _buildDashboardCard(
                    title: "Earnings",
                    value: "\$4.2K", // Replace with actual total
                    icon: Icons.attach_money,
                    color: Colors.greenAccent,
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // 📋 Vendor Info
              _glassCard(
                context,
                children: [
                  _detailRow("Full Name", vendor.fullName),
                  _detailRow("Email", vendor.email),
                  _detailRow("Phone", vendor.phone),
                  _detailRow("Business Name", vendor.business),
                  _detailRow("GST Number", vendor.gstNumber),
                  _detailRow("Registered As", vendor.textRegistered),
                  _detailRow("City", vendor.city),
                  _detailRow("Address", vendor.address),
                  _detailRow("User Type", vendor.userType),
                  _detailRow(
                      "Approved", vendor.approved == true ? "Yes ✅" : "No ❌"),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _glassCard(BuildContext context, {required List<Widget> children}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _detailRow(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Text(
            "$title: ",
            style: TextStyle(
                fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Text(
              value ?? "Not Provided",
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 16, color: Colors.white70),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 12),
            Text(
              value,
              style: TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: color),
            ),
            const SizedBox(height: 6),
            Text(title, style: TextStyle(fontSize: 14, color: color)),
          ],
        ),
      ),
    );
  }
}
