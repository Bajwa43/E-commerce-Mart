import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vendoora_mart/features/auth/domain/models/user_model.dart';
import 'package:vendoora_mart/features/user/home/domain/model/carted_model.dart';
import 'package:vendoora_mart/features/user/home/domain/model/order/order_conform_model.dart';
import 'package:vendoora_mart/features/user/home/domain/model/wishlist_model.dart';
import 'package:vendoora_mart/features/user/home/screens/cart_list_page/cart_list_page.dart';
import 'package:vendoora_mart/features/vendor/domain/models/product_model.dart';
import 'package:vendoora_mart/helper/firebase_helper/firebase_helper.dart';
import 'package:vendoora_mart/helper/helper_functions.dart';
import 'package:vendoora_mart/services/auth_service.dart';
import 'package:vendoora_mart/utiles/constants/image_string.dart';
import 'package:uuid/uuid.dart';
import 'package:vendoora_mart/utiles/constants/text_string.dart';

class HomeController extends GetxController {
  final uuid = const Uuid();
  RxString imageUrl = ''.obs;
  RxList<ProductModel> _listOfProducts = <ProductModel>[].obs;
  List<ProductModel> get listOfProducts => _listOfProducts;

  RxList<OrderConformModel> _listOfOrderProducts = <OrderConformModel>[].obs;
  List<OrderConformModel> get listOfOrderProducts => _listOfOrderProducts;
  RxInt currentIndexOfBottomAppBar = 0.obs;

  Rx<User?> firebaseUser = Rx<User?>(FirebaseAuth.instance.currentUser);
  RxMap<String, bool> favoriteProducts = <String, bool>{}.obs;

  RxString selectedSize = ''.obs;
  RxMap<String, String> productImageUrls = <String, String>{}.obs;
  RxBool cashPayment = true.obs;
  RxBool debitCardPayment = false.obs;
  RxBool isConformOrder = false.obs;
  Rxn<UserModel> currentUserModel = Rxn<UserModel>();

  void selectSize(String size) {
    selectedSize.value = size;
  }

  @override
  void onInit() {
    super.onInit();
    _listOfProducts.bindStream(getProducts());
    _listOfOrderProducts.bindStream(getOrderProducts());
    loadFavorites();
    fetchCurrentUserData();
  }

  Future<void> fetchCurrentUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final doc = await HelperFirebase.userInstance.doc(uid).get();
      if (doc.exists) {
        print("✅ Document data: ${doc.data()}");
        currentUserModel.value = UserModel.fromMap(doc.data()!);
      } else {
        print("❌ Document does not exist in Firestore for UID: $uid");
      }
    }
  }

  void preloadFirstImages() async {
    for (var product in listOfProducts) {
      try {
        if (product.images.isNotEmpty) {
          String imagePath =
              '${TTextString.productImages}/${product.productUid}/1.jpg';
          String imageUrl = await AuthService.getImageUrl(imagePath);
          productImageUrls[product.productUid!] = imageUrl;
        }
      } catch (e) {
        print("⚠️ Error loading image for ${product.productUid}: $e");
        // Optionally, assign a placeholder image or leave it empty
        productImageUrls[product.productUid!] = ""; // or some default asset url
      }
    }
    update();
  }

  void addToCart(BuildContext context, ProductModel product) async {
    // final userId = FirebaseAuth.instance.currentUser!.uid;
    final cartRef = HelperFirebase.addToCartInstance;

    // 1️⃣ First look for an existing cart item with same productId (and size):
    QuerySnapshot existing = await cartRef
        .where('productId', isEqualTo: product.productUid)
        .where('size', isEqualTo: selectedSize.value)
        .limit(1)
        .get();

    HelperFunctions.showBottomSheet(context);

    if (existing.docs.isNotEmpty) {
      // 2️⃣ Already in cart → increment quantity
      final doc = existing.docs.first;
      final data = doc.data() as Map<String, dynamic>;

      // Parse existing quantity and add 1
      int currentQty = int.tryParse(data['noOfProduct'] as String) ?? 1;
      int newQty = currentQty + 1;

      await doc.reference.update({
        'noOfProduct': newQty.toString(),
        'cartedDate': Timestamp.now(), // optionally update timestamp
      });
    } else {
      // 3️⃣ Not in cart → add new document
      String docId = cartRef.doc().id; // auto‐generated ID
      Timestamp timestampNow = Timestamp.now();

      CartedModel cartedModel = CartedModel(
        cartedId: docId,
        venderId: product.venderUid.toString(),
        cartedDate: timestampNow,
        productId: product.productUid.toString(),
        productName: product.productName.toString(),
        price: product.price.toString(),
        size: selectedSize.value,
        noOfProduct: '1',
        image: product.images.first.toString(),
        categoryType: product.fashionCategory.toString(),
      );

      await cartRef.doc(docId).set(cartedModel.toMap());
    }

    // 4️⃣ Finish up
    Get.back(); // close loading sheet
    // selectedSize.value = ''; // clear selection
    HelperFunctions.navigateToScreen(
      context: context,
      screen: CartListPage(),
    );
  }

  // void addToCart(BuildContext context, ProductModel product) async {
  //   String docId = uuid.v4(); // Generate a unique ID
  //   Timestamp timestampNow = Timestamp.now();

  //   CartedModel cartedModel = CartedModel(
  //     cartedId: docId,
  //     cartedDate: timestampNow,
  //     productId: product.productUid.toString(),
  //     productName: product.productName.toString(),
  //     price: product.price.toString(),
  //     size: selectedSize.value,
  //     noOfProduct: '1',
  //     image: product.images.first.toString(),
  //     categoryType: product.fashionCategory.toString(),
  //   );
  //   try {
  //     HelperFunctions.showBottomSheet(context);
  //     await HelperFirebase.addToCartInstance
  //         .doc(docId)
  //         .set(cartedModel.toMap());
  //     Get.back();
  //     selectedSize = "".obs;
  //     HelperFunctions.navigateToScreen(
  //         context: context, screen: CartListPage());
  //   } catch (e) {
  //     HelperFunctions.showToast(e.toString());
  //   }
  // }

  /// 🛒 **Load User's Favorites from Firestore**
  void loadFavorites() async {
    if (firebaseUser.value == null) return;
    var snapshot = await HelperFirebase.userInstance
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('wishlist')
        .get();
    for (var doc in snapshot.docs) {
      favoriteProducts[doc.id] =
          true; // setting the value (true) in Key (doc.id)
    }
    update(); // Refresh UI
  }

  /// ❤️ **Toggle Favorite Status**
  Future<void> onToggalFavt(String productId) async {
    if (firebaseUser.value == null) return;
    final wishlistRef = HelperFirebase.userInstance
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('wishlist')
        .doc(productId);
    if (favoriteProducts.containsKey(productId)) {
      favoriteProducts.remove(productId);
      await wishlistRef.delete(); // Remove from Firestore
    } else {
      favoriteProducts[productId] = true;
      await wishlistRef.set(
          WishlistModel(productId: productId, addedAt: Timestamp.now())
              .toMap());
    }
    update(); // Refresh UI
  }

  /// 📦 **Get List of Products**
  Stream<List<OrderConformModel>> getOrderProducts() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return Stream.value([]); // safety check

    return HelperFirebase.orderConformInstance
        .where('userID', isEqualTo: user.uid) // 🔥 filter by user
        .orderBy('orderDate', descending: true)
        .snapshots()
        .map((event) {
      return event.docs
          .map((e) => OrderConformModel.fromMap(e.data()))
          .toList();
    });
  }

  /// 📦 **Get List of Products**
  Stream<List<ProductModel>> getProducts() {
    return HelperFirebase.productInstanceWhichAlreadyPublished
        .where('approved', isEqualTo: true)
        .snapshots()
        .map((event) {
      return event.docs.map((e) => ProductModel.fromMap(e.data())).toList();
    });
  }

  static List<Widget> adsList = [
    Container(
      color: Colors.red,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Center(child: Text("First index")),
        Image.asset(TImageString.greyShoeImage)
      ]),
    ),
    Container(
      color: Colors.blue,
      child: Row(children: [
        Center(child: Text("Second index")),
        Image.asset(TImageString.greyShoeImage)
      ]),
    ),
    Container(
      color: Colors.green,
      child: Row(children: [
        Center(child: Text("Third index")),
        Image.asset(TImageString.greyShoeImage)
      ]),
    ),
  ];

  // Future<List<String>> loadProductImages(
  //     int index, List<ProductModel> list) async {
  //   // HomeController homeController = Get.find();
  //   List<String> images = [];

  //   for (var i = 0; i < list[index].images.length; i++) {
  //     images[i] = await AuthService.getImageUrl(
  //         '${TTextString.productImages}/${list[index].productUid}/${i + 1}.jpg');
  //   }
  //   return images;
  // }
}
