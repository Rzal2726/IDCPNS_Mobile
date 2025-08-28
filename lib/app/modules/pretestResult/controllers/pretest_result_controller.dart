import 'package:get/get.dart';

class PretestResultController extends GetxController {
  var jawabanBenar = 1.obs;
  var tambahanPoint = 17.obs;

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

  int get totalPoint => jawabanBenar.value + tambahanPoint.value;
}
