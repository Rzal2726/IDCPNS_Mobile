import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/modules/account/controllers/account_controller.dart';
import 'package:idcpns_mobile/app/modules/account/views/account_view.dart';
import 'package:idcpns_mobile/app/modules/bimbel/controllers/bimbel_controller.dart';
import 'package:idcpns_mobile/app/modules/bimbel/views/bimbel_view.dart';
import 'package:idcpns_mobile/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'package:idcpns_mobile/app/modules/dashboard/views/dashboard_view.dart';
import 'package:idcpns_mobile/app/modules/platinum_zone/controllers/platinum_zone_controller.dart';
import 'package:idcpns_mobile/app/modules/platinum_zone/views/platinum_zone_view.dart';
import 'package:idcpns_mobile/app/modules/tryout/controllers/tryout_controller.dart';
import 'package:idcpns_mobile/app/modules/tryout/views/tryout_view.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class HomeController extends GetxController {
  final restClient = RestClient();
  RxInt currentIndex = 0.obs;
  RxInt tabIndex = 0.obs;

  // List halaman yang ingin ditampilkan
  final List<Widget> pages = [
    DashboardView(),
    TryoutView(),
    BimbelView(),
    PlatinumZoneView(),
    AccountView(),
  ];

  @override
  void onInit() {
    super.onInit();
    Get.lazyPut(() => AccountController());
    Get.lazyPut(() => TryoutController());
    Get.lazyPut(() => BimbelController());
    Get.lazyPut(() => PlatinumZoneController());
    Get.lazyPut(() => DashboardController());
    print("ssada");
    // cek jika ada argument dari route
    final initialIndex = Get.arguments?['initialIndex'] ?? 0;

    tabIndex.value = initialIndex;
    currentIndex.value = initialIndex;
    checkMaintenance();
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

  Future<void> checkMaintenance() async {
    final response = await restClient.getData(
      url: baseUrl + apiCheckMaintenance,
    );
    if (response['is_maintenance']) {
      Get.offAllNamed("/maintenance");
    }
  }
}
