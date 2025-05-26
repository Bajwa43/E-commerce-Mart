import 'package:vendoora_mart/utiles/constants/app_assets.dart';
import 'package:vendoora_mart/utiles/constants/text_strings.dart';

class OnboadingModel {
  String imagePath;
  String title;
  String discription;

  OnboadingModel(
      {required this.discription,
      required this.imagePath,
      required this.title});

  static List<OnboadingModel> listOfOnboarding = [
    OnboadingModel(
        discription: KText.onBoadingDescription1,
        imagePath: KAppAssets.onboardingFirstImage,
        title: KText.onBoadingTitle1),
    OnboadingModel(
        discription: KText.onBoadingDescription2,
        imagePath: KAppAssets.onboardingSecondImage,
        title: KText.onBoadingTitle2),
    OnboadingModel(
        discription: KText.onBoadingDescription3,
        imagePath: KAppAssets.onboardingThirtImage,
        title: KText.onBoadingTitle3),
  ];
}
