import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';

class AccountController extends GetxController {
  final box = GetStorage();
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

  /// Fungsi logout aman
  void logout() {
    // Hapus semua controller yang mungkin masih aktif
    // if (Get.isRegistered<ForgetPasswordController>()) {
    //   Get.delete<ForgetPasswordController>();
    // }

    // Tambahkan controller lain yang perlu dihapus saat logout
    // if (Get.isRegistered<ControllerLain>()) Get.delete<ControllerLain>();

    // Hapus storage
    final box = GetStorage();

    // Navigate ke halaman login
  }
}
