import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:vendoora_mart/common/Btn.dart';
import 'package:vendoora_mart/common/top_back_and_label_appbar.dart';
import 'package:vendoora_mart/features/user/home/controller/product_cart_controller.dart';
import 'package:vendoora_mart/features/user/home/screens/cart_list_page/screen/check_out_page.dart';
import 'package:vendoora_mart/features/user/home/screens/cart_list_page/widget/cart_card_widget.dart';
import 'package:vendoora_mart/features/user/home/screens/cart_list_page/widget/simple_text_value_widget.dart';
import 'package:vendoora_mart/helper/helper_functions.dart';
import 'package:vendoora_mart/utiles/constants/colors.dart';
import 'package:vendoora_mart/utiles/constants/sizes.dart';
import 'package:vendoora_mart/utiles/constants/txt_theme.dart';
import 'widget/calculated_total_widget.dart';

class CartListPage extends StatefulWidget {
  const CartListPage({super.key});

  @override
  State<CartListPage> createState() => _CartListPageState();
}

class _CartListPageState extends State<CartListPage> {
  double discount = 0;
  double deliveryCharges = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final ProductCartController controller = Get.find();
    controller.calculateSubtotal();
  }

  @override
  Widget build(BuildContext context) {
    final ProductCartController controller = Get.find();
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          TopAppBarWidget(
            label: 'Cart',
            isMenuShow: true,
          ),
          Obx(
            () {
              if (controller.cartProduct.isEmpty) {
                // WidgetsBinding.instance.addPostFrameCallback((_) {
                //   controller.isCheckOut.value = false;
                // });

                // print(
                //     'ISCHECKED == ${controller.isCheckOut.value} in Empty List');
                return SizedBox(
                  height: 330.h,
                  child: Center(
                    child: Text(
                      'No Carted Products',
                      style: TTextStyle.labelTextStyle,
                    ),
                  ),
                );
              }
              return SizedBox(
                height: 330.h,
                child: ListView.builder(
                  itemCount: controller.cartProduct.length,
                  itemBuilder: (context, index) {
                    // WidgetsBinding.instance.addPostFrameCallback((_) {
                    //   // controller.isCheckOut.refresh();
                    // });
                    // print(
                    //     'ISCHECKED == ${controller.isCheckOut.value} in Empty List');

                    return Padding(
                        padding: EdgeInsets.symmetric(vertical: 5.sp),
                        child: CartCardWidget(
                          model: controller.cartProduct[index],
                          onDelete: () {
                            controller.deleteCartProduct(
                                controller.cartProduct[index].cartedId,
                                context);

                            controller.calculateSubtotal();
                          },
                          onAdd: () {
                            controller.onIncremntProduct(
                              controller.cartProduct[index].cartedId,
                              int.parse(
                                  controller.cartProduct[index].noOfProduct),
                            );
                          },
                          onMinuse: () {
                            controller.onDecrementProduct(
                                controller.cartProduct[index].cartedId,
                                int.parse(
                                    controller.cartProduct[index].noOfProduct),
                                context);
                          },
                        ));
                  },
                ),
              );
            },
          ),

          Obx(
            () => CalculateTotalWidget(
                totalItems: controller.cartProduct.length.toString(),
                subTotal: '${controller.subTotal.value}',
                descount: '${controller.discount.value}',
                deliveryCharges: '${controller.deliveryCharges.value}',
                total: '${controller.total.value}'),
          ),

          // Padding(
          //   padding: EdgeInsets.symmetric(vertical: 20),
          //   child: ClipRRect(
          //     borderRadius: BorderRadius.circular(15.sp),
          //     child: Container(
          //       width: TSizes.fullContainerW,
          //       height: 206,
          //       color: TColors.softGrey,
          //       child: Padding(
          //         padding: EdgeInsets.only(left: 10.w, right: 10.w, top: 40.h),
          //         child: Column(
          //           children: [
          //             TextValueWidget(
          //                 label: 'Items',
          //                 value: controller.cartProduct.length.toString()),
          //             TextValueWidget(
          //                 label: 'SubTotal',
          //                 value: '\$${controller.subTotal.value}'),
          //             TextValueWidget(label: 'Discount', value: '\$4'),
          //             TextValueWidget(label: 'Delivery Charges', value: '\$2'),
          //             Divider(),
          //             TextValueWidget(
          //               label: 'Total',
          //               value: '\$${controller.total.value}',
          //               isHighlighted: true,
          //             )
          //           ],
          //         ),
          //       ),
          //     ),
          //   ),
          // ),
          Spacer(),
          // CartCardWidget()
          Padding(
              padding: EdgeInsets.all(10),
              child: Obx(
                () => ButtonWidget(
                  widthOfContainer: 343.w,
                  textOfBtn: 'Check out',
                  isFocus: controller.cartProduct.isEmpty ? false : true,
                  onTap: () {
                    HelperFunctions.navigateToScreen(
                        context: context, screen: CheckOutPage());
                  },
                  // controller.onCheckOutBtn(context),
                ),
              ))
        ]),
      ),
    );
  }
}
