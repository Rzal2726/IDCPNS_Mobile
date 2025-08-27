import 'dart:async';

import 'package:get/get.dart';

class EmailVerificationController extends GetxController {
  var countdown = 28.obs;
  var isButtonEnabled = false.obs;

  @override
  void onInit() {
    super.onInit();
    startCountdown();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void startCountdown() async {
    while (countdown.value > 0) {
      await Future.delayed(const Duration(seconds: 1));
      countdown.value--;
    }
    isButtonEnabled.value = true;
  }

  void resendEmail() {
    countdown.value = 28;
    isButtonEnabled.value = false;
    startCountdown();
  }
}
