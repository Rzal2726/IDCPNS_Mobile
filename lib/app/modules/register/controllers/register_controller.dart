import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:idcpns_mobile/app/Components/widgets/notifCostume.dart';
import '../../../routes/app_pages.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
// ✅ pastikan kamu import helper

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
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? currentUser;
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

  Future<void> handleSignIn() async {
    currentUser = await _googleSignIn.signIn();
    try {
      if (currentUser != null) {
        box.write('name', currentUser!.displayName);
        box.write('email', currentUser!.email);
        box.write('id', currentUser!.id);
        box.write('photo', currentUser!.photoUrl);
        registerSocmed(currentUser: currentUser!, provider: 1);
      } else {
        handleSignOut();
        // notifHelper.show("Login Google dibatalkan", type: 0);
      }
    } catch (error) {
      notifHelper.show("Login Google gagal", type: 0);
    }
  }

  Future<void> registerSocmed({
    required GoogleSignInAccount currentUser,
    required int provider,
  }) async {
    final url = baseUrl + apiRegister;
    final payload = {
      "name": currentUser.displayName,
      "email": currentUser.email,
      "password": currentUser.id,
      "password_confirmation": currentUser.id,
      "foto": currentUser.photoUrl,
      "no_hp": null,
      "type": "google",
    };

    isLoading.value = true;
    final result = await _restClient.postData(url: url, payload: payload);

    if (result['status'] == "success") {
      var data = result["data"];
      var user = data["user"];

      box.write("token", data["access_token"]);
      box.write("levelName", user["level_name"]);
      box.write("name", user["name"]);
      box.write("afiCode", user["kode_afiliasi"] ?? "");
      box.write("afiAgree", user["is_afiliasi_agree"]);
      box.write("idUser", user["id"]);
      box.write("email", user["email"]);
      box.write("photoProfile", user['profile_image_url'] ?? "");

      isLoading.value = false;
      notifHelper.show("Register berhasil", type: 1);
      Get.toNamed(Routes.LENGKAPI_BIODATA);
    } else {
      if (result['message'] != null) {
        var message = result['message'];
        if (message['email'] != null && message['email'].isNotEmpty) {
          notifHelper.show(message['email'][0], type: 0);
        } else {
          notifHelper.show("Register sosial media gagal", type: 0);
        }
      } else {
        notifHelper.show("Register sosial media gagal", type: 0);
      }
      isLoading.value = false;
    }

    _googleSignIn.disconnect();
    _googleSignIn.signOut();
  }

  Future<void> handleSignOut() async {
    isLoading(true);
    _googleSignIn.disconnect();
    isLoading(false);
  }

  Future<void> onRegister() async {
    final name = nameController.text.trim();
    final email = regEmailController.text.trim();
    final password = regPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    final kodeAfiliator = affiliatorController.text.trim();

    if (name.isEmpty) {
      notifHelper.show("Nama tidak boleh kosong!", type: 0);
      return;
    }

    if (email.isEmpty) {
      notifHelper.show("Email tidak boleh kosong!", type: 0);
      return;
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      notifHelper.show("Format email tidak valid!", type: 0);
      return;
    }

    if (password.isEmpty) {
      notifHelper.show("Password tidak boleh kosong!", type: 0);
      return;
    }

    if (password != confirmPassword) {
      notifHelper.show("Konfirmasi password tidak cocok!", type: 0);
      return;
    }
    if (kodeAfiliator != null && kodeAfiliator.isNotEmpty) {
      if (kodeAfiliator.length < 8) {
        notifHelper.show("Kode Afiliator minimal 8 karakter!", type: 0);
        return;
      }
      if (kodeAfiliator.length > 13) {
        notifHelper.show("Kode Afiliator maksimal 13 karakter!", type: 0);
        return;
      }
    }

    if (!isAgreed.value) {
      notifHelper.show("Anda harus menyetujui syarat & ketentuan", type: 0);
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
        "user_afiliator": affiliatorController.text,
      };

      final result = await _restClient.postData(url: url, payload: payload);

      if (result["status"] == "success") {
        final data = result["data"];
        final user = data["user"];

        box.write("token", data["access_token"]);
        box.write("levelName", user["level_name"]);
        box.write("name", user["name"]);
        box.write("afiCode", user["kode_afiliasi"]);
        box.write("afiAgree", user["is_afiliasi_agree"]);
        box.write("idUser", user["id"]);
        box.write("email", user["email"]);
        box.write("password", password);
        box.write("isEmailVerified", user["is_email_verified"] ?? false);

        // Reset form biar kosong lagi
        nameController.clear();
        regEmailController.clear();
        regPasswordController.clear();
        confirmPasswordController.clear();
        affiliatorController.clear();
        isAgreed.value = false;

        notifHelper.show(
          "Register berhasil, silakan verifikasi email",
          type: 1,
        );
        Get.toNamed(Routes.EMAIL_VERIFICATION);
      } else {
        final msg =
            (result["message"]?['email'] != null &&
                    (result["message"]?['email'] as List).isNotEmpty)
                ? result["message"]['email'][0]
                : (result["message"]?['password'] != null &&
                    (result["message"]?['password'] as List).isNotEmpty)
                ? result["message"]['password'][0]
                : (result["message"]?['user_afiliator'] != null &&
                    (result["message"]?['user_afiliator'] as List).isNotEmpty)
                ? result["message"]['user_afiliator'][0]
                : "Terjadi kesalahan";
        notifHelper.show(msg, type: 0);
      }
    } catch (e) {
      notifHelper.show("Terjadi kesalahan saat register", type: 0);
    } finally {
      isLoading.value = false;
    }
  }
}
