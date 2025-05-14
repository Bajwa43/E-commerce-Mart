// import 'dart:math';

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:vendoora_mart/common/top_back_and_label_appbar.dart';
// import 'package:vendoora_mart/features/user/home/controller/home_controller.dart';
// import 'package:vendoora_mart/features/user/home/domain/model/order/order_conform_model.dart';
// import 'package:vendoora_mart/features/user/order/screen/order_details_page.dart';
// import 'package:vendoora_mart/features/user/order/widgets/order_card_widget.dart';

// class OrdersPage extends StatefulWidget {
//   const OrdersPage({super.key});

//   @override
//   State<OrdersPage> createState() => _OrdersPageState();
// }

// class _OrdersPageState extends State<OrdersPage> {
//   // final HomeController hcontroller = Get.find<HomeController>();
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     // Get.put(HomeController()); // Register  Controller
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 10.w),
//         child: Column(
//           children: [
//             TopAppBarWidget(label: 'Orders', isMenuShow: false),
//             SizedBox(height: 20.h),
//             Expanded(
//               child: Obx(() {
//                 var controller = Get.find<HomeController>();
//                 List<OrderConformModel> list = controller.listOfOrderProducts;
//                 if (list.isEmpty) {
//                   return Center(
//                     child: Text('No orders available.'),
//                   );
//                 }

//                 return ListView.builder(
//                   itemCount: list.length,
//                   itemBuilder: (context, index) {
//                     return TweenAnimationBuilder(
//                       duration: Duration(milliseconds: 500),
//                       tween:
//                           Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0)),
//                       curve: Curves.easeOut,
//                       builder: (context, Offset offset, child) {
//                         return Transform.translate(
//                           offset: Offset(offset.dx * 300, 0),
//                           child: child,
//                         );
//                       },
//                       child: OrderCardWidget(
//                         orderID: "${list[index].orderID}${index + 1}",
//                         totalAmount: list[index].totalAmount,
//                         orderDate: list[index].orderDate.toDate().toLocal(),
//                         status: list[index].paymentSatus == 'Cash'
//                             ? "In Progress"
//                             : "Completed",
//                         onTap: () {
//                           Get.to(() => OrderDetailsPage());
//                         },
//                       ),
//                     );
//                   },
//                 );
//               }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vendoora_mart/common/top_back_and_label_appbar.dart';
import 'package:vendoora_mart/features/user/home/controller/home_controller.dart';
import 'package:vendoora_mart/features/user/home/domain/model/order/order_conform_model.dart';
import 'package:vendoora_mart/features/user/order/screen/order_details_page.dart';
import 'package:vendoora_mart/features/user/order/widgets/order_card_widget.dart';
import 'package:vendoora_mart/features/vendor/add_Product/screens/orders_screen/order_detail_screen.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  // final HomeController hcontroller = Get.find<HomeController>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Get.put(HomeController()); // Register  Controller
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            TopAppBarWidget(label: 'Orders', isMenuShow: false),
            SizedBox(height: 20.h),
            Expanded(
              child: Obx(() {
                print('ON SCREEN BEFORE BUILD LIST CALL');

                var controller = Get.find<HomeController>();

                List<OrderConformModel> list = controller.listOfOrderProducts;
                // List<OrderConformModel> list = controller.rxOrderList;

                print('ON SCREEN AFTER BUILD LIST CALL: ${list.length}');
                if (list.isEmpty) {
                  return Center(
                    child: Text('No orders available.'),
                  );
                }

                return ListView.builder(
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return TweenAnimationBuilder(
                      duration: Duration(milliseconds: 500),
                      tween:
                          Tween<Offset>(begin: Offset(1, 0), end: Offset(0, 0)),
                      curve: Curves.easeOut,
                      builder: (context, Offset offset, child) {
                        return Transform.translate(
                          offset: Offset(offset.dx * 300, 0),
                          child: child,
                        );
                      },
                      child: OrderCardWidget(
                        orderID: "${list[index].orderID}${index + 1}",
                        totalAmount: list[index].totalAmount,
                        orderDate: list[index].orderDate.toDate().toLocal(),
                        status: list[index].orderSatus == false
                            ? "In Progress"
                            : "Completed",
                        onTap: () {
                          Get.to(() => UserOrderDetailsPage(
                                orderConformModel: list[index],
                              ));
                        },
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
