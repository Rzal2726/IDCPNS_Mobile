import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginController extends GetxController {
  final _restClient = RestClient();
  final box = GetStorage();

  // Controllers untuk TextField
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  RxBool isLoadingSigninGoogle = false.obs;
  // States
  final isLoading = false.obs;
  final isEmailVerified = false.obs;
  GoogleSignInAccount? currentUser;
  // ✅ Tambahkan ini untuk toggle password
  final isPasswordVisible = false.obs;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: <String>['email']);

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Validasi kosong
    if (email.isEmpty) {
      Get.snackbar(
        "Peringatan",
        "Email tidak boleh kosong!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    if (password.isEmpty) {
      Get.snackbar(
        "Peringatan",
        "Password tidak boleh kosong!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    // Validasi format email
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      Get.snackbar(
        "Peringatan",
        "Format email tidak valid!",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    final url = baseUrl + apiLogin;
    final payload = {"email": email, "password": password};
    isLoading.value = true;
    print("xxx2 $payload");
    final result = await _restClient.postData(url: url, payload: payload);
    if (result['error'] == false) {
      final user = result['data']["user"];

      box.write("token", result["access_token"]);
      box.write("name", user["name"]);
      box.write("afiCode", user["kode_afiliasi"]);
      box.write("idUser", user["id"]);
      box.write("email", user["email"]);
      box.write("password", password);
      box.write("photoProfile", user['profile_image_url']);
      box.write("isEmailVerified", user["is_email_verified"] ?? false);

      // Reset TextField
      emailController.clear();
      passwordController.clear();

      if (user["is_email_verified"] == true) {
        if (user['user_status_id'] == 2) {
          Get.offNamed(Routes.LENGKAPI_BIODATA);
        } else {
          Get.offNamed(Routes.HOME, arguments: {'initialIndex': 0});
        }
      } else {
        Get.offNamed(Routes.EMAIL_VERIFICATION);
      }
    } else {
      Get.snackbar(
        "Error",
        "Email atau Password invalid.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }

    isLoading.value = false;
  }

  Future<void> handleSignIn() async {
    try {
      currentUser = await _googleSignIn.signIn();
      print("xxxc ${currentUser!.email.toString()}");
      if (currentUser != null) {
        box.write('name', currentUser!.displayName);

        loginSocmed(email: currentUser!.email, provider: 1);
      } else {
        print("xxx keluar");
        handleSignOut();
        Get.offAllNamed(Routes.LOGIN);
      }
    } catch (error) {
      print("xxx gagal ${error}");
    }
  }

  Future<void> loginSocmed({
    required String email,
    required int provider,
  }) async {
    final url = baseUrl + apiLogin;
    final payload = {"email": email};
    print("xxx ${payload.toString()}");

    isLoading.value = true;
    try {
      final result = await _restClient.postData(url: url, payload: payload);
      final data = result["data"];
      final user = data["user"];

      // Simpan data user di box, mirip login biasa
      box.write("token", data["access_token"]);
      box.write("name", user["name"]);
      box.write("afiCode", user["kode_afiliasi"] ?? "");
      box.write("idUser", user["id"]);
      box.write("email", user["email"]);
      box.write("photoProfile", user['profile_image_url'] ?? "");

      print("ppss ${user['profile_image_url'].toString()}");

      // Reset TextField (opsional, kalau pakai controller input)
      // emailController.clear();
      // passwordController.clear();

      // Navigasi ke HOME
      Get.offNamed(Routes.HOME, arguments: {'initialIndex': 0});
    } catch (e) {
      print("xxx error");
      Get.snackbar("Error", "Login sosial media gagal.");
      debugPrint("Unexpected error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> handleSignOut() async {
    isLoading(true);
    _googleSignIn.disconnect();
    isLoading(false);
  }

  @override
  void onClose() {
    super.onClose();
  }
}
