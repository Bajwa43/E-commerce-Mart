import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:vendoora_mart/features/auth/domain/models/user_model.dart';
import 'package:vendoora_mart/features/user/home/controller/home_controller.dart';
import 'package:vendoora_mart/features/user/home/domain/model/carted_model.dart';
import 'package:vendoora_mart/features/user/home/domain/model/order/order_conform_model.dart';
import 'package:vendoora_mart/features/user/home/domain/model/order/order_item_model.dart';
import 'package:vendoora_mart/features/user/home/screens/cart_list_page/screen/check_out_page.dart';
import 'package:vendoora_mart/features/user/home/screens/cart_list_page/screen/checkout_receipt.dart';
import 'package:vendoora_mart/helper/firebase_helper/firebase_helper.dart';
import 'package:vendoora_mart/helper/helper_functions.dart';

class ProductCartController extends GetxController {
  var topPosition = (-300.0).obs; // Start outside the screen
  var leftPosition = 0.0.obs; // Keep it centered horizontally
  RxList<CartedModel> _cartProduct = <CartedModel>[].obs;
  List<CartedModel> get cartProduct => _cartProduct;
  RxDouble subTotal = 0.0.obs;
  RxDouble discount = 4.0.obs;
  RxDouble deliveryCharges = 2.0.obs;
  RxDouble total = 0.0.obs;

  HomeController hConroller = Get.find();

  UserModel? userObj;
  var uuid = Uuid();
  // return uuid.v4(); //

  // RxBool isCheckOut = true.obs;

  @override
  void onInit() {
    _cartProduct.bindStream(getCartProducts());
    super.onInit();
    Future.delayed(Duration(milliseconds: 200), () {
      topPosition.value = 0.0; // Move to its final position
    });
    Future.delayed(
      Duration(milliseconds: 300),
      () {
        topPosition = (-300.0).obs;
      },
    );
  }

  void toggleCartAnimation() {
    if (topPosition.value == 0.0) {
      topPosition.value = -300.0; // Move out of the screen
    } else {
      topPosition.value = 0.0; // Move to its final position
    }
  }

  void orderCheckOutCompletion(BuildContext context) async {
    try {
      // HelperFunctions.showToast('Order failed: $e');

      List<VendorOrderSepModel> vendorOrderList = [];
      bool isExistingVendor = false;

      for (var i = 0; i < cartProduct.length; i++) {
        for (var v = 0; v < vendorOrderList.length; v++) {
          if (cartProduct[i].venderId == vendorOrderList[v].venderID) {
            vendorOrderList[v].productList.add(OrderItemModel(
                productName: cartProduct[i].productName,
                size: cartProduct[i].size,
                imageUrl: cartProduct[i].image,
                orderItemID: uuid.v1(),
                productID: cartProduct[i].productId,
                quantity: int.parse(cartProduct[i].noOfProduct)));
            print('Enter in Fun');
            print('in if $v');
            isExistingVendor = true;
            break;
          }
          print('in else $v');
        }
        print('outer for $i');

        if (isExistingVendor) {
          isExistingVendor = false;
          continue;
        }

        vendorOrderList.add(
          VendorOrderSepModel(
            orderID: uuid.v1(),
            orderStatus: hConroller.cashPayment.value ? 'Pending' : 'Paid',
            venderID: cartProduct[i].venderId,
            productList: [
              OrderItemModel(
                  productName: cartProduct[i].productName,
                  size: cartProduct[i].size,
                  imageUrl: cartProduct[i].image,
                  orderItemID: uuid.v1(),
                  productID: cartProduct[i].productId,
                  quantity: int.parse(cartProduct[i].noOfProduct)),
            ],
          ),
        );
      }

      // Create OrderItems from cart
      // List<OrderItemModel> orderItems = cartProduct.map(
      //   (e) {
      //     String orderItemID = uuid.v1();
      //     return OrderItemModel(
      //       orderItemID: orderItemID,
      //       productID: e.productId,
      //       quantity: int.parse(e.noOfProduct),
      //       vendorID: e.venderId, // make sure your CartedModel has vendorID
      //     );
      //   },
      // ).toList();
      print('After in OrderItem List : ${vendorOrderList.length}');
      String userID = FirebaseAuth.instance.currentUser!.uid;
      String orderID = uuid.v1();

      // Create the full order
      OrderConformModel orderConformModel = OrderConformModel(
          // orderSatus: 'Pending',
          orderSatus: false,
          orderID: orderID,
          userID: userID,
          paymentSatus: hConroller.cashPayment.value ? 'Pending' : 'Paid',
          // orderItem: orderItems,
          orderDate: Timestamp.now(),
          paymentMethod: hConroller.cashPayment.value ? 'Cash' : 'Debit Card',
          totalAmount: total.value,
          orderItemVendor: vendorOrderList);

      print('After in OrderModel Ready');

      // Show loading/bottom sheet
      HelperFunctions.showBottomSheet(Get.context!);

      // Clear the cart
      final cartedCollection = HelperFirebase.deleteCartedItemInstance;
      final snapshot = await cartedCollection.get();
      print('After in Carted Collection: ${snapshot.docs.length}');

      for (final doc in snapshot.docs) {
        await doc.reference.delete();
      }
      print('After in Carted Delete');
      print('After in Carted Collection Delete: ${snapshot.docs.length}');

      // Reset controller values
      hConroller.cashPayment.value = true;
      hConroller.debitCardPayment.value = false;

      // Upload order to Firebase
      await HelperFirebase.orderConformInstance
          .doc(orderID)
          .set(
            orderConformModel.toMap(),
          )
          .then(
        (value) {
          print('After in  OrderConformed added to Firebase');
        },
      );

      // Get sender name from user collection
      String senderName = await HelperFirebase.userInstance
          .doc(userID)
          .get()
          .then((value) => value.data()?['fullName'] ?? 'Unknown User');

      // Hide loading and show success
      HelperFunctions.popBack(context: context);
      HelperFunctions.showToast('Order Placed Successfully');

      // Navigate to receipt screen
      HelperFunctions.navigateToScreen(
        context: context,
        screen: ReceiptScreen(
          orderConformModel: orderConformModel,
          senderName: senderName,
        ),
      );
    } catch (e) {
      HelperFunctions.popBack(context: context);
      HelperFunctions.showToast('Order failed: $e');
    }
  }

  void calculateSubtotal() {
    double tempSubTotal = 0;
    for (var i = 0; i < cartProduct.length; i++) {
      tempSubTotal += double.parse(cartProduct[i].price) *
          double.parse(cartProduct[i].noOfProduct);
    }
    subTotal.value = tempSubTotal;
    total.value = (subTotal.value - discount.value) + deliveryCharges.value;
  }

  Stream<List<CartedModel>> getCartProducts() {
    return HelperFirebase.addToCartInstance
        .orderBy('cartedDate', descending: true)
        .snapshots()
        .map(
      (event) {
        return event.docs.map((e) => CartedModel.fromMap(e.data())).toList();
      },
    );
  }

  deleteCartProduct(String productId, BuildContext context) async {
    try {
      HelperFunctions.showBottomSheet(context);
      await HelperFirebase.addToCartInstance.doc(productId).delete();
      Get.back();
      subTotal = 0.0.obs;
      HelperFunctions.showToast('Deleted Successfully');
      calculateSubtotal();
    } catch (e) {
      HelperFunctions.showToast(e.toString());
    }
  }

  onIncremntProduct(String cartedId, int value) async {
    try {
      int incrementValue = value + 1;
      await HelperFirebase.addToCartInstance
          .doc(cartedId)
          .update({'noOfProduct': incrementValue.toString()});
      calculateSubtotal();
    } catch (e) {
      HelperFunctions.showToast(e.toString());
    }
  }

  onDecrementProduct(String cartedId, int value, BuildContext context) async {
    try {
      if (value > 1) {
        int incrementValue = value - 1;
        await HelperFirebase.addToCartInstance
            .doc(cartedId)
            .update({'noOfProduct': incrementValue.toString()});
        calculateSubtotal();
      } else {
        deleteCartProduct(cartedId, context);
      }
    } catch (e) {
      HelperFunctions.showToast(e.toString());
    }
  }

  onCheckOutBtn(BuildContext context) {
    HelperFunctions.navigateToScreen(context: context, screen: CheckOutPage());
  }

  getUserProfile() async {
    var auth = FirebaseAuth.instance;
    var uid = auth.currentUser!.uid.toString();
    var user = await HelperFirebase.userInstance.doc(uid).get();
    userObj = UserModel.fromMap(user.data()!);
  }
}
