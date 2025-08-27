import 'package:get/get.dart';

class PengerjaanTryoutController extends GetxController {
  //TODO: Implement PengerjaanTryoutController

  RxInt numberPerPage = 3.obs;
  RxInt? numberLength;
  RxInt currentPage = 1.obs;
  RxList<Map<String, dynamic>> soalList = <Map<String, dynamic>>[{}].obs;
  RxList<Map<String, dynamic>> optionList =
      <Map<String, dynamic>>[
        {
          "1": "Option 1",
          "2": "Option 2",
          "3": "Option 3",
          "4": "Option 4",
          "5": "Option 5",
        },
      ].obs;
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
