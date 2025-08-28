import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/modules/account/views/account_view.dart';
import 'package:idcpns_mobile/app/modules/bimbel/views/bimbel_view.dart';
import 'package:idcpns_mobile/app/modules/dashboard/views/dashboard_view.dart';

class HomeController extends GetxController {
  RxInt currentIndex = 0.obs;
  RxInt tabIndex = 0.obs;

  // List halaman yang ingin ditampilkan
  final List<Widget> pages = [
    DashboardView(),
    BimbelView(),
    AccountView(),
    AccountView(),
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

  void changeBottomBar(int index) {
    print(index.toString());
    tabIndex.value = index;
    // update();
  }

  void changePage(int index) {
    currentIndex.value = index;
  }
}
