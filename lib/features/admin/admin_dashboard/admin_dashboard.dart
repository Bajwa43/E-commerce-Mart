import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vendoora_mart/features/admin/controller/admin_controller.dart';
import 'package:vendoora_mart/features/admin/sidebar/sidebar_profile.dart';
import 'package:vendoora_mart/services/auth_service.dart';
import 'package:vendoora_mart/utiles/constants/text_string.dart';

class AnimatedAdminDashboard extends StatefulWidget {
  @override
  State<AnimatedAdminDashboard> createState() => _AnimatedAdminDashboardState();
}

class _AnimatedAdminDashboardState extends State<AnimatedAdminDashboard>
    with SingleTickerProviderStateMixin {
  late AdminNavController controller;
  // bool isSidebarOpen = false;
  final Duration duration = Duration(milliseconds: 300);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller = Get.find<AdminNavController>();
  }

  @override
  Widget build(BuildContext context) {
    double sidebarWidth = MediaQuery.of(context).size.width * 0.7;
    // print('VENDOR > ${controller.listOfVendors[1]}');

    // final AdminNavController controller = Get.find<AdminNavController>();

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Stack(
        children: [
          // Sidebar
          Obx(
            () => AnimatedPositioned(
              duration: duration,
              curve: Curves.easeInOut,
              left: controller.isSidebarOpen.value ? 0 : -sidebarWidth,
              top: 0,
              bottom: 0,
              child: SizedBox(
                width: sidebarWidth,
                child: Sidebar(
                  onClose: () => controller.isSidebarOpen.value = false,
                ),
              ),
            ),
          ),

          // Main content
          Obx(
            () => AnimatedPositioned(
              duration: duration,
              curve: Curves.easeInOut,
              left: controller.isSidebarOpen.value ? sidebarWidth * 0.8 : 0,
              top: 0,
              bottom: 0,
              right: controller.isSidebarOpen.value ? -sidebarWidth * 0.2 : 0,
              child: AbsorbPointer(
                absorbing: controller.isSidebarOpen.value,
                child: Obx(() => Scaffold(
                      appBar: AppBar(
                        backgroundColor: Colors.blue.shade800,
                        title: Text(controller
                            .appBarTitles[controller.currentIndex.value]),
                        leading: IconButton(
                          icon: Icon(Icons.menu),
                          onPressed: () =>
                              controller.isSidebarOpen.value = true,
                        ),
                      ),
                      body: controller.pages[controller.currentIndex.value],
                      bottomNavigationBar: BottomNavigationBar(
                        currentIndex: controller.currentIndex.value,
                        onTap: controller.changePage,
                        selectedItemColor: Colors.blue.shade800,
                        unselectedItemColor: Colors.grey,
                        type: BottomNavigationBarType.fixed,
                        items: const [
                          BottomNavigationBarItem(
                              icon: Icon(Icons.dashboard), label: 'Dashboard'),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.list_alt), label: 'Orders'),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.store), label: 'Vendors'),
                          BottomNavigationBarItem(
                              icon: Icon(Icons.inventory), label: 'Products'),
                        ],
                      ),
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }
}
