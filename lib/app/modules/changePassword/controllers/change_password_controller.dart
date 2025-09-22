import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idcpns_mobile/app/Components/widgets/notifCostume.dart';
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

    // ✅ Validasi satu-satu
    if (oldPassword.isEmpty) {
      notifHelper.show("Password lama tidak boleh kosong", type: 0);
      return;
    }
    if (newPassword.isEmpty) {
      notifHelper.show("Password baru tidak boleh kosong", type: 0);
      return;
    }
    if (conPassword.isEmpty) {
      notifHelper.show("Konfirmasi password tidak boleh kosong", type: 0);
      return;
    }
    if (newPassword != conPassword) {
      notifHelper.show("Konfirmasi password tidak cocok", type: 0);
      return;
    }

    final url = baseUrl + apiPasswordChange;
    final payload = {
      "password": newPassword,
      "old_password": oldPassword,
      "password_confirmation": conPassword,
    };
    print("cekk ${payload.toString()}");

    isLoading.value = true;

    final result = await _restClient.postData(url: url, payload: payload);

    if (result['status'] == "success") {
      notifHelper.show("Password berhasil diubah", type: 1);
    } else {
      var messages = result['messages'] ?? {};

      if (messages['password'] != null && messages['password'].isNotEmpty) {
        notifHelper.show(messages['password'][0], type: 0);
      } else if (messages['password_confirmation'] != null &&
          messages['password_confirmation'].isNotEmpty) {
        notifHelper.show(messages['password_confirmation'][0], type: 0);
      } else if (messages['old_password'] != null &&
          messages['old_password'].isNotEmpty) {
        notifHelper.show(messages['old_password'][0], type: 0);
      } else {
        notifHelper.show("Password gagal diubah", type: 0);
      }
    }

    isLoading.value = false;
  }

  Future<void> checkMaintenance() async {
    final response = await _restClient.getData(
      url: baseUrl + apiCheckMaintenance,
    );
    if (response['is_maintenance']) {
      Get.offAllNamed("/maintenance");
    }
  }
}
