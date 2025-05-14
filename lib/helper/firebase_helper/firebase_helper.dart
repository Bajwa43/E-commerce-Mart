import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:uuid/uuid.dart';
import 'package:vendoora_mart/features/user/home/controller/home_controller.dart';
import 'package:vendoora_mart/features/vendor/controller/product_controller.dart';
import 'package:vendoora_mart/features/vendor/domain/models/product_model.dart';
import 'package:vendoora_mart/helper/helper_functions.dart';
import 'package:vendoora_mart/services/auth_service.dart';
import 'package:vendoora_mart/utiles/constants/text_string.dart';

class HelperFirebase {
  static HomeController homeController = Get.find();
  // static var categroyTypeFirestoreInstance =
  //     FirebaseFirestore.instance.collection('CategoryType');
  static var storageInstance = FirebaseStorage.instance;

  // static var tasksFirestoreInstance =
  //     FirebaseFirestore.instance.collection('Tasks');

  // static

  static var orderProductsInstance = HelperFirebase.orderConformInstance.where(
      'userID',
      isEqualTo: FirebaseAuth.instance.currentUser!.uid.toString());

  static var userInstance =
      FirebaseFirestore.instance.collection('VenderUsers');

  static var addToCartInstance = HelperFirebase.userInstance
      .doc(homeController.firebaseUser.value?.uid.toString())
      // .doc()
      .collection('Carted');
  static var productInstance =
      FirebaseFirestore.instance.collection('VenderProducts');

  static var productInstanceWhichAlreadyPublished =
      HelperFirebase.productInstance.where('publish', isEqualTo: true);

  static var orderConformInstance =
      FirebaseFirestore.instance.collection('OrderConform');

  static var deleteCartedItemInstance = HelperFirebase.userInstance
      .doc(homeController.firebaseUser.value?.uid.toString())
      .collection('Carted');
  // .doc(homeController.firebaseUser.value?.uid.toString())
  // .collection('Carted');

  static publishProduct(
      BuildContext context, String productUid, bool currentStatus) async {
    try {
      HelperFunctions.showBottomSheet(context);
      await productInstance.doc(productUid).update({'publish': !currentStatus});
      HelperFunctions.popBack(context: context);
      // HelperFunctions.popBack(context: context);
      String action = currentStatus ? 'Unpublished' : 'Published';
      HelperFunctions.showToast('Product $action successfully!');
    } catch (e) {
      HelperFunctions.showToast(e.toString());
    }
  }

  static updateItem(
      BuildContext context, String productUid, var productData) async {
    try {
      HelperFunctions.showBottomSheet(context);
      await productInstance.doc(productUid).update(productData);
      HelperFunctions.popBack(context: context);
      HelperFunctions.showToast('Udated');
    } catch (e) {
      HelperFunctions.showToast(e.toString());
    }
  }

  static deleteFromProduct(BuildContext context, String id) async {
    try {
      HelperFunctions.showBottomSheet(context);
      await productInstance.doc(id).delete();
      HelperFunctions.popBack(context: context);
      HelperFunctions.showToast('Product Delete successfully!');
    } catch (e) {
      HelperFunctions.showToast(e.toString());
    }
  }

  static Future uploadAllData(BuildContext context) async {
    String? validationMessage = ProductController.validateInputs();
    if (validationMessage != null) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(validationMessage)),
      );
      return;
    }

    String productId = const Uuid().v4(); // Generate unique ID for the product

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator.adaptive(
            valueColor: AlwaysStoppedAnimation(Colors.amberAccent),
          ),
        ),
      );

      var venderId = FirebaseAuth.instance.currentUser!.uid;

      ProductModel productData = ProductModel(
        // images: ProductController.images,
        approved: false,
        images: ProductController.images,
        venderUid: venderId,
        productUid: productId,
        publish: false,
        productName: ProductController.productNameController.text,
        price: ProductController.priceController.text,
        fashionCategory: ProductController.selectedFashionCategory,
        gender: ProductController.selectedGender,
        fashionItem: ProductController.selectedFashionItem,
        keyFeatures: ProductController.keyFeaturesController.text,
        description: ProductController.descriptionController.text,
        sizes: ProductController.selectedSizeList.cast<String>(),
      );

      for (var i = 0; i < ProductController.images.length; i++) {
        productData.images[i] = await AuthService.uploadImageToStorage(
            File(ProductController.images[i]),
            '$productId/${i + 1}',
            TTextString.productImages);
      }

      // Upload product to Firestore
      await HelperFirebase.productInstance
          .doc(productId)
          .set(productData.toMap())
          .then(
        (value) {
          HelperFunctions.popBack(context: context);
          ProductController.images = [];
          HelperFunctions.showToast('Product uploaded successfully');

          ProductController.productNameController.text = '';
          ProductController.priceController.text = '';
          ProductController.descriptionController.text = '';
          ProductController.keyFeaturesController.text = '';

          // ProductController.selectedFashionCategory = '';
          // ProductController.selectedFashionItem = '';
          // ProductController.selectedGender = '';
          ProductController.selectedSizeList = [];
        },
      );
    } catch (e) {
      print('Error uploading product: $e');
      throw Exception('Failed to upload product: $e');
    }
  }

  static Future<String> getUserName({required String userId}) async {
    try {
      final doc = await userInstance.doc(userId).get();
      print("Fetched user doc: ${doc.data()}");

      if (doc.exists && doc.data() != null && doc.data()!.containsKey('name')) {
        return doc['name'] ?? 'Unknown';
      } else {
        return 'Unknown';
      }
    } catch (e) {
      print('Error fetching username: $e');
      return 'Unknown';
    }
  }
}
