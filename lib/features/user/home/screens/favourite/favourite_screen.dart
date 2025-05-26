import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vendoora_mart/common/top_back_and_label_appbar.dart';
import 'package:vendoora_mart/features/user/home/controller/home_controller.dart';
import 'package:vendoora_mart/features/user/home/screens/Product_Cart_Page.dart';
import 'package:vendoora_mart/features/vendor/domain/models/product_model.dart';
import 'package:vendoora_mart/features/user/home/screens/widgets/product_home_card_wdget.dart';
import 'package:vendoora_mart/helper/firebase_helper/firebase_helper.dart';
import 'package:vendoora_mart/helper/helper_functions.dart';
import 'package:vendoora_mart/utiles/constants/colors.dart';
import 'package:vendoora_mart/utiles/constants/sizes.dart';

class FavouriteProductsScreen extends StatelessWidget {
  const FavouriteProductsScreen({super.key});

  Future<List<ProductModel>> _fetchWishlistProducts(
      String userId, HomeController controller) async {
    final wishlistSnapshot = await HelperFirebase.userInstance
        .doc(userId)
        .collection('wishlist')
        .get();

    List<ProductModel> products = [];

    for (var doc in wishlistSnapshot.docs) {
      final productId = doc.id;
      final productSnapshot =
          await HelperFirebase.productInstance.doc(productId).get();
      if (productSnapshot.exists) {
        products.add(ProductModel.fromMap(productSnapshot.data()!));
      }
    }

    return products;
  }

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    // final userId = controller.firebaseUser.value?.uid;
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return userId == null
        ? const Center(child: Text("You're not logged in"))
        : SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TopAppBarWidget(label: 'Favourites', isMenuShow: false),
                  SizedBox(height: 20.h),
                  Expanded(
                    child: FutureBuilder<List<ProductModel>>(
                      future: _fetchWishlistProducts(userId, controller),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator(
                                  color: TColors.primary));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.favorite_border,
                                  size: 100.sp, color: Colors.grey.shade400),
                              SizedBox(height: 10.h),
                              Text(
                                'No favourite products yet.',
                                style: TextStyle(
                                    fontSize: 16.sp, color: Colors.grey),
                              ),
                            ],
                          );
                        }

                        final favProducts = snapshot.data!;

                        return GridView.builder(
                          itemCount: favProducts.length,
                          padding: const EdgeInsets.only(bottom: 12),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 20.h,
                            crossAxisSpacing: 16.w,
                            childAspectRatio: 0.7,
                          ),
                          itemBuilder: (context, index) {
                            final product = favProducts[index];
                            return ProductHomeCardWidget(
                              onTap: () {
                                // HelperFunctions.showToast('sssss');
                                HelperFunctions.navigateToScreen(
                                    context: context,
                                    screen: ProductCartPage(product: product));
                              },
                              product: product,
                              images: product.images,
                              onTapFav: () => controller
                                  .onToggalFavt(product.productUid ?? ''),
                              heightOfCard: 180,
                              widthOfCard: TSizes.homeProductW,
                              isForhomeCard: false,
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
