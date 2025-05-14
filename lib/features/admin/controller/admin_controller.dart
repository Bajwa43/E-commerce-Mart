import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:vendoora_mart/features/admin/admin_dashboard/screens/dashboard/dashboard.dart';
import 'package:vendoora_mart/features/admin/admin_dashboard/screens/order/order.dart';
import 'package:vendoora_mart/features/admin/admin_dashboard/screens/product/product.dart';
import 'package:vendoora_mart/features/admin/admin_dashboard/screens/vendor/vendor.dart';
import 'package:vendoora_mart/features/auth/domain/models/user_model.dart';
import 'package:vendoora_mart/features/user/home/domain/model/order/order_conform_model.dart';
import 'package:vendoora_mart/features/vendor/controller/vender_controller.dart';
import 'package:vendoora_mart/features/vendor/domain/models/product_model.dart';
import 'package:vendoora_mart/helper/enum.dart';
import 'package:vendoora_mart/helper/firebase_helper/firebase_helper.dart';
import 'package:vendoora_mart/services/auth_service.dart';
import 'package:vendoora_mart/utiles/constants/text_string.dart';

class AdminNavController extends GetxController {
  var currentIndex = 0.obs;
  RxDouble adminTotalEarning = 0.0.obs;
  final Rxn<UserModel> adminUser = Rxn<UserModel>();
  RxString imageUrl = ''.obs;
  RxBool isSidebarOpen = false.obs;
  RxList<OrderConformModel> _listOfOrderProducts = <OrderConformModel>[].obs;
  List<OrderConformModel> get listOfOrderProducts => _listOfOrderProducts;
  RxList<ProductModel> _listOfProducts = <ProductModel>[].obs;
  List<ProductModel> get listOfProducts => _listOfProducts;
  RxList<UserModel> _listOfVendors = <UserModel>[].obs;
  List<UserModel> get listOfVendors => _listOfVendors;
  var selectedVendorTab = 'Accepted'.obs; // or use index

  final RxList<VendorOrderPreview> _orders = <VendorOrderPreview>[].obs;
  List<VendorOrderPreview> get ordersOfIndivigualVender => _orders;
  RxString selectedProductTab = 'Approved'.obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint('AdminNavController onInit called');

    _listOfOrderProducts.bindStream(getOrderProducts());
    _listOfProducts.bindStream(getProducts());
    _listOfVendors.bindStream(getVendors());
    // adminTotalEarning.value = getTotalEarnings();
    ever<List<OrderConformModel>>(_listOfOrderProducts, (_) {
      getTotalEarnings();
    });
    getUser();
    // _loadImage();
  }

  // @override
  // void onClose() {
  //   _listOfOrderProducts.close();
  //   _listOfProducts.close();
  //   super.onClose();
  // }

  void approveProduct(ProductModel product) async {
    await HelperFirebase.productInstance
        .doc(product.productUid)
        .update({'approved': true});
    // fetchAllProducts(); // or refresh your product list
  }

  void rejectProduct(ProductModel product) async {
    await HelperFirebase.productInstance
        .doc(product.productUid)
        .update({'approved': null});
    // fetchAllProducts(); // or refresh your product list
  }

  void rejectedProductDelete(ProductModel product) async {
    await HelperFirebase.productInstance.doc(product.productUid).delete();
    // .update({'approved': null})
    // fetchAllProducts(); // or refresh your product list
  }

  List<ProductModel> get filteredProducts {
    switch (selectedProductTab.value) {
      case 'Approved':
        return listOfProducts.where((p) => p.approved == true).toList();
      case 'Pending':
        return listOfProducts.where((p) => p.approved == false).toList();
      case 'Rejected':
        return listOfProducts.where((p) => p.approved == null).toList();
      default:
        return listOfProducts;
    }
  }

  // void bindOrdersStream(String vendorId) {
  //   HelperFirebase.orderConformInstance
  //       .where('venderID',
  //           isEqualTo: vendorId) // matches HelperFirebase.orderConformInstance
  //       .orderBy('orderDate', descending: true)
  //       .snapshots()
  //       .asyncMap((snapshot) async {
  //     final futures = snapshot.docs.map((doc) async {
  //       final raw = doc.data();
  //       final model = OrderConformModel.fromMap(raw);

  //       // 1️⃣ Extract the slice for this vendor
  //       final vendorSlices =
  //           model.orderItemVendor.where((v) => v.venderID == vendorId).toList();
  //       if (vendorSlices.isEmpty) return null;
  //       final mySlice = vendorSlices.first;

  //       double totalAmount = 0;

  //       for (var i = 0; i < mySlice.productList.length; i++) {
  //         totalAmount += await HelperFirebase.productInstance
  //             .doc(mySlice.productList[i].productID)
  //             .get()
  //             .then((value) {
  //           var data = value.data() as Map<String, dynamic>;
  //           return int.parse(data['price']) * mySlice.productList[i].quantity;
  //         });
  //       }

  //       // 2️⃣ Fetch buyer info
  //       final userDoc =
  //           await HelperFirebase.userInstance.doc(model.userID).get();
  //       final userData = userDoc.data() as Map<String, dynamic>? ?? {};
  //       final buyerName = userData['fullName'] as String? ?? 'Unknown';
  //       final buyerEmail = userData['email'] as String? ?? '—';

  //       // 3️⃣ Build preview
  //       return VendorOrderPreview(
  //         orderID: model.orderID,
  //         orderStatus: mySlice.orderStatus, // vendor-side status string
  //         orderSatus: model.orderSatus, // user-confirmed boolean
  //         orderDate: model.orderDate.toDate(),
  //         items: mySlice.productList,
  //         totalAmount: totalAmount,
  //         buyerName: buyerName,
  //         buyerEmail: buyerEmail,
  //       );
  //     });

  //     final previews =
  //         (await Future.wait(futures)).whereType<VendorOrderPreview>().toList();
  //     return previews;
  //   }).listen((previews) {
  //     _orders.assignAll(previews);
  //   });
  // }

  void updateVendorStatus(bool? status, String userId) async {
    try {
      // Directly update the document using the known userId
      await HelperFirebase.userInstance.doc(userId).update({
        'approved': status,
      });

      Get.snackbar(
        "Success",
        status! ? "Vendor Approved" : "Vendor Rejected",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to update vendor status: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  List<UserModel> get filteredVendors {
    switch (selectedVendorTab.value) {
      case 'Pending':
        return listOfVendors.where((v) => v.approved == false).toList();
      case 'Accepted':
        return listOfVendors.where((v) => v.approved == true).toList();
      case 'Rejected':
        return listOfVendors
            .where((v) => v.approved == null)
            .toList(); // or custom
      default:
        return listOfVendors;
    }
  }

  void getTotalEarnings() {
    double total = 0;
    for (var order in listOfOrderProducts) {
      total += order.totalAmount;
    }
    adminTotalEarning.value = total;
  }

  Stream<List<ProductModel>> getProducts() {
    return HelperFirebase.productInstanceWhichAlreadyPublished
        .snapshots()
        .map((event) {
      return event.docs.map((e) => ProductModel.fromMap(e.data())).toList();
    });
  }

  Stream<List<UserModel>> getVendors() {
    return HelperFirebase.userInstance
        .where('userType', isEqualTo: UserType.vendor.value)
        .snapshots()
        .map((event) {
      return event.docs.map((e) => UserModel.fromMap(e.data())).toList();
    });
  }

  Stream<List<OrderConformModel>> getOrderProducts() {
    print('getOrderProducts');
    return HelperFirebase.orderConformInstance
        .orderBy('orderDate', descending: true)
        .snapshots()
        .map((event) {
      print('getOrderProducts event: ${event.docs.length}');
      var list;

      list =
          event.docs.map((e) => OrderConformModel.fromMap(e.data())).toList();
      print('LIST>> ${list.length}');
      // getTotalEarnings();
      return list;
    });
  }

  // Future<void> _loadImage() async {
  //   AdminNavController contro = Get.find();
  //   String url = await AuthService.getImageUrl(
  //       '${TTextString.profileImage}/${FirebaseAuth.instance.currentUser!.uid}.jpg');
  //   contro.imageUrl.value = url;
  // }

  void getUser() async {
    try {
      final currentEmail = FirebaseAuth.instance.currentUser?.uid;
      if (currentEmail == null)
        () {
          print("No user is currently logged in.");
          return;
        };

      final snapshot = await HelperFirebase.userInstance
          .where('userId', isEqualTo: currentEmail)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final data = snapshot.docs[0].data();
        adminUser.value = UserModel(
          fullName: data['name'],
          email: data['email'],
          phone: data['phone'],
          userType: data['userType'],
          imageUrl: data['imageUrl'],
        );
      } else {
        print("Admin user not found in Firestore.");
      }
    } catch (e) {
      print("Error fetching admin user: $e");
    }
  }

  final appBarTitles = [
    'Dashboard',
    'Orders',
    'Vendors',
    'Products',
  ];
  final pages = [
    AdminDashboardPage(),
    AdminOrdersPage(),
    AdminVendorsPage(),
    AdminProductsPage()
  ];

  void changePage(int index) {
    currentIndex.value = index;
  }
}
