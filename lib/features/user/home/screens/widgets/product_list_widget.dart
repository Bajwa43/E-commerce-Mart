import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vendoora_mart/features/user/home/controller/home_controller.dart';
import 'package:vendoora_mart/features/user/home/screens/see_all_products_screen.dart';
import 'package:vendoora_mart/features/user/home/screens/widgets/product_home_card_wdget.dart';
import 'package:vendoora_mart/features/vendor/add_Product/screens/edit_product/widget/product_cart_widget.dart';
import 'package:vendoora_mart/features/vendor/controller/product_controller.dart';
import 'package:vendoora_mart/features/vendor/domain/models/product_model.dart';
import 'package:vendoora_mart/helper/helper_functions.dart';
import 'package:vendoora_mart/services/auth_service.dart';
import 'package:vendoora_mart/utiles/constants/colors.dart';
import 'package:vendoora_mart/utiles/constants/sizes.dart';
import 'package:vendoora_mart/utiles/constants/text_string.dart';

class ProductListWidget extends StatefulWidget {
  const ProductListWidget({super.key, required this.lableName});
  final String lableName;

  @override
  State<ProductListWidget> createState() => _ProductListWidgetState();
}

class _ProductListWidgetState extends State<ProductListWidget> {
  @override
  Widget build(BuildContext context) {
    // final HomeController homeController = Get.find();
    return Padding(
      padding: EdgeInsets.only(top: TSizes.padbtWidgets),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(
              widget.lableName,
              style: TextStyle(fontSize: TSizes.productLabelS),
            ),
            TextButton(
                onPressed: () {
                  HelperFunctions.navigateToScreen(
                      context: context,
                      screen:
                          SeeAllProductsScreen(productType: widget.lableName));
                  // Get.to(() =>
                  //     SeeAllProductsScreen(productType: widget.lableName));
                },
                child: Text(
                  'See All',
                  style: TextStyle(
                      fontSize: TSizes.headingSmallS, color: TColors.IconColor),
                ))
          ]),
          GetBuilder(
            init: HomeController(),
            builder: (controller) {
              print('??????????????????? ${controller.listOfProducts.length}');
              // List<ProductModel> list = [];
              // for (var i = 0; i < controller.listOfProducts.length; i++) {
              //   if (controller.listOfProducts[i].fashionCategory ==
              //       widget.lableName) {
              //     list.add(controller.listOfProducts[i]);
              //   }
              // }
              List<ProductModel> list = controller.listOfProducts
                  .where(
                      (product) => product.fashionCategory == widget.lableName)
                  .toList();
              return SizedBox(
                height: 175.sp,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    print('Enter in Builder');
                    // List<String> listOfImages = [];
                    // HomeController homeController = Get.find();

                    // homeController.loadProductImages(index, list).then(
                    //   (value) {
                    //     listOfImages = value.toList();
                    //   },
                    // );
                    // String? imageUrl = controller
                    //     .productImageUrls[list[index].productUid ?? ''];

                    // listOfImages = _loadProductImages(index);
                    return ProductHomeCardWidget(
                      images: list[index].images,
                      onTapFav: () => controller
                          .onToggalFavt(list[index].productUid.toString()),
                      heightOfCard: 99.h,
                      widthOfCard: TSizes.homeProductW,
                      product: list[index],
                    );
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
