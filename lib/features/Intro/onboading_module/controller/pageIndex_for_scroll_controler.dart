import 'package:get/get.dart';

class OnBoadingPageIndexController extends GetxController {
  RxInt pageIndex = 0.obs;

  updatePageIndex(int value) => pageIndex.value = value;

  incrementPageIndex() => pageIndex.value++;

  decrementPageIndex() => pageIndex.value--;
}
