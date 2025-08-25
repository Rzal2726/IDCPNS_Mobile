import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  int _currentIndex = 0;

  // List halaman yang ingin ditampilkan
  final List<Widget> _pages = [
    Get.to,
    TryOutPage(),
    BimbelPage(),
    PlatinumPage(),
    AkunPage(),
  ];
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
