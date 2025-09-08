import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';

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
      final data = result["data"];
      final user = data["user"];
      box.write("token", data["access_token"]);
      box.write("name", user["name"]);
      box.write("idUser", user["id"]);
      box.write("email", user["email"]);
      box.write("password", password); // simpan password kembali
      box.write("photoProfile", user['profile_image_url']);
      print("ppss ${user['profile_image_url'].toString()}");
      // Reset TextField saat login berhasil
      emailController.clear();
      passwordController.clear();

      Get.offNamed(Routes.HOME, arguments: {'initialIndex': 0});
    } catch (e) {
      Get.snackbar("Error", "Email atau Password invalid.");
      debugPrint("Unexpected error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    super.onClose();
  }
}
