// lib/features/vendor/home/screens/order_details_page.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:vendoora_mart/features/user/home/domain/model/order/order_item_model.dart';
import 'package:vendoora_mart/features/vendor/controller/vender_controller.dart';
import 'package:vendoora_mart/helper/firebase_helper/firebase_helper.dart';
import 'package:vendoora_mart/utiles/constants/colors.dart';
import 'package:vendoora_mart/utiles/constants/image_string.dart';

class VendorOrderDetailsPage extends StatelessWidget {
  final VendorOrderPreview order;

  const VendorOrderDetailsPage({Key? key, required this.order})
      : super(key: key);

  Color _statusColor(String s) {
    switch (s.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
      case 'canceled':
        return Colors.red;
      case 'delivered':
        return Colors.blue;
      default:
        return Colors.blueGrey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat.yMMMd().add_jm().format(order.orderDate.toLocal());

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details', style: TextStyle(fontSize: 18.sp)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner
            Container(
              width: double.infinity,
              height: 180.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12.r),
                image: DecorationImage(
                  image: AssetImage(TImageString.banner),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 16.h),

            // ID & Streamed Status Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    'Order ID: ${order.orderID}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Stream the shared order doc to get real-time status
                StreamBuilder<DocumentSnapshot>(
                  stream: HelperFirebase
                      .orderConformInstance // your shared orders collection
                      .doc(order.orderID)
                      .snapshots(),
                  builder: (context, snap) {
                    String statusText = order.orderStatus;
                    Color statusColor = _statusColor(statusText);

                    if (snap.hasData && snap.data!.exists) {
                      final data = snap.data!.data() as Map<String, dynamic>;
                      final confirmed = data['orderSatus'] as bool? ?? false;
                      if (confirmed) {
                        statusText = 'Delivered';
                        statusColor = _statusColor(statusText);
                      }
                    }

                    return Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
                      decoration: BoxDecoration(
                        color: statusColor.withOpacity(0.1),
                        border: Border.all(color: statusColor),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        statusText.toUpperCase(),
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 8.h),

            // Date
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16.r, color: Colors.grey[600]),
                SizedBox(width: 6.w),
                Text(
                  formattedDate,
                  style: TextStyle(fontSize: 13.sp, color: Colors.grey[700]),
                ),
              ],
            ),
            Divider(height: 24.h, thickness: 1.h),

            // Buyer Info
            Text(
              'Buyer Information',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Icon(Icons.person, size: 18.r, color: Colors.grey[600]),
                SizedBox(width: 8.w),
                Expanded(
                  child:
                      Text(order.buyerName, style: TextStyle(fontSize: 14.sp)),
                ),
              ],
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Icon(Icons.email, size: 18.r, color: Colors.grey[600]),
                SizedBox(width: 8.w),
                Expanded(
                  child:
                      Text(order.buyerEmail, style: TextStyle(fontSize: 14.sp)),
                ),
              ],
            ),
            Divider(height: 24.h, thickness: 1.h),

            // Items
            Text(
              'Items',
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8.h),
            ...order.items.map((OrderItemModel item) {
              final imageUrl = item.imageUrl;
              return Container(
                margin: EdgeInsets.only(bottom: 8.h),
                padding: EdgeInsets.all(8.h),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50.w,
                      height: 50.w,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Icon(
                            Icons.image_not_supported,
                            size: 40,
                            color: Colors.grey),
                        loadingBuilder: (c, ch, loading) => loading == null
                            ? ch!
                            : Center(child: CircularProgressIndicator()),
                      ),
                    ),
                    SizedBox(width: 7.w),
                    Expanded(
                      child: Text(item.productName,
                          style: TextStyle(
                              fontSize: 14.sp, color: TColors.textPrimary)),
                    ),
                    // SizedBox(width: 2.w),
                    Text(
                      '${item.size}',
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: TColors.textPrimary),
                    ),
                    SizedBox(width: 50.w),
                    Text(
                      'x${item.quantity}',
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: TColors.textPrimary),
                    ),
                  ],
                ),
              );
            }).toList(),

            SizedBox(height: 12.h),

            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Total Amount',
                    style: TextStyle(
                        fontSize: 16.sp, fontWeight: FontWeight.bold)),
                Text('\$${order.totalAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[700])),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
