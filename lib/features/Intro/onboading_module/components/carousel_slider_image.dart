import 'package:flutter/material.dart';
import 'package:vendoora_mart/features/Intro/onboading_module/onboading_model.dart';

class CarouselImageWidget extends StatelessWidget {
  const CarouselImageWidget(
      {super.key, required this.onselect, required this.carouselController});

  final Function(int selectedPageIndex) onselect;

  final CarouselController carouselController;

  @override
  Widget build(BuildContext context) {
    return CarouselView(
        itemExtent: 10,
        controller: carouselController,
        children: [
          ...List.generate(
            OnboadingModel.listOfOnboarding.length,
            (index) =>
                Image.asset(OnboadingModel.listOfOnboarding[index].imagePath),
          )
        ]);

    // return CarouselSlider.builder(
    //     carouselController: carouselController,
    //     itemCount: OnboadingModel.listOfOnboarding.length,
    //     itemBuilder: (context, index, realIndex) =>
    //         Image.asset(OnboadingModel.listOfOnboarding[index].imagePath),
    //     options: CarouselOptions(
    //         scrollPhysics: const NeverScrollableScrollPhysics(),
    //         height: 200.h,
    //         onPageChanged: (index, reason) {
    //           onselect.call(index);
    //         },
    //         initialPage: 0,
    //         // pauseAutoPlayOnTouch: false,
    //         enableInfiniteScroll: false));
  }
}
