import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class OrderCardWidget extends StatelessWidget {
  final String orderID;
  final double totalAmount;
  final DateTime orderDate;
  final String status;
  final VoidCallback? onTap; // optional for interactivity

  const OrderCardWidget({
    Key? key,
    required this.orderID,
    required this.totalAmount,
    required this.orderDate,
    required this.status,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isCompleted = status.toLowerCase() == "completed";
    final statusColor = isCompleted ? Colors.green : Colors.orange;
    final statusIcon =
        isCompleted ? Icons.check_circle : Icons.hourglass_bottom;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
        padding: EdgeInsets.all(18.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10.r,
              offset: Offset(0, 4),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Order ID and Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  orderID.length > 15
                      ? orderID.substring(0, 15) + '...'
                      : "#$orderID",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    children: [
                      Icon(statusIcon, size: 16.sp, color: statusColor),
                      SizedBox(width: 4.w),
                      Text(
                        status,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: statusColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 10.h),

            /// Date
            Row(
              children: [
                Icon(Icons.calendar_today, size: 16.sp, color: Colors.grey),
                SizedBox(width: 6.w),
                Text(
                  DateFormat('dd MMM yyyy - hh:mm a').format(orderDate),
                  style: TextStyle(fontSize: 13.sp, color: Colors.grey[700]),
                ),
              ],
            ),

            SizedBox(height: 8.h),

            /// Amount
            Row(
              children: [
                Icon(Icons.attach_money, size: 18.sp, color: Colors.grey[700]),
                SizedBox(width: 6.w),
                Text(
                  "Total: Rs. ${totalAmount.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
