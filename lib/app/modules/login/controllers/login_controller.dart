import 'package:get/get.dart';

class LoginController extends GetxController {
  RxBool isAgreed = false.obs;

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

  void toggleTermsAndConditions(bool newValue) {
    isAgreed.value = newValue;
  }
}
