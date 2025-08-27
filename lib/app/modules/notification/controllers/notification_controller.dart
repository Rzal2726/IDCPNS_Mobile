import 'package:get/get.dart';

class NotificationController extends GetxController {
  //TODO: Implement NotificationController
  var unreadNotifications =
      [
        {"title": "Pembayaran Gagal", "date": "23 Aug 2025"},
        {"title": "Menunggu Pembayaran", "date": "22 Aug 2025"},
        {"title": "Menunggu Pembayaran", "date": "22 Aug 2025"},
        {"title": "Menunggu Pembayaran", "date": "22 Aug 2025"},
      ].obs;

  var readNotifications =
      [
        {"title": "Pembayaran Sukses", "date": "20 Aug 2025"},
        {"title": "Tryout Selesai", "date": "18 Aug 2025"},
      ].obs;
  final count = 0.obs;
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
