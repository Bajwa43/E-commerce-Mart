import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/list_notifier.dart';
import 'package:vendoora_mart/features/auth/screens/loginScreen.dart';
import 'package:vendoora_mart/features/user/home/controller/home_controller.dart';
import 'package:vendoora_mart/features/user/home/controller/product_cart_controller.dart';
import 'package:vendoora_mart/features/user/home/screens/favourite/favourite_screen.dart';
import 'package:vendoora_mart/features/user/home/screens/widgets/ads_scroller_widget.dart';
import 'package:vendoora_mart/features/user/home/screens/widgets/home_banner_fullscreen_widget.dart';
import 'package:vendoora_mart/features/user/home/screens/widgets/product_list_widget.dart';
import 'package:vendoora_mart/features/user/home/screens/widgets/search_result_screen.dart';
import 'package:vendoora_mart/features/user/home/screens/widgets/search_widget.dart';
import 'package:vendoora_mart/features/user/order/screen/order_page.dart';
import 'package:vendoora_mart/features/user/profile/screen/profile_screen.dart';

import 'package:vendoora_mart/utiles/constants/colors.dart';
import 'package:vendoora_mart/utiles/constants/image_string.dart';
import 'package:vendoora_mart/utiles/constants/sizes.dart';
import 'package:vendoora_mart/utiles/constants/text_string.dart';

import 'widgets/profile_widget.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  late TextEditingController searchController;
  late HomeController homeController;

  // String? url;
  @override
  void initState() {
    // TODO: implement initState
    // Get.put(
    //   HomeController(),
    // );
    super.initState();
    searchController = TextEditingController();
    if (!Get.isRegistered<HomeController>()) {
      homeController =
          Get.put(HomeController()); // Only put if not already registered
    } else {
      homeController = Get.find<HomeController>();
    }
    homeController.fetchCurrentUserData();

    if (!Get.isRegistered<ProductCartController>()) {
      Get.put(ProductCartController());
    }
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> homeScreens = [
      SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.only(
                left: TSizes.padOfScreen, right: TSizes.padOfScreen),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ProfileWidget(),
                  SearchInput(
                    textController: searchController,
                    hintText: 'Search',
                    onSubmitted: (query) {
                      if (query.trim().isNotEmpty) {
                        Get.to(() => SearchResultScreen(query: query));
                      }
                    },
                  ),

                  /// 🚀 Full screen banner carousel
                  HomeBannerFullScreenWidget(
                    imageUrls: [
                      TImageString.greyShoeImage,
                      TImageString.person,
                      TImageString.banner,
                      // TImageString.greyShoeImage,
                      // TTextString.vendorShopLogo,
                      // TTextString.productImages,
                      // 'https://via.placeholder.com/1080x400.png?text=Super+Sale+%F0%9F%92%B0',
                      // 'https://via.placeholder.com/1080x400.png?text=Fashion+Fest+2025',
                      // 'https://via.placeholder.com/1080x400.png?text=Flat+40%25+Off+on+Clothes',
                    ],
                  ),
                  ProductListWidget(lableName: TTextString.accessoriesCategory),
                  ProductListWidget(lableName: TTextString.clotheCategory),
                  ProductListWidget(lableName: TTextString.footwearCategory),
                ]),
          ),
        ),
      ),
      const Center(
        child: FavouriteProductsScreen(),
      ),
      // const Center(
      //     child: Text('Explore Screen', style: TextStyle(fontSize: 24))),
      OrdersPage(),
      ProfileScreen(),
    ];
    return Scaffold(
      // backgroundColor: TColors.grey,
      // body: Center(
      //   child: Text(
      //     'Home',
      //     style: TextStyle(fontSize: 24.sp),
      //   ),
      // ),
      body: Obx(
        () => Center(
          child: homeScreens[homeController.currentIndexOfBottomAppBar
              .value], // Show screen based on the selected index
        ), ///////
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
            selectedItemColor:
                TColors.IconColor, // Highlighted color for active tab
            unselectedItemColor: Colors.white, //
            currentIndex: homeController.currentIndexOfBottomAppBar.value,
            onTap: (index) {
              homeController.currentIndexOfBottomAppBar.value =
                  index; // Update the current index
            },
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'home',
                  backgroundColor: Color(0xFF9E9E9E)),
              BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_border), label: 'Favourite'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.card_travel_rounded), label: 'cart'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'profile')
            ]),
      ),
    );
  }
}
