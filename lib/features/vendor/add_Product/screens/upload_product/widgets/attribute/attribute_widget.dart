import 'package:flutter/material.dart';
import 'package:vendoora_mart/features/vendor/add_Product/screens/upload_product/widgets/size_text_widget.dart';
import 'package:vendoora_mart/features/vendor/controller/product_controller.dart';

class SizeAttributeWidget extends StatefulWidget {
  const SizeAttributeWidget({super.key, this.iseditItem = false});
  final bool iseditItem;

  @override
  State<SizeAttributeWidget> createState() => _SizeAttributeWidgetState();
}

class _SizeAttributeWidgetState extends State<SizeAttributeWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display selected sizes if editing
        if (widget.iseditItem)
          Wrap(
            spacing: 8.0, // Spacing between size chips
            children: ProductController.selectedSizeList.map((size) {
              return Chip(
                label: Text(size.toString()),
                backgroundColor: Colors.purple.shade100,
              );
            }).toList(),
          ),

        const SizedBox(height: 16.0),

        // Dynamic generation of SizeTextWidgets
        ..._buildSizeCategories(),
      ],
    );
  }

  List<Widget> _buildSizeCategories() {
    // Example categories and sizes
    final List<Map<String, dynamic>> sizeCategories = [
      {
        'categoryName': 'Clothes',
        'sizes': ['S', 'M', 'L', 'XL', 'XXL', 'XXXL']
      },
      {
        'categoryName': 'Shoes',
        'sizes': ['21', '22', '23', '24', '25', '27']
      },
      {
        'categoryName': 'Accessories',
        'sizes': ['S', 'M', 'L', 'XL', 'XXL']
      },
    ];

    return sizeCategories.map((category) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: SizeTextWidget(
          categoryName: category['categoryName'],
          sizes: List<String>.from(category['sizes']),
        ),
      );
    }).toList();
  }
}
