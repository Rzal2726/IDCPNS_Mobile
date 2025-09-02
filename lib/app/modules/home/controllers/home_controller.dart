import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/modules/account/controllers/account_controller.dart';
import 'package:idcpns_mobile/app/modules/account/views/account_view.dart';
import 'package:idcpns_mobile/app/modules/bimbel/controllers/bimbel_controller.dart';
import 'package:idcpns_mobile/app/modules/bimbel/views/bimbel_view.dart';
import 'package:idcpns_mobile/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:idcpns_mobile/app/modules/dashboard/views/dashboard_view.dart';
import 'package:idcpns_mobile/app/modules/platinum_zone/controllers/platinum_zone_controller.dart';
import 'package:idcpns_mobile/app/modules/platinum_zone/views/platinum_zone_view.dart';

class HomeController extends GetxController {
  RxInt currentIndex = 0.obs;
  RxInt tabIndex = 0.obs;

  // List halaman yang ingin ditampilkan
  final List<Widget> pages = [
    DashboardView(),
    BimbelView(),
    PlatinumZoneView(),
    AccountView(),
  ];

  @override
  void onInit() {
    super.onInit();
    Get.lazyPut(() => AccountController());
    Get.lazyPut(() => BimbelController());
    Get.lazyPut(() => PlatinumZoneController());
    Get.lazyPut(() => DashboardController());
    print("ssada");
    // cek jika ada argument dari route
    final initialIndex = Get.arguments?['initialIndex'] ?? 0;

    tabIndex.value = initialIndex;
    currentIndex.value = initialIndex;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void changeBottomBar(int index) {
    tabIndex.value = index;
  }

  void changePage(int index) {
    currentIndex.value = index;
  }

  /// Fungsi ini dipanggil saat ingin langsung ke tab pertama
  void goToFirstTab() {
    tabIndex.value = 0;
    currentIndex.value = 0;
  }
}
