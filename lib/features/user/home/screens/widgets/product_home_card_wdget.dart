import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:vendoora_mart/common/iconbtn.dart';
import 'package:vendoora_mart/features/user/home/controller/home_controller.dart';
import 'package:vendoora_mart/features/vendor/domain/models/product_model.dart';
import 'package:vendoora_mart/helper/helper_functions.dart';
import 'package:vendoora_mart/services/auth_service.dart';
import 'package:vendoora_mart/utiles/constants/image_string.dart';
import 'package:vendoora_mart/utiles/constants/sizes.dart';

import '../../../../../utiles/constants/colors.dart';
import '../Product_Cart_Page.dart';

class ProductHomeCardWidget extends StatelessWidget {
  const ProductHomeCardWidget(
      {super.key,
      required this.product,
      required this.heightOfCard,
      required this.widthOfCard,
      this.isForhomeCard = true,
      this.onTap,
      this.onTapFav,
      required this.images});

  final ProductModel product;
  final Function()? onTap;
  final Function()? onTapFav;

  // final String productName;
  // final String productId;
  // final String priceOfProduct;
  final double heightOfCard;
  final double widthOfCard;
  final bool isForhomeCard;
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    // final HomeController homeController = Get.find();

    return Padding(
      padding: EdgeInsets.only(right: 20.w, left: 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.sp),
        child: Stack(children: [
          Container(
            width: TSizes.homeProductW,
            color: TColors.darkContainer,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.sp),
                  child: SizedBox(
                    width: widthOfCard,
                    height: heightOfCard,
                    child: images.isEmpty || images.first.isEmpty
                        ? Image.asset(TImageString.greyShoeImage,
                            fit: BoxFit.fill)
                        : Image.network(
                            images.first,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons
                                  .error); // Agar image fail ho jaye to error icon dikhao
                            },
                          ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 7.w, top: 3.h, right: 7.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        child: Text(
                          product.productName.toString(),
                          style: TextStyle(fontSize: TSizes.headingMediumS),
                        ),
                      ),
                      FittedBox(
                        child: Text(
                          '\$${product.price}',
                          style: TextStyle(fontSize: TSizes.headingSmallS),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Positioned(
            top: 10.sp,
            right: 10.sp,
            child: GetBuilder(
              init: HomeController(),
              builder: (controller) {
                print(',,,,,,,: ${controller.favoriteProducts.length}');
                bool isFavorite = controller
                        .favoriteProducts[product.productUid.toString()] ??
                    false;
                return InkWell(
                  onTap: onTapFav,
                  child: isFavorite
                      ? Icon(
                          Icons.favorite,
                          size: 30.sp,
                          color: Colors.red,
                        )
                      : Icon(
                          Icons.favorite_border,
                          size: 30.sp,
                          // color: Colors.red,
                        ),
                );
              },
            ),
          ),
          !isForhomeCard
              ? Positioned(
                  bottom: 4.h,
                  right: 4.w,
                  child: IconBtnWidget(
                    onTap: onTap,
                    width: 24.w,
                    height: 24,
                  )
                  //  InkWell(
                  //     onTap: onTap,
                  //     child: const Icon(
                  //       Icons.add_circle,
                  //       color: TColors.IconColor,
                  //     ))
                  )
              : const SizedBox()
        ]),
      ),
    );
  }
}
