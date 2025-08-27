import 'package:get/get.dart';

class WishlistController extends GetxController {
  //TODO: Implement WishlistController

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

  void updateSearch(String value) {
    searchQuery.value = value;
  }
}
