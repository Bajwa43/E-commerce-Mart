import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vendoora_mart/features/admin/controller/admin_controller.dart';

class AdminOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminNavController>();
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                "🧾 Orders Management",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20),

              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search orders by ID or customer name...',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Orders List Placeholder
              Expanded(
                child: ListView.builder(
                  itemCount: controller.listOfOrderProducts
                      .length, // You can replace this with your order list length
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 2,
                      margin: EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Icon(Icons.receipt_long, color: Colors.white),
                        ),
                        title: Text("Order ${index + 1}"),
                        subtitle: Text(
                            "Customer: John Doe\nTotal: \$${controller.listOfOrderProducts[index].totalAmount}"),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // Handle navigation to order details
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
