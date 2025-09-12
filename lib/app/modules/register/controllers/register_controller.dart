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
    final name = nameController.text.trim();
    final email = regEmailController.text.trim();
    final password = regPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    // Validasi nama
    if (name.isEmpty) {
      Get.snackbar(
        "Peringatan",
        "Nama tidak boleh kosong!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        icon: Icon(Icons.warning, color: Colors.white),
      );
      return;
    }

    // Validasi email
    if (email.isEmpty) {
      Get.snackbar(
        "Peringatan",
        "Email tidak boleh kosong!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        icon: Icon(Icons.warning, color: Colors.white),
      );
      return;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      Get.snackbar(
        "Peringatan",
        "Format email tidak valid!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        icon: Icon(Icons.warning, color: Colors.white),
      );
      return;
    }

    // Validasi password
    if (password.isEmpty) {
      Get.snackbar(
        "Peringatan",
        "Password tidak boleh kosong!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        icon: Icon(Icons.warning, color: Colors.white),
      );
      return;
    }

    // Konfirmasi password
    if (password != confirmPassword) {
      Get.snackbar(
        "Peringatan",
        "Password dan konfirmasi tidak cocok!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        icon: Icon(Icons.warning, color: Colors.white),
      );
      return;
    }

    // Syarat & Ketentuan
    if (!isAgreed.value) {
      Get.snackbar(
        "Peringatan",
        "Anda harus menyetujui syarat & ketentuan",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
        icon: Icon(Icons.warning, color: Colors.white),
      );
      return;
    }

    isLoading.value = true;

    try {
      final url = baseUrl + apiRegister;
      final payload = {
        "name": name,
        "email": email,
        "password": password,
        "password_confirmation": confirmPassword,
        "user_afiliator": affiliatorController.text ?? "",
      };

      final result = await _restClient.postData(url: url, payload: payload);

      if (result["status"] == "success") {
        final data = result["data"];
        final user = data["user"];

        final box = GetStorage();
        box.write("token", data["access_token"]);
        box.write("name", user["name"]);
        box.write("afiCode", user["kode_afiliasi"]);
        box.write("idUser", user["id"]);
        box.write("email", user["email"]);
        box.write("password", password);
        box.write("isEmailVerified", user["is_email_verified"] ?? false);

        Get.offNamed(Routes.EMAIL_VERIFICATION);
      } else {
        Get.snackbar(
          "Gagal",
          result["message"]['email'][0] ?? "Terjadi kesalahan",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          icon: Icon(Icons.warning, color: Colors.white),
        );
      }
    } catch (e) {
      print("xxx2 ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }
}
