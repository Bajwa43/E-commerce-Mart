import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:vendoora_mart/features/admin/controller/admin_controller.dart';

class SidebarTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final int index;
  final controller = Get.find<AdminNavController>();

  SidebarTile({
    required this.title,
    required this.icon,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = controller.currentIndex.value == index;
      return ListTile(
        leading: Icon(icon, color: isSelected ? Colors.blue : Colors.black54),
        title: Text(
          title,
          style: TextStyle(
              color: isSelected ? Colors.blue : Colors.black87,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
        ),
        onTap: () {
          controller.changePage(index);
        },
      );
    });
  }
}
