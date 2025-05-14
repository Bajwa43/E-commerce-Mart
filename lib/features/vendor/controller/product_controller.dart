import 'dart:io';

import 'package:flutter/material.dart';

class ProductController {
  static final TextEditingController productNameController =
      TextEditingController();
  static final TextEditingController priceController = TextEditingController();
  static final TextEditingController keyFeaturesController =
      TextEditingController();
  static final TextEditingController descriptionController =
      TextEditingController();

  // Dropdown values
  static String? selectedFashionCategory;
  static String? selectedGender;
  static String? selectedFashionItem;

  // IMAGES GETS
  static List<String> images = [];

  // Sizes
  static List<String?> selectedSizeList = [];

  static var editedGenderController = TextEditingController();

  static var editedFashionItemController = TextEditingController();

  static var editedFashionCategoryController = TextEditingController();

  static String? productUid;

  static String? validateInputs() {
    if (productNameController.text.isEmpty) return 'Product name is required';
    if (priceController.text.isEmpty) return 'Price is required';
    if (selectedFashionCategory == null) return 'Fashion category is required';
    if (selectedGender == null) return 'Gender is required';
    if (selectedFashionItem == null) return 'Fashion item is required';
    if (keyFeaturesController.text.isEmpty) return 'Key features are required';
    if (descriptionController.text.isEmpty) return 'Description is required';
    if (images.isEmpty) return 'At least one image is required';
    if (selectedSizeList.isEmpty) return 'At least one size is required';
    return null; // All inputs are valid
  }
}
