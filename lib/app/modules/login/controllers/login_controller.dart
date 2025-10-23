import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idcpns_mobile/app/Components/widgets/notifCostume.dart';
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
  final isLoading = false.obs;
  final isEmailVerified = false.obs;
  GoogleSignInAccount? currentUser;

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final isPasswordVisible = false.obs;
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Validasi kosong
    if (email.isEmpty) {
      notifHelper.show("Email tidak boleh kosong!", type: 0);
      return;
    }

    if (password.isEmpty) {
      notifHelper.show("Kata sandi tidak boleh kosong!", type: 0);
      return;
    }

    // Validasi format email
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      notifHelper.show("Format email tidak valid!", type: 0);
      return;
    }

    final url = baseUrl + apiLogin;
    final payload = {"email": email, "password": password};
    isLoading.value = true;

    final result = await _restClient.postData(url: url, payload: payload);

    if (result['error'] == false) {
      final user = result['data']["user"];

      box.write("token", result['data']["access_token"]);
      box.write("levelName", user["level_name"]);
      box.write("name", user["name"]);
      box.write("userAfi", user["user_afiliator"]);
      box.write("afiCode", user["kode_afiliasi"]);
      box.write("afiAgree", user["is_afiliasi_agree"]);
      box.write("idUser", user["id"]);
      box.write("email", user["email"]);
      box.write("password", password);
      box.write("photoProfile", user['profile_image_url']);
      box.write("isEmailVerified", user["is_email_verified"] ?? false);
      final ppnConfig = (result["data"]["sysconf"] as List).firstWhere(
        (item) => item["sysconf"] == "PPN",
        orElse: () => {"valueconf": null},
      );

      if (ppnConfig["valueconf"] != null) {
        box.write("ppn", ppnConfig["valueconf"]);
        print("PPN disimpan: ${ppnConfig["valueconf"]}");
      }
      emailController.clear();
      passwordController.clear();

      // notifHelper.show("Login berhasil!", type: 1);

      if (user["is_email_verified"] == true) {
        if (user['user_status_id'] == 2) {
          Get.toNamed(Routes.LENGKAPI_BIODATA);
        } else {
          Get.toNamed(Routes.HOME, arguments: {'initialIndex': 0});
        }
      } else {
        Get.toNamed(Routes.EMAIL_VERIFICATION);
      }
    } else {
      String errorMessage =
          result['message'] ?? "Email atau kata sandi invalid.";

      if (result['messages'] != null && result['messages'] is Map) {
        final messages = result['messages'] as Map;

        errorMessage = messages.values.expand((e) => e).join("\n");
      }

      notifHelper.show(errorMessage, type: 0);
    }

    isLoading.value = false;
  }

  Future<void> handleSignIn() async {
    currentUser = await _googleSignIn.signIn();
    try {
      if (currentUser != null) {
        box.write('name', currentUser!.displayName);
        box.write('email', currentUser!.email);
        box.write('id', currentUser!.id);
        box.write('photo', currentUser!.photoUrl);
        loginSocmed(currentUser: currentUser!, provider: 1);
      } else {
        handleSignOut();
        Get.offAllNamed(Routes.LOGIN);
      }
    } catch (error) {
      notifHelper.show("Login Google gagal: $error", type: 0);
    }
  }

  Future<void> loginSocmed({
    required GoogleSignInAccount currentUser,
    required int provider,
  }) async {
    final url = baseUrl + apiLogin;
    final payload = {
      "username": currentUser.displayName,
      "email": currentUser.email,
      "password": currentUser.id,
      "password_confirmation": currentUser.id,
      "foto": currentUser.photoUrl,
      "no_hp": "",
      "type": "google",
    };

    isLoading.value = true;
    final result = await _restClient.postData(url: url, payload: payload);

    if (result["error"] == false) {
      final user = result['data']["user"];

      box.write("token", result['data']["access_token"]);
      box.write("levelName", user["level_name"]);
      box.write("name", user["name"]);
      box.write("userAfi", user["user_afiliator"]);
      box.write("afiCode", user["kode_afiliasi"]);
      box.write("afiAgree", user["is_afiliasi_agree"]);
      box.write("idUser", user["id"]);
      box.write("email", user["email"]);
      box.write("photoProfile", user['profile_image_url']);
      box.write("isEmailVerified", user["is_email_verified"] ?? false);
      final ppnConfig = (result["data"]["sysconf"] as List).firstWhere(
        (item) => item["sysconf"] == "PPN",
        orElse: () => {"valueconf": null},
      );

      if (ppnConfig["valueconf"] != null) {
        box.write("ppn", ppnConfig["valueconf"]);
        print("PPN disimpan: ${ppnConfig["valueconf"]}");
      }
      emailController.clear();
      passwordController.clear();
      // notifHelper.show("Login berhasil!", type: 1);

      if (user["is_email_verified"] == true) {
        if (user['user_status_id'] == 2) {
          Get.toNamed(Routes.LENGKAPI_BIODATA);
        } else {
          Get.toNamed(Routes.HOME, arguments: {'initialIndex': 0});
        }
      } else {
        Get.toNamed(Routes.EMAIL_VERIFICATION);
      }
    } else {
      final message = result["message"] ?? "Login sosial media gagal.";
      notifHelper.show(message, type: 0);
      _googleSignIn.disconnect();
      _googleSignIn.signOut();
    }
    isLoading.value = false;
  }

  Future<void> handleSignOut() async {
    isLoading(true);
    _googleSignIn.disconnect();
    isLoading(false);
  }

  @override
  void onClose() {
    emailController.clear();
    passwordController.clear();
    isLoading.value = false;
    isLoadingSigninGoogle.value = false;
    isPasswordVisible.value = false;
    isEmailVerified.value = false;
    currentUser = null;
    super.onClose();
  }
}
