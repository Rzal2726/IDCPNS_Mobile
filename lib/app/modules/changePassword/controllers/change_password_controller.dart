import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class ChangePasswordController extends GetxController {
  final _restClient = RestClient();
  final box = GetStorage();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Visibility toggle
  var isOldPasswordHidden = true.obs;
  var isNewPasswordHidden = true.obs;
  var isConfirmPasswordHidden = true.obs;
  RxBool isLoading = false.obs;
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

  Future<void> changePassword() async {
    final newPassword = newPasswordController.text.trim();
    final oldPassword = oldPasswordController.text.trim();
    final conPassword = confirmPasswordController.text.trim();

    final url = baseUrl + apiPasswordChange;
    final payload = {
      "password": newPassword,
      "old_password": oldPassword,
      "password_confirmation": conPassword,
    };
    print("cekk ${payload.toString()}");
    isLoading.value = true;
    try {
      final result = await _restClient.postData(url: url, payload: payload);
      Get.snackbar("Berhasil", "Password berhasil diubah");
    } catch (e) {
      Get.snackbar("Gagal", "Password gagal diubah");
      debugPrint("Unexpected error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
