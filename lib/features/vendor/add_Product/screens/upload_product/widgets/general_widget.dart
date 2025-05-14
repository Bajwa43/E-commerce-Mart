import 'package:flutter/material.dart';
import 'package:vendoora_mart/features/vendor/controller/product_controller.dart';

class GeneralWidget extends StatefulWidget {
  const GeneralWidget({super.key});

  @override
  State<GeneralWidget> createState() => _GeneralWidgetState();
}

class _GeneralWidgetState extends State<GeneralWidget> {
  final _formKey = GlobalKey<FormState>();

  // final TextEditingController _productNameController = TextEditingController();
  // final TextEditingController _priceController = TextEditingController();
  // final TextEditingController _keyFeaturesController = TextEditingController();
  // final TextEditingController _descriptionController = TextEditingController();

  // // Dropdown values
  // String? selectedFashionCategory;
  // String? selectedGender;
  // String? selectedFashionItem;

  // Options for dropdowns
  final List<String> fashionCategories = [
    'Clothing',
    'Accessories',
    'Footwear'
  ];
  final List<String> genders = ['Male', 'Female', 'Unisex'];
  final Map<String, List<String>> fashionItems = {
    'Clothing': ['Shirt', 'Pants', 'Jacket'],
    'Accessories': ['Watch', 'Bag', 'Belt'],
    'Footwear': ['Sneakers', 'Sandals', 'Boots'],
  };

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

              // Fashion Category Dropdown
              DropdownButtonFormField<String>(
                value: ProductController.selectedFashionCategory,
                decoration: const InputDecoration(
                  labelText: 'Fashion Category',
                  border: OutlineInputBorder(),
                ),
                items: fashionCategories
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    ProductController.selectedFashionCategory = value;
                    ProductController.selectedFashionItem =
                        null; // Reset fashion item dropdown
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a fashion category' : null,
              ),
              const SizedBox(height: 16),

              // Gender Dropdown
              DropdownButtonFormField<String>(
                value: ProductController.selectedGender,
                decoration: const InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
                items: genders
                    .map((gender) => DropdownMenuItem(
                          value: gender,
                          child: Text(gender),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    ProductController.selectedGender = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a gender' : null,
              ),
              const SizedBox(height: 16),

              // Fashion Item Dropdown
              DropdownButtonFormField<String>(
                value: ProductController.selectedFashionItem,
                decoration: const InputDecoration(
                  labelText: 'Fashion Item',
                  border: OutlineInputBorder(),
                ),
                items:
                    (fashionItems[ProductController.selectedFashionCategory] ??
                            [])
                        .map((item) => DropdownMenuItem(
                              value: item,
                              child: Text(item),
                            ))
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    ProductController.selectedFashionItem = value;
                  });
                },
                validator: (value) => value == null
                    ? 'Please select an item from the category'
                    : null,
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Form is valid, handle form submission
                      final productData = {
                        'Product Name':
                            ProductController.productNameController.text,
                        'Price': ProductController.priceController.text,
                        'Fashion Category':
                            ProductController.selectedFashionCategory,
                        'Gender': ProductController.selectedGender,
                        'Fashion Item': ProductController.selectedFashionItem,
                        'Key Features':
                            ProductController.keyFeaturesController.text,
                        'Description':
                            ProductController.descriptionController.text,
                      };
                      print('Product Data: $productData');
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
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

 // Controllers for text fields


 