import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendoora_mart/features/user/home/screens/cart_list_page/widget/simple_text_value_widget.dart';
import 'package:vendoora_mart/utiles/constants/colors.dart';
import 'package:vendoora_mart/utiles/constants/sizes.dart';
import 'package:vendoora_mart/utiles/constants/txt_theme.dart';

class CalculateTotalWidget extends StatelessWidget {
  const CalculateTotalWidget(
      {super.key,
      required this.totalItems,
      required this.subTotal,
      required this.descount,
      required this.deliveryCharges,
      required this.total,
      this.isLabelShow = false});
  final isLabelShow;
  final String totalItems;
  final String subTotal;
  final String descount;
  final String deliveryCharges;
  final String total;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // padding: EdgeInsets.symmetric(vertical: 20),
      padding: EdgeInsets.symmetric(vertical: 10),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.sp),
        child: Container(
          width: TSizes.fullContainerW,
          height: 167.h,
          color: TColors.softGrey,
          child: Padding(
            padding: EdgeInsets.only(
                left: 10.w, right: 10.w, top: isLabelShow ? 15 : 40.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                isLabelShow
                    ? Text('Order Summary', style: TTextStyle.tableHeader)
                    : SizedBox(),
                TextValueWidget(label: 'Items', value: totalItems),
                TextValueWidget(label: 'SubTotal', value: '\$$subTotal'),
                TextValueWidget(label: 'Discount', value: '\$$descount'),
                TextValueWidget(
                    label: 'Delivery Charges', value: '\$$deliveryCharges'),
                Divider(),
                TextValueWidget(
                  label: 'Total',
                  value: '\$$total',
                  isHighlighted: true,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
