import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vendoora_mart/features/user/home/controller/home_controller.dart';
import 'package:vendoora_mart/features/user/home/controller/product_cart_controller.dart';
import 'package:vendoora_mart/features/user/home/screens/Product_Cart_Page.dart';
// import 'package:vendoora_mart/features/user/home/screens/all_products/second_page.dart';
import 'package:vendoora_mart/features/user/home/screens/widgets/product_home_card_wdget.dart';
import 'package:vendoora_mart/features/vendor/domain/models/product_model.dart';
import 'package:vendoora_mart/helper/helper_functions.dart';
import 'package:vendoora_mart/utiles/constants/sizes.dart';

class SeeAllProductsScreen extends StatefulWidget {
  const SeeAllProductsScreen({super.key, required this.productType});
  final String productType;

  @override
  State<SeeAllProductsScreen> createState() => _SeeAllProductsScreenState();
}

class _SeeAllProductsScreenState extends State<SeeAllProductsScreen> {
  @override
  Widget build(BuildContext context) {
    // final ProductCartController productCartController =
    //     Get.put(ProductCartController());
    final ProductCartController productCartController = Get.find();
    final HomeController homeController = Get.find();
    List<ProductModel> list = homeController.listOfProducts
        .where((products) => products.fashionCategory == widget.productType)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'All ${widget.productType} Products',
          style: TextStyle(
            fontSize: TSizes.productLabelL,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: GridView.builder(
            itemCount: list.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 15.w,
              mainAxisSpacing: 15.h,
              childAspectRatio: 0.68,
            ),
            itemBuilder: (context, index) {
              final product = list[index];

              return ProductHomeCardWidget(
                images: list[index].images,
                onTapFav: () =>
                    homeController.onToggalFavt(product.productUid.toString()),
                isForhomeCard: false,
                product: product,
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
                // productName: product.productName.toString(),
                // priceOfProduct: product.price.toString(),
                // productId: product.productUid.toString(),
                heightOfCard: 150.h,
                widthOfCard: 160.w,
              );
            },
          ),
        ),
      ),
    );
  }
}
