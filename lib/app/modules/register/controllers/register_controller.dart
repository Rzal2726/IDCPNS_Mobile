import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../routes/app_pages.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';

class RegisterController extends GetxController {
  final _restClient = RestClient();
  final box = GetStorage();
  final formKey = GlobalKey<FormState>();

  // Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final affiliatorController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  RxString emailError = ''.obs;
  // State
  RxBool isAgreed = false.obs;
  RxBool isPasswordVisible = false.obs;
  RxBool isConfirmPasswordVisible = false.obs;
  RxBool isLoading = false.obs;

  // Toggle
  void toggleTermsAndConditions(bool newValue) {
    isAgreed.value = newValue;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  Future<void> onRegister() async {
    if (!isAgreed.value) {
      Get.snackbar("Error", "Anda harus menyetujui syarat & ketentuan");
      return;
    }

    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar("Error", "Password dan konfirmasi tidak cocok");
      return;
    }

    isLoading.value = true;

    try {
      final url = baseUrl + apiRegister; // pastikan endpoint benar
      final payload = {
        "name": nameController.text,
        "email": emailController.text,
        "password": passwordController.text,
        "password_confirmation": confirmPasswordController.text,
        "user_afiliator": affiliatorController.text ?? "",
      };
      print("payload ${payload.toString()}");
      final result = await _restClient.postData(url: url, payload: payload);

      if (result["status"] == "success") {
        Get.snackbar("Sukses", "Registrasi berhasil");
        Get.offNamed(Routes.EMAIL_VERIFICATION);
      } else {
        Get.snackbar("Gagal", result["message"] ?? "Terjadi kesalahan");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
