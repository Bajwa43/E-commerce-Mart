import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vendoora_mart/common/iconbtn.dart';
import 'package:vendoora_mart/features/user/home/domain/model/carted_model.dart';
import 'package:vendoora_mart/utiles/constants/colors.dart';
import 'package:vendoora_mart/utiles/constants/image_string.dart';
import 'package:vendoora_mart/utiles/constants/txt_theme.dart';

class CartCardWidget extends StatelessWidget {
  const CartCardWidget({
    super.key,
    required this.model,
    this.onDelete,
    this.onMinuse,
    this.onAdd,
  });
  final CartedModel model;
  final VoidCallback? onDelete;
  final VoidCallback? onMinuse;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        width: 343.w,
        height: 110.h,
        color: TColors.darkContainer,
        child: Padding(
          padding: EdgeInsets.all(7.r),
          child: Stack(
            children: [
              Row(
                children: [
                  // Product image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: SizedBox(
                      width: 126.w,
                      height: 99.h,
                      child: Image.network(
                        model.image,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Icon(Icons.broken_image, size: 40.sp),
                      ),
                    ),
                  ),

                  // Text details + size
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Product name
                          Text(model.productName,
                              style: TTextStyle.labelTextStyle),

                          // Size line added here
                          Text(
                            'Size: ${model.size}',
                            style: TTextStyle.brandTextStyle.copyWith(
                              fontSize: 12.sp,
                              color: Colors.white70,
                            ),
                          ),

                          // Category and price
                          Text(model.categoryType,
                              style: TTextStyle.brandTextStyle),
                          Text('\$${model.price}',
                              style: TTextStyle.priceTextStyle),
                        ],
                      ),
                    ),
                  ),

                  // Delete icon
                  InkWell(
                    onTap: onDelete,
                    child: Padding(
                      padding: EdgeInsets.all(8.r),
                      child: SizedBox(
                        width: 24.w,
                        height: 24.h,
                        child: Image.asset(TImageString.deleteBasket),
                      ),
                    ),
                  ),
                ],
              ),

              // Quantity controls
              Positioned(
                bottom: 8.h,
                right: 8.w,
                child: Container(
                  height: 32.h,
                  decoration: BoxDecoration(
                    color: TColors.darkContainer,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconBtnWidget(
                        onTap: onMinuse,
                        icon: Icons.remove,
                        iconSize: 14.sp,
                        width: 32.w,
                        height: 32.h,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12.w),
                        child: Text(
                          model.noOfProduct,
                          style: TTextStyle.labelTextStyle,
                        ),
                      ),
                      IconBtnWidget(
                        onTap: onAdd,
                        icon: Icons.add,
                        iconSize: 14.sp,
                        width: 32.w,
                        height: 32.h,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
