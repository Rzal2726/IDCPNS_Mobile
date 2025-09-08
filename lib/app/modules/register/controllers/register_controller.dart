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
  final regEmailController = TextEditingController();
  final regPasswordController = TextEditingController();
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

    if (regPasswordController.text != confirmPasswordController.text) {
      Get.snackbar("Error", "Password dan konfirmasi tidak cocok");
      return;
    }

    isLoading.value = true;
    try {
      final url = baseUrl + apiRegister;
      final payload = {
        "name": nameController.text,
        "email": regEmailController.text,
        "password": regPasswordController.text,
        "password_confirmation": confirmPasswordController.text,
        "user_afiliator": affiliatorController.text ?? "",
      };

      final result = await _restClient.postData(url: url, payload: payload);

      if (result["status"] == "success") {
        // Ambil data dari response
        final data = result["data"];
        final user = data["user"];

        // Simpan ke GetStorage
        final box = GetStorage();
        box.write("token", data["access_token"]);
        box.write("name", user["name"]);
        box.write("idUser", user["id"]);
        box.write("email", user["email"]);
        box.write("password", regPasswordController.text);
        box.write("isEmailVerified", user["is_email_verified"] ?? false);
        print("tokknne ${data['access_token']}");
        Get.offNamed(Routes.EMAIL_VERIFICATION);
      } else {
        if (result["message"] is Map && result["message"]["email"] != null) {
          emailError.value = result["message"]["email"][0];
          formKey.currentState?.validate();
        } else {
          Get.snackbar("Gagal", result["message"] ?? "Terjadi kesalahan");
        }
      }
      //   57308|asfqPicPZjzkm2SnwUoe4qh2YfNhT2KleeHC8qoo01ec55cb
      //   57308|asfqPicPZjzkm2SnwUoe4qh2YfNhT2KleeHC8qoo01ec55cb
    } catch (e) {
      // langsung munculin error email saat catch
      emailError.value = "email sudah ada sebelumnya.";
      formKey.currentState?.validate();
    } finally {
      isLoading.value = false;
    }
  }
}
