import 'package:get/get.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';

class RegisterController extends GetxController {
  RxBool isAgreed = false.obs;

  // Variabel untuk mengontrol visibilitas kata sandi
  RxBool isPasswordVisible = false.obs;
  RxBool isConfirmPasswordVisible = false.obs;

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

  // Metode untuk mengubah state checkbox
  void toggleTermsAndConditions(bool newValue) {
    isAgreed.value = newValue;
  }

  // Metode untuk mengubah visibilitas kata sandi
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Metode untuk mengubah visibilitas konfirmasi kata sandi
  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  void onRegister() {
    Get.offNamed(Routes.EMAIL_VERIFICATION);
  }
}
