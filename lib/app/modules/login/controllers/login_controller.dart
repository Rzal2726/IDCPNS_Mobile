import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class LoginController extends GetxController {
  final _restClient = RestClient();
  final box = GetStorage();

  // Controllers untuk TextField
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // States
  final isLoading = false.obs;
  final isEmailVerified = false.obs;

  // ✅ Tambahkan ini untuk toggle password
  final isPasswordVisible = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Peringatan", "Email dan password harus diisi!");
      return;
    }

    final url = baseUrl + apiLogin;
    final payload = {"email": email, "password": password};

    isLoading.value = true;
    try {
      final result = await _restClient.postData(url: url, payload: payload);

      // Ambil token aman (menyesuaikan struktur API)
      // final token = result["token"] ?? result["data"]?["token"];

      // Simpan sesi
      // box.write("token", token);
      // box.write("email", email);
      // box.write("password", password);
      // box.write("isLogin", true);
    } catch (e) {
      Get.snackbar("Error", "Email atau Password invalid.");
      debugPrint("Unexpected error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
