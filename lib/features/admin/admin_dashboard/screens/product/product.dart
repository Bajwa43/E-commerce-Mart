import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vendoora_mart/features/admin/controller/admin_controller.dart';

class AdminProductsPage extends StatelessWidget {
  final tabs = ['Approved', 'Pending', 'Rejected'];

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AdminNavController>();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                "📦 Products Catalog",
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 20.h),

              // Tab Selector
              Obx(() => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: tabs.map((tab) {
                      final isSelected =
                          controller.selectedProductTab.value == tab;
                      return GestureDetector(
                        onTap: () => controller.selectedProductTab.value = tab,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.h, horizontal: 16.w),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue : Colors.white,
                            borderRadius: BorderRadius.circular(20.r),
                            border: Border.all(
                              color: Colors.blue.withOpacity(0.5),
                            ),
                          ),
                          child: Text(
                            tab,
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.blue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  )),
              SizedBox(height: 20.h),

              // Search Bar
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search products by name or ID...',
                  prefixIcon: Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 0, horizontal: 16.w),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20.h),

              // Product List
              Obx(() {
                final products = controller.filteredProducts;

                return Expanded(
                  child: products.isEmpty
                      ? Center(child: Text("No products in this category."))
                      : ListView.builder(
                          itemCount: products.length,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return Card(
                              elevation: 2,
                              margin: EdgeInsets.only(bottom: 16.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(12.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: Container(
                                        width: 50.w,
                                        height: 50.h,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.r),
                                          color: Colors.grey[300],
                                        ),
                                        child: product.images.isNotEmpty
                                            ? ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.r),
                                                child: Image.network(
                                                  product.images.first,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error,
                                                          stackTrace) =>
                                                      Icon(Icons.error,
                                                          color: Colors.red),
                                                ),
                                              )
                                            : Icon(Icons.image,
                                                color: Colors.grey),
                                      ),
                                      title: Text(
                                          product.productName ?? 'Product'),
                                      subtitle: Text(
                                        "Category: ${product.fashionCategory ?? 'N/A'}\nPrice: \$${product.price}",
                                      ),
                                      trailing: controller
                                                  .selectedProductTab.value ==
                                              'Pending'
                                          ? Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                TextButton(
                                                  onPressed: () => controller
                                                      .approveProduct(product),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.green,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 12.w),
                                                  ),
                                                  child: Text(
                                                    'Approve',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                                SizedBox(width: 8.w),
                                                TextButton(
                                                  onPressed: () => controller
                                                      .rejectProduct(product),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 12.w),
                                                  ),
                                                  child: Text(
                                                    'Reject',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                ),
                                              ],
                                            )
                                          : controller.selectedProductTab
                                                      .value ==
                                                  'Rejected'
                                              ? TextButton(
                                                  onPressed: () => controller
                                                      .rejectedProductDelete(
                                                          product),
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor: Colors.red,
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 12.w),
                                                  ),
                                                  child: Text(
                                                    'Delete',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                )
                                              : Icon(Icons.edit, size: 18.sp),
                                      onTap: () {
                                        // TODO: Navigate to product detail/edit screen
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
