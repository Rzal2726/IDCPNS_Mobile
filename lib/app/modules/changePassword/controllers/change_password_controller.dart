import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Visibility toggle
  var isOldPasswordHidden = true.obs;
  var isNewPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;

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

  void toggleOldPassword() {
    isOldPasswordHidden.value = !isOldPasswordHidden.value;
  }

  void toggleNewPassword() {
    isNewPasswordHidden.value = !isNewPasswordHidden.value;
  }

  void toggleConfirmPassword() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  void savePassword() {
    if (newPasswordController.text != confirmPasswordController.text) {
      Get.snackbar("Error", "Konfirmasi kata sandi tidak sama");
      return;
    }
    // TODO: Tambahkan logic API untuk ubah password
    Get.snackbar("Berhasil", "Kata sandi berhasil diubah");
  }
}
