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

  final List<Widget> pages = [
    DashboardView(),
    TryoutView(),
    BimbelView(),
    PlatinumZoneView(),
    AccountView(),
  ];

  @override
  Future<void> onInit() async {
    super.onInit();

    // Daftarkan controller secara sinkron biar langsung siap sebelum view di-build
    _registerControllers();

    // Tunggu satu microtask biar register selesai sebelum akses View
    await Future.delayed(Duration.zero);

    // Ambil argument awal (misal dari route)
    final initialIndex = Get.arguments?['initialIndex'] ?? 0;
    tabIndex.value = initialIndex;
    currentIndex.value = initialIndex;

    // Cek maintenance status
    await checkMaintenance();
  }

  void _registerControllers() {
    // Pake 'fenom' pattern GetX: periksa dulu apakah udah ada baru register
    if (!Get.isRegistered<DashboardController>()) {
      Get.lazyPut(() => DashboardController(), fenix: true);
    }
    if (!Get.isRegistered<TryoutController>()) {
      Get.lazyPut(() => TryoutController(), fenix: true);
    }
    if (!Get.isRegistered<BimbelController>()) {
      Get.lazyPut(() => BimbelController(), fenix: true);
    }
    if (!Get.isRegistered<PlatinumZoneController>()) {
      Get.lazyPut(() => PlatinumZoneController(), fenix: true);
    }
    if (!Get.isRegistered<AccountController>()) {
      Get.lazyPut(() => AccountController(), fenix: true);
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return DashboardView(key: UniqueKey());
      case 1:
        return TryoutView(key: UniqueKey());
      case 2:
        return BimbelView(key: UniqueKey());
      case 3:
        return PlatinumZoneView(key: UniqueKey());
      case 4:
        return AccountView(key: UniqueKey());
      default:
        return DashboardView(key: UniqueKey());
    }
  }

  void changeBottomBar(int index) {
    tabIndex.value = index;
    pages[index] = _buildPage(index);
  }

  void changePage(int index) {
    currentIndex.value = index;
    pages[index] = _buildPage(index);
  }

  void goToFirstTab() {
    tabIndex.value = 0;
    currentIndex.value = 0;
  }

  Future<void> checkMaintenance() async {
    try {
      final response = await restClient.getData(
        url: baseUrl + apiCheckMaintenance,
      );
      if (response['is_maintenance'] == true) {
        Get.offAllNamed("/maintenance");
      }
    } catch (e) {
      print("Error checking maintenance: $e");
    }
  }
}
