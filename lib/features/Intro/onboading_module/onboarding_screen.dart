import 'dart:developer';

import 'package:carousel_indicator/carousel_indicator.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';

import 'package:vendoora_mart/features/Intro/onboading_module/controller/pageIndex_for_scroll_controler.dart';
import 'package:vendoora_mart/features/Intro/onboading_module/onboading_model.dart';
import 'package:vendoora_mart/features/auth/auth_wraper.dart';
import 'package:vendoora_mart/helper/helper_functions.dart';
import 'package:vendoora_mart/utiles/constants/sizes.dart';

import 'components/carousel_slider_image.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final OnBoadingPageIndexController pageIndexController =
      Get.put(OnBoadingPageIndexController());

  // late CarouselController carouselTextController;
  late CarouselController carouselImageController;
  late PageController textPageControler;
  late PageController imagePageControler;
  int pageIndex = 0;
  @override
  void initState() {
    super.initState();

    // carouselTextController = CarouselController();
    carouselImageController = CarouselController();
    textPageControler = PageController(initialPage: 0, keepPage: true);
    imagePageControler = PageController(initialPage: 0, keepPage: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _topLeftButton(context),
          SizedBox(
            height: 10.h,
          ),
          // carouselSliderImages(),
          newCarousel(),
          _carouselIndicator(),
          SizedBox(
            height: 50.h,
          ),
          _txtPageBuilder(),
          _buttons(context)
        ],
      ),
    );
  }

  Widget newCarousel() {
    return Expanded(
      child: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        controller: imagePageControler,
        itemCount: OnboadingModel.listOfOnboarding.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Image.asset(OnboadingModel.listOfOnboarding[index].imagePath);
        },
      ),
    );
  }

  Expanded carouselSliderImages() {
    return Expanded(
      child: CarouselImageWidget(
        carouselController: carouselImageController,
        onselect: (selectedPageIndex) {
          setState(() {
            pageIndex = selectedPageIndex;
          });
        },
      ),
    );
  }

  Obx _carouselIndicator() {
    return Obx(() {
      return CarouselIndicator(
        index: pageIndexController.pageIndex.value,
        count: OnboadingModel.listOfOnboarding.length,
      );
    });
  }

  Expanded _buttons(BuildContext context) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 100.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
                onPressed: () {
                  if (pageIndexController.pageIndex.value != 0) {
                    // carouselImageController.previousPage();
                    textPageControler.previousPage(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.linear);
                    imagePageControler.previousPage(
                        duration: const Duration(milliseconds: 600),
                        curve: Curves.linear);
                  }
                },
                child: Text(
                  'Back',
                  style: TextStyle(fontSize: 16.sp, color: Colors.white),
                )),
            TrigareBtn(
              heightOfBtn: 48.h,
              btnName: 'Next',
              onPressed: () {
                if (pageIndexController.pageIndex.value ==
                    OnboadingModel.listOfOnboarding.length - 1) {
                  // Get.to(const StartScreen());
                  // Get.toNamed('/start');
                  HelperFunctions.navigateToScreen(
                      context: context, screen: AuthWrapper());
                }
                // carouselTextController.nextPage();
                // carouselImageController.nextPage();
                //

                textPageControler.nextPage(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.linear);
                imagePageControler.nextPage(
                    duration: const Duration(milliseconds: 800),
                    curve: Curves.linear);
                // carouselImageController.jumpToPage()
              },
            ),
          ],
        ),
      ),
    );
  }

  Expanded _txtPageBuilder() {
    return Expanded(
      child: PageView.builder(
        physics: const NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: OnboadingModel.listOfOnboarding.length,
        controller: textPageControler,
        onPageChanged: (value) {
          // carouselImageController
          // setState(() {
          //   pageIndex = value;

          // });

          pageIndexController.updatePageIndex(value);
        },
        itemBuilder: (context, index) {
          return Column(children: [
            Text(OnboadingModel.listOfOnboarding[index].title,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: KAppTypoGraphy.onBoadingTitleSize,
                    fontWeight: FontWeight.bold)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                OnboadingModel.listOfOnboarding[index].discription,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: KAppTypoGraphy.onBoadingDescriptionSize,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ]);
        },
      ),
    );
  }

  Expanded _topLeftButton(BuildContext context) {
    return Expanded(
      flex: 1,
      child: TopLeftBtn(
        isText: true,
        onPressed: () {
          HelperFunctions.navigateToScreen(
              context: context, screen: const AuthWrapper());
          // Get.toNamed('/start');
        },
      ),
    );
  }
}

class TopLeftBtn extends StatelessWidget {
  const TopLeftBtn(
      {super.key,
      required this.onPressed,
      this.isText = false,
      this.isTextThenBtnName = 'Skip',
      this.isOffPad = false});

  final VoidCallback onPressed;
  final bool isText;
  final String isTextThenBtnName;
  final bool isOffPad;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: isOffPad
              ? EdgeInsets.all(0)
              : EdgeInsets.only(left: 20.w, top: 50.w),
          child: isText
              ? Text(
                  isTextThenBtnName,
                  style: TextStyle(color: Colors.white, fontSize: 16.sp),
                )
              : Icon(
                  Icons.keyboard_arrow_left_rounded,
                  color: Colors.white,
                  size: 30.sp,
                ),
        ),
      ),
    );
  }
}

class TrigareBtn extends StatelessWidget {
  const TrigareBtn(
      {Key? key,
      this.widthOfBtn = 90,
      required this.btnName,
      required this.onPressed,
      this.flatBtn = false,
      this.padVerti,
      this.showJustIcon = false,
      this.showBothIconWithText = false,
      this.showCircle = false,
      this.inkWellEffectForCircleBtn = false,
      this.icon = const Icon(Icons.add),
      this.btnTextStyle = const TextStyle(color: Colors.white, fontSize: 16),
      this.flatBorderColor = KColors.btn,
      this.heightOfBtn,
      this.padOfIcon,
      this.padText,
      this.btnColor,
      this.onLongPress})
      : super(key: key);

  final double? widthOfBtn;
  final String btnName;
  final VoidCallback onPressed;
  final VoidCallback? onLongPress;
  final bool flatBtn;
  final double? padVerti;
  final bool showJustIcon;
  final bool showBothIconWithText;
  final Widget icon;
  final bool showCircle;
  final bool inkWellEffectForCircleBtn;
  final TextStyle btnTextStyle;
  final Color flatBorderColor;
  final double? heightOfBtn;
  final EdgeInsetsGeometry? padOfIcon;
  final EdgeInsetsGeometry? padText;
  final Color? btnColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: padVerti == null ? 10.w : padVerti!.w),
      child: InkWell(
        onLongPress: onLongPress,
        borderRadius: inkWellEffectForCircleBtn
            ? BorderRadius.circular(50.w)
            : BorderRadius.circular(10.w),
        onTap: onPressed,
        child: Container(
          clipBehavior: Clip.hardEdge,
          width: widthOfBtn,
          // height: 48.h,
          height: heightOfBtn ?? heightOfBtn,
          decoration: flatBtn
              ? BoxDecoration(
                  border: Border.all(color: flatBorderColor, width: 3.sp),
                  borderRadius: BorderRadius.circular(10.w),

                  //  color:
                )
              : showCircle
                  ? const BoxDecoration(
                      shape: BoxShape.circle, color: KColors.btn)
                  : BoxDecoration(
                      borderRadius: BorderRadius.circular(10.w),

                      color: btnColor ?? KColors.btn,
                      // color: Colors.blueAccent
                    ),
          child: Center(
              child: showBothIconWithText
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: padOfIcon == null
                              ? EdgeInsets.symmetric(horizontal: 10.w)
                              : padOfIcon!,
                          child: icon,
                        ),
                        Padding(
                          padding:
                              padText == null ? EdgeInsets.all(0) : padText!,
                          child: Text(
                            btnName,
                            style: btnTextStyle,
                          ),
                        )
                      ],
                    )
                  : showJustIcon
                      ? icon
                      : Padding(
                          padding:
                              padText == null ? EdgeInsets.all(0) : padText!,
                          child: Text(
                            btnName,
                            style:
                                TextStyle(color: Colors.white, fontSize: 16.sp),
                          ),
                        )),
        ),
      ),
    );
  }
}
