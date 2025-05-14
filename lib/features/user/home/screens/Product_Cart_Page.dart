import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:vendoora_mart/common/Btn.dart';
import 'package:vendoora_mart/features/user/home/controller/home_controller.dart';
import 'package:vendoora_mart/features/user/home/controller/product_cart_controller.dart';
// import 'package:vendoora_mart/features/user/home/screens/all_products/second_page.dart';
import 'package:vendoora_mart/features/vendor/domain/models/product_model.dart';
import 'package:vendoora_mart/utiles/constants/colors.dart';
import 'package:vendoora_mart/utiles/constants/image_string.dart';
import 'package:vendoora_mart/utiles/constants/sizes.dart';

class ProductCartPage extends StatefulWidget {
  const ProductCartPage({super.key, required this.product});
  final ProductModel product;

  @override
  State<ProductCartPage> createState() => _ProductCartPageState();
}

class _ProductCartPageState extends State<ProductCartPage> {
  final ProductCartController cartController = Get.put(ProductCartController());
  late double width;
  late double height;

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.find();
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: height * 0.6,
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: TSizes.padOfScreen, right: TSizes.padOfScreen),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.productName.toString(),
                      style: TextStyle(fontSize: TSizes.productLabelL),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '\$${widget.product.price}',
                        style: TextStyle(fontSize: TSizes.headingMediumS),
                      ),
                    ),
                    Text(
                      '\u2B50 4.5 ( 20 review)',
                      style: TextStyle(fontSize: TSizes.headingSmallS),
                    ),
                    SizedBox(
                      height: TSizes.padbttextLabel,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Description',
                          style: TextStyle(fontSize: TSizes.productLabelL),
                        ),
                        Text(
                          'Order Summary',
                          style: TextStyle(fontSize: TSizes.productLabelL),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: TSizes.padbttextdescroption,
                    ),
                    Text(
                      '''${widget.product.description.toString()} ClothLets is a stylish and convenient online fashion store designed for trendsetters. Whether youre looking for the latest clothing trends, timeless classics, or unique accessories, ClothLets offers a seamless shopping experience with a wide range of high-quality products ''',
                      style: TextStyle(
                          fontSize: TSizes.headingMediumS,
                          color: Colors.grey.shade700),
                    ),
                    SizedBox(
                      height: TSizes.padbttextLabel,
                    ),
                    Text(
                      'Size:',
                      style: TextStyle(fontSize: TSizes.headingMediumS),
                    ),
                    SizedBox(
                      height: TSizes.padbttextdescroption,
                    ),
                    SizedBox(
                      height: 40.h, // Set a fixed height
                      child: ListView.builder(
                        scrollDirection: Axis
                            .horizontal, // Add this if it's for size selection
                        itemCount: widget.product.sizes?.length ?? 0,
                        itemBuilder: (context, index) {
                          homeController.selectSize(widget.product.sizes![0]);
                          return GestureDetector(
                            onTap: () {
                              homeController
                                  .selectSize(widget.product.sizes![index]);
                            },
                            child: Obx(
                              () => Container(
                                width: 40.w, // Adjust width for size selection
                                height: 40.h, // Keep height consistent
                                margin: EdgeInsets.symmetric(horizontal: 5),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: homeController.selectedSize.value ==
                                          widget.product.sizes![index]
                                      ? TColors.IconColor
                                      : Colors.transparent,
                                  border: Border.all(
                                    width: 2,
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(5.sp),
                                ),
                                child: Text(
                                  widget.product
                                      .sizes![index], // Display the size
                                  style: TextStyle(fontSize: 14.sp),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: TSizes.padbttextLabel,
                    ),

                    // BUTTON TO NAVIGATE

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonWidget(
                            onTap: () => homeController.addToCart(
                                context, widget.product),
                            widthOfContainer: width * 0.65,
                            textOfBtn: 'Buy Now'),
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: SizedBox(
                              width: 24,
                              height: 24,
                              child: Image.asset(TImageString.cartIcon)),
                        )
                        // Padding(
                        //   padding: const EdgeInsets.only(right: 20),
                        //   child: Icon(Icons.card_travel),
                        // )
                      ],
                    ),
                    SizedBox(
                      height: TSizes.padbttextdescroption,
                    ),
                  ],
                ),
              )
            ],
          ),
          // ANIMATED IMAGE
          Obx(() => AnimatedPositioned(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeOut,
                top: cartController.topPosition.value,
                left: cartController.leftPosition.value,
                right: cartController.leftPosition.value,
                child: Stack(children: [
                  SizedBox(
                    width: width,
                    height: height * 0.6,
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20.sp),
                        bottomRight: Radius.circular(20.sp),
                      ),
                      child: Image.network(
                        widget.product.images.last,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(40.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton.filled(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.arrow_back_sharp,
                            size: TSizes.cartIconSize,
                          ),
                          style: ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(
                            TColors.cartIconColor,
                          )),
                        ),
                        IconButton.filled(
                          onPressed: () {},
                          icon: Icon(
                            Icons.favorite,
                            size: TSizes.cartIconSize,
                            color: Colors.grey,
                          ),
                          style: ButtonStyle(
                            backgroundColor: WidgetStatePropertyAll(
                              TColors.cartIconColor,
                            ),
                          ),
                        )
                      ],
                    ),
                  )
                ]),
              )),
        ]),
      ),
    );
  }
}
