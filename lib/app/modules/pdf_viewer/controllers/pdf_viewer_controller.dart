import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PdfViewerController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final url = ''.obs; // RxString
  late final AnimationController swipeCtrl;
  late final Animation<double> slide;
  RxBool showSwipeHint = true.obs;

  @override
  void onInit() {
    super.onInit();
    url.value = Get.arguments ?? ''; // isi dari argument GetX
    swipeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    slide = CurvedAnimation(parent: swipeCtrl, curve: Curves.easeInOut);
  }

  @override
  void onClose() {
    swipeCtrl.dispose();
    super.onClose();
  }
}
