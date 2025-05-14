import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vendoora_mart/features/admin/components/sidebar_tile.dart';
import 'package:vendoora_mart/features/admin/controller/admin_controller.dart';
import 'package:vendoora_mart/utiles/constants/image_string.dart';

class Sidebar extends StatelessWidget {
  final VoidCallback onClose;

  const Sidebar({required this.onClose});

  @override
  Widget build(BuildContext context) {
    final AdminNavController controller = Get.find<AdminNavController>();
    print('USER > ${controller.adminUser.value}');

    return Material(
      elevation: 8,
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // Close button
            ListTile(
              leading: Icon(Icons.close, color: Colors.red),
              title: Text('Close'),
              onTap: onClose,
            ),
            const Divider(),

            /// Admin profile info section
            Obx(() {
              final user = controller.adminUser.value;

              if (user == null) {
                return Column(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: AssetImage(TImageString.person),
                    ),
                    SizedBox(height: 10),
                    Text('Loading...', style: TextStyle(fontSize: 16)),
                    Text('Fetching admin info', style: TextStyle(fontSize: 12)),
                  ],
                );
              }

              return Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: controller.imageUrl.value.isNotEmpty
                        ? NetworkImage(controller.imageUrl.value)
                        : AssetImage(TImageString.person),
                  ),
                  SizedBox(height: 10),
                  Text(
                    user.fullName ?? 'No Name',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  Text(
                    user.email ?? 'No Email',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              );
            }),

            const Divider(height: 30),
            SidebarTile(title: "Dashboard", icon: Icons.dashboard, index: 0),
            SidebarTile(title: "Orders", icon: Icons.list_alt, index: 1),
            SidebarTile(title: "Vendors", icon: Icons.store, index: 2),
            SidebarTile(title: "Products", icon: Icons.inventory, index: 3),
            Spacer(),
            const Divider(),

            // Logout
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                FirebaseAuth.instance.signOut();
                // Add redirection logic if needed
              },
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  /// Helper function to return a valid image provider
  ImageProvider _getImageProvider(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) {
      return AssetImage(TImageString.person);
    }

    final uri = Uri.tryParse(imageUrl);
    if (uri == null ||
        !(uri.isAbsolute && (uri.scheme == 'http' || uri.scheme == 'https'))) {
      return AssetImage(TImageString.person);
    }

    return NetworkImage(imageUrl);
  }
}
