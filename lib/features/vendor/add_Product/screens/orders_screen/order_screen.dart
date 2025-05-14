// lib/features/vendor/home/screens/vendor_orders_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:vendoora_mart/features/user/order/screen/order_details_page.dart';
import 'package:vendoora_mart/features/vendor/add_Product/screens/orders_screen/order_detail_screen.dart';
import 'package:vendoora_mart/features/vendor/controller/vender_controller.dart';
import 'package:vendoora_mart/helper/helper_functions.dart';
// import 'package:vendoora_mart/features/vendor/home/controller/vendor_order_controller.dart';

class VendorOrdersPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = Get.put(VendorOrderController());
    return Scaffold(
      appBar: AppBar(
        title: Text('My Vendor Orders', style: TextStyle(fontSize: 18.sp)),
        centerTitle: true,
        elevation: 2,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, size: 24.r),
            onPressed: () => c.onInit(),
          ),
        ],
      ),
      body: Obx(() {
        if (c.orders.isEmpty) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.inbox, size: 80.r, color: Colors.grey[300]),
                SizedBox(height: 16.h),
                Text(
                  'No orders yet',
                  style: TextStyle(fontSize: 16.sp, color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }
        return RefreshIndicator(
          onRefresh: () async => c.onInit(),
          child: ListView.separated(
            padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            itemCount: c.orders.length,
            separatorBuilder: (_, __) => SizedBox(height: 12.h),
            itemBuilder: (_, idx) {
              final order = c.orders[idx];
              final formattedDate =
                  DateFormat.yMMMd().add_jm().format(order.orderDate.toLocal());

              Color statusColor;
              switch (order.orderSatus ? 'Delivered' : 'pending') {
                case 'paid':
                  statusColor = Colors.green;
                  break;
                case 'pending':
                  statusColor = Colors.orange;
                  break;
                case 'cancelled':
                case 'canceled':
                  statusColor = Colors.red;
                  break;
                default:
                  statusColor = Colors.blueGrey;
              }

              return InkWell(
                onTap: () {
                  HelperFunctions.navigateToScreen(
                      context: context,
                      screen: VendorOrderDetailsPage(
                        order: order,
                      ));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6.r,
                        offset: Offset(0, 3.h),
                      )
                    ],
                  ),
                  padding: EdgeInsets.all(16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: ID & Status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              order.orderID,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 4.h,
                              horizontal: 8.w,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withOpacity(0.1),
                              border: Border.all(color: statusColor),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              order.orderSatus ? 'Delivered' : 'Pending',
                              style: TextStyle(
                                color: statusColor,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),

                      // Buyer info
                      Row(
                        children: [
                          Icon(Icons.person,
                              size: 18.r, color: Colors.grey[600]),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: Text(
                              order.buyerName,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                          Icon(Icons.email,
                              size: 18.r, color: Colors.grey[600]),
                          SizedBox(width: 6.w),
                          Flexible(
                            child: Text(
                              order.buyerEmail,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[800],
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.h),

                      // Date
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 16.r, color: Colors.grey[600]),
                          SizedBox(width: 6.w),
                          Text(
                            formattedDate,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      Divider(height: 24.h, thickness: 1.h),

                      // Items Section
                      Text(
                        'Items',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      SizedBox(height: 8.h),

                      // Correctly wrapped Column of item rows

                      Row(
                        children: [
                          Icon(Icons.check_circle_outline,
                              size: 16.r, color: Colors.green),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              'OrderItems',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                          Text(
                            'x${order.items.length}',
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: 12.h),

                      // Total Amount
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Total:',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '\$${order.totalAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ); // end Container
            }, // end itemBuilder
          ), // end ListView.separated
        ); // end RefreshIndicator
      }), // end Obx
    ); // end Scaffold
  }
}
