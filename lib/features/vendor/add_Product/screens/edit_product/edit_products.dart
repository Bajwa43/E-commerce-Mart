import 'package:flutter/material.dart';
import 'package:vendoora_mart/features/vendor/add_Product/screens/edit_product/widget/edit_product_widget.dart';

class EditProductScreen extends StatefulWidget {
  const EditProductScreen({super.key});

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this); // Two tabs
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Purple Gradient Header with Tabs
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple, Colors.deepPurple],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: const EdgeInsets.only(top: 48.0, bottom: 16.0),
            child: Column(
              children: [
                // Title
                const Text(
                  'Product Management',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                // Tabs
                TabBar(
                  controller: _tabController,
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white54,
                  indicatorWeight: 3.0,
                  tabs: const [
                    Tab(text: 'Published'),
                    Tab(text: 'Unpublished'),
                  ],
                ),
              ],
            ),
          ),
          // TabBarView Content with Smooth Animation
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Published Products
                // _buildAnimatedTabContent('Published Products'),
                // Text('data'),

                EditProductWidget(published: true),
                EditProductWidget(published: false),
                // Text('data'),
                // Unpublished Products
                // _buildAnimatedTabContent('Unpublished Products'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
