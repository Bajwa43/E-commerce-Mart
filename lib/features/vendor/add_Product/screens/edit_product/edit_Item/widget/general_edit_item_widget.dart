import 'package:flutter/material.dart';
import 'package:vendoora_mart/features/vendor/controller/product_controller.dart';
import 'package:vendoora_mart/features/vendor/domain/models/product_model.dart';
import 'package:vendoora_mart/helper/firebase_helper/firebase_helper.dart';
import 'package:vendoora_mart/helper/helper_functions.dart';

class GeneralEditItemWidget extends StatefulWidget {
  const GeneralEditItemWidget({super.key, required this.prosuctUid});
  final String prosuctUid;

  @override
  State<GeneralEditItemWidget> createState() => _GeneralEditItemWidgetState();
}

class _GeneralEditItemWidgetState extends State<GeneralEditItemWidget> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Name Field
              TextFormField(
                controller: ProductController.productNameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter product name' : null,
              ),
              const SizedBox(height: 16),

              // Price Field
              TextFormField(
                controller: ProductController.priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter product price' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: ProductController.editedFashionCategoryController,
                // maxLines: 3,
                // autofocus: true,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: 'Fashion Category',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter key features' : null,
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: ProductController.editedGenderController,
                // maxLines: 3,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),
              TextFormField(
                controller: ProductController.editedFashionItemController,

                // maxLines: 3,
                enabled: false,
                decoration: const InputDecoration(
                  labelText: 'Fashion Item',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter key features' : null,
              ),
              const SizedBox(height: 16),

              // Key Features Field
              TextFormField(
                controller: ProductController.keyFeaturesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Key Features',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter key features' : null,
              ),
              const SizedBox(height: 16),

              // Description Field
              TextFormField(
                controller: ProductController.descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Please enter a description' : null,
              ),
              const SizedBox(height: 24),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      // var list = ProductController.selectedSizeList;
                      // ProductController.selectedSizeList = [];
                      // Form is valid, handle form submission
                      // ProductModel productModel = ProductModel(images: images);
                      // final productData = {
                      //   'productName':
                      //       ProductController.productNameController.text,
                      //   'price': ProductController.priceController.text,
                      //   'fashionCategory':
                      //       ProductController.editedFashionCategoryController,
                      //   'gender': ProductController.editedGenderController,
                      //   'fashionItem':
                      //       ProductController.editedFashionItemController,
                      //   'keyFeatures':
                      //       ProductController.keyFeaturesController.text,
                      //   'description':
                      //       ProductController.descriptionController.text,
                      // };
                      HelperFunctions.showBottomSheet(context);
                      await HelperFirebase.productInstance
                          .doc(widget.prosuctUid)
                          .update({
                        'productName':
                            ProductController.productNameController.text,
                        'price': ProductController.priceController.text,
                        'keyFeatures':
                            ProductController.keyFeaturesController.text,
                        'description':
                            ProductController.descriptionController.text,
                        // 'size': (ProductController.selectedSizeList.length = 0),
                        'sizes': ProductController.selectedSizeList
                      });
                      // print('Product Data: $productData');
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Product added successfully')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber,
                    padding: const EdgeInsets.all(16),
                  ),
                  child: const Text('update'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
