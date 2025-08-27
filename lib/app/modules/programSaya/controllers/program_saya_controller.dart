import 'package:get/get.dart';

class ProgramSayaController extends GetxController {
  //TODO: Implement ProgramSayaController

  var selectedTab = 0.obs;
  var searchQuery = ''.obs;
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

  void changeTab(int index) {
    selectedTab.value = index;
  }

  void updateSearch(String value) {
    searchQuery.value = value;
  }
}
