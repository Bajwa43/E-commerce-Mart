import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:vendoora_mart/features/user/home/controller/home_controller.dart';
import 'package:vendoora_mart/features/user/home/domain/model/order/order_conform_model.dart';
import 'package:vendoora_mart/features/user/home/screens/home_screen.dart';
import 'package:vendoora_mart/helper/firebase_helper/firebase_helper.dart';
import 'package:vendoora_mart/helper/helper_functions.dart';

class ReceiptScreen extends StatelessWidget {
  final OrderConformModel orderConformModel;
  final String senderName;

  const ReceiptScreen(
      {Key? key, required this.orderConformModel, required this.senderName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd MMM yyyy, hh:mm a')
        .format(orderConformModel.orderDate.toDate());
    return Scaffold(
      backgroundColor: Color(0xFFF7F9FB),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 150.h,
                      width: 150.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.green.withOpacity(0.1),
                      ),
                    ),
                    Icon(
                      Icons.check_circle_rounded,
                      size: 100.sp,
                      color: Colors.green[600],
                    ),
                  ],
                ),
                SizedBox(height: 14.h),
                Text(
                  "Your Order is Confirmed",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  "Thank you for your purchase. Your order is being processed.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.black54,
                  ),
                ),
                SizedBox(height: 5.h),
                Container(
                  width: 350.w,
                  padding: EdgeInsets.all(20.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.r),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 10.r)
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildInfoRow("Order ID", orderConformModel.orderID),
                      Divider(),
                      _buildInfoRow("Sender Name", formattedDate),
                      Divider(),
                      _buildInfoRow("Total Amount",
                          "Rs. ${orderConformModel.totalAmount.toStringAsFixed(2)}"),
                      Divider(),
                      _buildInfoRow(
                          "Payment Method", orderConformModel.paymentMethod),
                      Divider(),
                      _buildInfoRow("Sender Name", senderName),
                      Divider(),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Payment Status',
                                style: TextStyle(
                                    color: Colors.black87, fontSize: 16.sp)),
                            SizedBox(
                                // width: 80.w,
                                child: FittedBox(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 8.w, vertical: 4.h),
                                decoration: BoxDecoration(
                                  color: Colors.green[100],
                                  borderRadius: BorderRadius.circular(12.r),
                                ),
                                child: Text(
                                  orderConformModel.paymentSatus,
                                  style: TextStyle(
                                    color: Colors.green[700],
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.sp,
                                  ),
                                ),
                              ),
                            ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 22.h),
                ElevatedButton(
                  onPressed: () {
                    HelperFunctions.popWithRemoveAllStates(
                        context, const UserHomeScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[600],
                    padding:
                        EdgeInsets.symmetric(horizontal: 40.w, vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.r),
                    ),
                  ),
                  child: Text(
                    "Continue Shopping",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    String truncatedValue =
        value.length > 15 ? value.substring(0, 15) + '...' : value;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.black87, fontSize: 16.sp)),
          SizedBox(
            // width: 80.w,
            child: FittedBox(
              child: Text(truncatedValue,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp)),
            ),
          ),
        ],
      ),
    );
  }
}
