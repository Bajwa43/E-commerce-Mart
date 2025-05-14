import 'package:flutter/material.dart';
import 'package:vendoora_mart/features/vendor/add_Product/screens/upload_product/widgets/image_upload_widget.dart';
import 'package:vendoora_mart/features/vendor/add_Product/screens/upload_product/widgets/attribute/attribute_widget.dart';
import 'package:vendoora_mart/features/vendor/add_Product/screens/upload_product/widgets/general_widget.dart';
import 'package:vendoora_mart/features/vendor/add_Product/screens/upload_product/widgets/upload_data_widget.dart';

class UploadProductScreen extends StatefulWidget {
  const UploadProductScreen({super.key});

  @override
  State<UploadProductScreen> createState() => _UploadProductScreenState();
}

class _UploadProductScreenState extends State<UploadProductScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<String> _tabs = ["General", "Attribute", "Images", "Upload"];
  final List<Widget> _pages = [
    GeneralWidget(),
    SizeAttributeWidget(),
    ImageUploadWidget(),
    // ImageUploadWidget(),
    UploadDataWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        color: Colors.purple,
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width,
        child: const Center(
            child: Text('Add Item: Shopping',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold))),
      ),
      Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
        child: Column(
          children: [
            // Page Indicator
            Container(
              color: Colors.grey[200],
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: List.generate(_tabs.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        _pageController.animateToPage(
                          index,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? Colors.purple
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Text(
                          _tabs[index],
                          style: TextStyle(
                            color: _currentIndex == index
                                ? Colors.white
                                : Colors.black87,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),

            // PageView Builder
            Expanded(
              child: PageView.builder(
                physics: NeverScrollableScrollPhysics(),
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return _pages[index];
                },
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  Widget _buildIndicator({required bool isActive}) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      height: 10.0,
      width: isActive ? 20.0 : 10.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.purple : Colors.grey,
        borderRadius: BorderRadius.circular(5.0),
      ),
    );
  }
}
