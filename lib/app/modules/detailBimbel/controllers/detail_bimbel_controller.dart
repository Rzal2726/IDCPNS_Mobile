import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailBimbelController extends GetxController
    with GetSingleTickerProviderStateMixin {
  var selectedPaket = 'Reguler'.obs;
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  void pilihPaket(String paket) {
    selectedPaket.value = paket;
  }
}
