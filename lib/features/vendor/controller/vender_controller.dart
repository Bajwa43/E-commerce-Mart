// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:get/get.dart';
// import 'package:vendoora_mart/features/user/home/domain/model/order/order_conform_model.dart';
// import 'package:vendoora_mart/features/user/home/domain/model/order/order_item_model.dart';
// import 'package:vendoora_mart/helper/firebase_helper/firebase_helper.dart';

// /// Lightweight preview of a vendor-specific order
// class VendorOrderPreview {
//   final String orderID;
//   final String orderStatus;
//   final bool orderSatus;
//   final DateTime orderDate;
//   final List<OrderItemModel> items;
//   final double totalAmount;
//   final String buyerName;
//   final String buyerEmail;

//   VendorOrderPreview({
//     required this.orderID,
//     required this.orderStatus,
//     required this.orderSatus,
//     required this.orderDate,
//     required this.items,
//     required this.totalAmount,
//     required this.buyerName,
//     required this.buyerEmail,
//   });
// }

// class VendorOrderController extends GetxController {
//   /// The list of orders relevant to *this* vendor
//   final RxList<VendorOrderPreview> _orders = <VendorOrderPreview>[].obs;
//   List<VendorOrderPreview> get orders => _orders;

//   late final String vendorId;

//   @override
//   void onInit() {
//     super.onInit();
//     vendorId = FirebaseAuth.instance.currentUser!.uid;
//     _bindOrdersStream();
//   }

//   void _bindOrdersStream() {
//     FirebaseFirestore.instance
//         .collection('OrderConform')
//         .orderBy('orderDate', descending: true)
//         .snapshots()
//         .asyncMap((snapshot) async {
//       final previews = <VendorOrderPreview>[];

//       for (var doc in snapshot.docs) {
//         try {
//           // Deserialize
//           final raw = doc.data();
//           final model = OrderConformModel.fromMap(raw);

//           // Extract vendor slice
//           final slice = model.orderItemVendor.firstWhere(
//             (v) => v.venderID == vendorId,
//             orElse: () => throw Exception('No slice for vendor'),
//           );

//           // Calculate totalAmount with safe parsing
//           double total = 0;
//           for (var item in slice.productList) {
//             final prodSnap = await HelperFirebase.productInstance
//                 .doc(item.productID)
//                 .get();
//             final prodData = prodSnap.data() as Map<String, dynamic>?;
//             if (prodData == null) {
//               debugPrint('⚠️ Product ${item.productID} not found, skipping');
//               continue;
//             }
//             final rawPrice = prodData['price']?.toString() ?? '0';
//             final unitPrice = int.tryParse(rawPrice) ?? 0;
//             total += unitPrice * item.quantity;
//           }

//           // Fetch buyer info safely
//           final userSnap = await HelperFirebase.userInstance
//               .doc(model.userID)
//               .get();
//           final userData = userSnap.data() as Map<String, dynamic>?;
//           final buyerName = userData?['fullName']?.toString() ?? 'Unknown';
//           final buyerEmail = userData?['email']?.toString() ?? '—';

//           // Build preview
//           previews.add(
//             VendorOrderPreview(
//               orderID: model.orderID,
//               orderStatus: slice.orderStatus.toString(),
//               orderSatus: model.orderSatus,
//               orderDate: model.orderDate.toDate(),
//               items: slice.productList,
//               totalAmount: total,
//               buyerName: buyerName,
//               buyerEmail: buyerEmail,
//             ),
//           );
//         } catch (e, st) {
//           debugPrint('❌ Error processing order ${doc.id}: $e\n$st');
//           continue;
//         }
//       }

//       return previews;
//     }).listen((previews) {
//       _orders.assignAll(previews);
//     });
//   }
// }

// lib/features/vendor/home/controller/vendor_order_controller.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:vendoora_mart/features/user/home/domain/model/order/order_conform_model.dart';
import 'package:vendoora_mart/features/user/home/domain/model/order/order_item_model.dart';
import 'package:vendoora_mart/helper/firebase_helper/firebase_helper.dart';

/// A lightweight preview model for vendor orders
class VendorOrderPreview {
  final String orderID;
  final String orderStatus; // e.g. "Pending", "Shipped", etc.
  final bool orderSatus; // user‑confirmed → delivered
  final DateTime orderDate;
  final List<OrderItemModel> items;
  final double totalAmount;
  final String buyerName;
  final String buyerEmail;

  VendorOrderPreview({
    required this.orderID,
    required this.orderStatus,
    required this.orderSatus,
    required this.orderDate,
    required this.items,
    required this.totalAmount,
    required this.buyerName,
    required this.buyerEmail,
  });
}

class VendorOrderController extends GetxController {
  /// The list of orders relevant to *this* vendor
  final RxList<VendorOrderPreview> _orders = <VendorOrderPreview>[].obs;
  List<VendorOrderPreview> get orders => _orders;
  RxString typeOfProduct = 'electronics'.obs;

  late final String vendorId;

  @override
  void onInit() {
    super.onInit();
    vendorId = FirebaseAuth.instance.currentUser!.uid;
    _bindOrdersStream();
  }

  void _bindOrdersStream() {
    HelperFirebase
        .orderConformInstance // matches HelperFirebase.orderConformInstance
        .orderBy('orderDate', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      final futures = snapshot.docs.map((doc) async {
        final raw = doc.data();
        final model = OrderConformModel.fromMap(raw);

        // 1️⃣ Extract the slice for this vendor
        final vendorSlices = model.orderItemVendor
            .where((v) => v.venderID == FirebaseAuth.instance.currentUser!.uid)
            .toList();
        if (vendorSlices.isEmpty) return null;
        final mySlice = vendorSlices.first;

        double totalAmount = 0;

        for (var product in mySlice.productList) {
          try {
            final docSnapshot = await HelperFirebase.productInstance
                .doc(product.productID)
                .get();
            final data = docSnapshot.data();

            if (data != null && data['price'] != null) {
              final priceString = data['price'].toString();
              final price = int.tryParse(priceString);
              if (price != null) {
                totalAmount += price * product.quantity;
              } else {
                print(
                    "Failed to parse price for productID: ${product.productID}");
              }
            } else {
              print(
                  "Missing data or price for productID: ${product.productID}");
            }
          } catch (e) {
            print("Error fetching product ${product.productID}: $e");
          }
        }

        // 2️⃣ Fetch buyer info
        final userDoc =
            await HelperFirebase.userInstance.doc(model.userID).get();
        final userData = userDoc.data() as Map<String, dynamic>? ?? {};
        final buyerName = userData['fullName'] as String? ?? 'Unknown';
        final buyerEmail = userData['email'] as String? ?? '—';

        // 3️⃣ Build preview
        return VendorOrderPreview(
          orderID: model.orderID,
          orderStatus: mySlice.orderStatus, // vendor-side status string
          orderSatus: model.orderSatus, // user-confirmed boolean
          orderDate: model.orderDate.toDate(),
          items: mySlice.productList,
          totalAmount: totalAmount,
          buyerName: buyerName,
          buyerEmail: buyerEmail,
        );
      });

      final previews =
          (await Future.wait(futures)).whereType<VendorOrderPreview>().toList();
      return previews;
    }).listen((previews) {
      _orders.assignAll(previews);
    });
  }
}
