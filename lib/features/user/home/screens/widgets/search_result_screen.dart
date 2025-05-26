import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:vendoora_mart/features/user/home/controller/home_controller.dart';
import 'package:vendoora_mart/features/user/home/controller/product_cart_controller.dart';
import 'package:vendoora_mart/features/user/home/screens/Product_Cart_Page.dart';
import 'package:vendoora_mart/features/user/home/screens/widgets/product_home_card_wdget.dart';
import 'package:vendoora_mart/features/vendor/domain/models/product_model.dart';
import 'package:vendoora_mart/helper/firebase_helper/firebase_helper.dart';
import 'package:vendoora_mart/helper/helper_functions.dart';
import 'package:vendoora_mart/utiles/constants/sizes.dart';

class SearchResultScreen extends StatelessWidget {
  final String query;

  const SearchResultScreen({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    HomeController homeController = Get.find<HomeController>();
    ProductCartController productCartController =
        Get.find<ProductCartController>();
    return Scaffold(
      appBar: AppBar(title: const Text('Search Results')),
      body: StreamBuilder<QuerySnapshot>(
        stream: HelperFirebase.productInstance
            .where('productName', isGreaterThanOrEqualTo: query)
            .where('productName', isLessThanOrEqualTo: query + '\uf8ff')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data!.docs;

          if (products.isEmpty) {
            return const Center(child: Text("No results found."));
          }

          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            child: GridView.builder(
              itemCount: products.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two columns
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 12.h,
                childAspectRatio: 0.7, // Adjust to your card’s height/width
              ),
              itemBuilder: (context, index) {
                final product = ProductModel.fromMap(
                    products[index].data() as Map<String, dynamic>);
                return ProductHomeCardWidget(
                  product: product,
                  heightOfCard: 140.h,
                  widthOfCard: 160.w,
                  // heightOfCard: TSizes.cartContainerH,
                  // widthOfCard: TSizes.addToCartW,
                  images: product.images,
                  isForhomeCard: false,
                  onTapFav: () => homeController
                      .onToggalFavt(product.productUid.toString()),

                  onTap: () {
                    HelperFunctions.navigateToScreen(
                        context: context,
                        screen: ProductCartPage(product: product));
                    productCartController.onInit(); //For Image ANimation

                    // WidgetsBinding.instance.addPostFrameCallback(
                    //   (timeStamp) => HelperFunctions.navigateToScreen(
                    //       context: context, screen: SecondPage(product: product)),
                    // );

                    print('Cliked');
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
