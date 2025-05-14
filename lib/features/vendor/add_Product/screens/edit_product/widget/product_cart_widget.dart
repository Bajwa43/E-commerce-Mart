import 'package:flutter/material.dart';
import 'package:vendoora_mart/features/vendor/add_Product/screens/edit_product/edit_Item/edit_item_screen.dart';
import 'package:vendoora_mart/features/vendor/controller/product_controller.dart';
import 'package:vendoora_mart/features/vendor/domain/models/product_model.dart';
import 'package:vendoora_mart/helper/firebase_helper/firebase_helper.dart';
import 'package:vendoora_mart/helper/helper_functions.dart';

class ProductCartWidget extends StatefulWidget {
  const ProductCartWidget({super.key, required this.product});
  final ProductModel product;

  @override
  State<ProductCartWidget> createState() => _ProductCartWidgetState();
}

class _ProductCartWidgetState extends State<ProductCartWidget> {
  double widthOfTextContainer = 100;
  double heightOfTextContainer = 50;
  bool isExpanded = true;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Align(
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.all(5),
        // height: height * 0.,
        child: Container(
          // color: Colors.blue,
          width: width * 0.95,
          child: Row(
            children: [
              // Buttons on the left side (visible when the text container is collapsed)
              if (!isExpanded) ...[
                InkWell(
                  onTap: (widget.product.publish == true &&
                          widget.product.approved != null &&
                          widget.product.approved == false)
                      ? () {}
                      : () {
                          HelperFirebase.publishProduct(
                              context,
                              widget.product.productUid.toString(),
                              widget.product.publish!);
                        },
                  child: Container(
                    height: 100,
                    width: 70,
                    color: Colors.green,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.publish, color: Colors.white),
                          (widget.product.publish == true)
                              ? (widget.product.publish == true &&
                                      widget.product.approved != null &&
                                      widget.product.approved == false)
                                  ? FittedBox(
                                      child: Text('In Process',
                                          style: TextStyle(
                                            color: Colors.red,
                                          )),
                                    )
                                  : Text('UnPublish',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ))
                              : FittedBox(
                                  child: Text('Publish',
                                      style: TextStyle(
                                        color: Colors.white,
                                      )),
                                )
                        ]),
                  ),
                ),
                InkWell(
                  onTap: () {
                    HelperFirebase.deleteFromProduct(
                        context, widget.product.productUid.toString());
                    // setState(() {});
                  },
                  child: Container(
                    width: 70,
                    height: 100,
                    color: Colors.red,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete, color: Colors.white),
                          Text('Delete',
                              style: TextStyle(
                                color: Colors.white,
                              ))
                        ]),
                  ),
                ),
              ],
              //.................................................................. Main Product Image
              Stack(children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                      widthOfTextContainer = isExpanded ? 100 : 50;
                    });
                  },
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          width: 100,
                          height: 100,
                          color: Colors.amber,
                          child:
                              //  widget.product.images != null &&
                              widget.product.images.isNotEmpty &&
                                      // widget.product.images.first != null &&
                                      widget.product.images.first.isNotEmpty
                                  ? Image.network(
                                      widget.product.images.first,
                                      fit: BoxFit.cover,
                                    )
                                  : const Icon(Icons.image_not_supported),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Animated Text Container
                      AnimatedContainer(
                        width: widthOfTextContainer,
                        height: heightOfTextContainer,
                        duration: const Duration(milliseconds: 400),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            FittedBox(
                              child: Text(
                                widget.product.productName ?? 'No Name',
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(color: Colors.black),
                              ),
                            ),
                            FittedBox(
                              child: Text(
                                'Price: ${widget.product.price ?? '0'}',
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // ................................................................Edit screen
                Positioned(
                  bottom: 3,
                  right: 3,
                  child: IconButton(
                      onPressed: () {
                        ProductController.productNameController.text =
                            widget.product.productName.toString();
                        ProductController.priceController.text =
                            widget.product.price.toString();
                        ProductController.descriptionController.text =
                            widget.product.description.toString();
                        ProductController.keyFeaturesController.text =
                            widget.product.keyFeatures.toString();
                        ProductController.editedFashionCategoryController.text =
                            widget.product.fashionCategory.toString();
                        ProductController.editedGenderController.text =
                            widget.product.gender.toString();
                        ProductController.editedFashionItemController.text =
                            widget.product.fashionItem.toString();
                        ProductController.selectedSizeList =
                            widget.product.sizes ?? [];

                        ProductController.productUid =
                            widget.product.productUid.toString();

                        HelperFunctions.navigateToScreen(
                            context: context, screen: EditItemScreen());
                      },
                      icon: Icon(
                        Icons.mode_edit_outlined,
                        color: Colors.orange,
                      )),
                )
              ]),
            ],
          ),
        ),
      ),
    );
  }
}
