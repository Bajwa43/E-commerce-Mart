import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vendoora_mart/common/Btn.dart';
import 'package:vendoora_mart/common/top_back_and_label_appbar.dart';
import 'package:vendoora_mart/features/user/home/controller/product_cart_controller.dart';
import 'package:vendoora_mart/features/auth/screens/dayn_night_animate.dart';
import 'package:vendoora_mart/features/user/home/screens/cart_list_page/screen/checkout_receipt.dart';
import 'package:vendoora_mart/features/user/home/screens/cart_list_page/widget/calculated_total_widget.dart';
import 'package:vendoora_mart/features/user/home/screens/cart_list_page/widget/check-out_widget.dart';
import 'package:vendoora_mart/features/user/home/screens/cart_list_page/widget/map/map_controller.dart';
import 'package:vendoora_mart/features/user/home/screens/cart_list_page/widget/payment_container.dart';
import 'package:vendoora_mart/helper/helper_functions.dart';
import 'package:vendoora_mart/utiles/constants/image_string.dart';
import 'package:vendoora_mart/utiles/constants/sizes.dart';
import 'package:vendoora_mart/utiles/constants/txt_theme.dart';

class CheckOutPage extends StatefulWidget {
  const CheckOutPage({super.key});

  @override
  State<CheckOutPage> createState() => _CheckOutPageState();
}

class _CheckOutPageState extends State<CheckOutPage> {
  final ProductCartController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    // late MapController mapController;

    @override
    void initState() {
      // TODO: implement initState
      super.initState();
      // mapController = Get.put(MapController());
      // mapController.fetchLocation();
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopAppBarWidget(label: 'Check Out'),
            CheckOutWidget(
                // onTap: () {
                //   HelperFunctions.showToast('hy');
                // },
                colorLogoContainer: Color.fromRGBO(240, 241, 242, 0.098),
                title: 'mapController.currentPosition.toString()',
                imageUrl: TImageString.adressLogo.toString()),
            CheckOutWidget(
                colorLogoContainer: Color.fromRGBO(99, 205, 255, 0.1),
                title: 'Your order is Arrived in 2 Days ',
                imageUrl: TImageString.adressLogo.toString()),
            Spacer(),
            CalculateTotalWidget(
                isLabelShow: true,
                totalItems: controller.cartProduct.length.toString(),
                subTotal: controller.subTotal.value.toString(),
                descount: controller.discount.value.toString(),
                deliveryCharges: controller.deliveryCharges.value.toString(),
                total: controller.total.value.toString()),
            OrderPaymentWidget(),
            Padding(
              padding: EdgeInsets.all(10),
              child: ButtonWidget(
                  widthOfContainer: TSizes.fullContainerW,
                  onTap: () {
                    // HelperFunctions.navigateToScreen(
                    //     context: context, screen: ReceiptScreen());
                    controller.orderCheckOutCompletion(context);
                  },
                  textOfBtn: 'Check Out'),
            )
          ],
        ),
      ),
    );
  }
}
