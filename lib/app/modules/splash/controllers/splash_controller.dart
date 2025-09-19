import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';

class SplashController extends GetxController {
  final box = GetStorage();
  final _restClient = RestClient(); // pastikan RestClient sudah didefinisikan

  // final LoginController loginController = Get.put(LoginController());
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void onInit() {
    super.onInit();
    checkLogin();
  }

  Future<void> checkLogin() async {
    // Delay supaya splash terlihat
    await Future.delayed(const Duration(milliseconds: 800));

    final email = box.read("email");
    final password = box.read("password");

    // Kalau email/password kosong atau null, langsung ke LOGIN
    if (email == null ||
        password == null ||
        email.isEmpty ||
        password.isEmpty) {
      print("masuk1 ${email} dan ${password}");
      Get.offAllNamed(Routes.LOGIN);
      return;
    }

    // Kalau ada, coba login otomatis
    final success = await login();
    if (!success) {
      print("masuk2 ${email} dan ${password}");
      Get.offAllNamed(Routes.LOGIN);
    }
  }

  Future<bool> login() async {
    final email = box.read("email");
    final password = box.read("password");

    final url = baseUrl + apiLogin;
    final payload = {"email": email, "password": password};
    final result = await _restClient.postData(url: url, payload: payload);

    if (result['error'] == false) {
      final data = result["data"];
      final user = data["user"];

      box.write("token", data["access_token"]);
      box.write("name", user["name"]);
      box.write("afiCode", user["kode_afiliasi"]);
      box.write("afiAgree", user["is_afiliasi_agree"]);
      box.write("idUser", user["id"]);
      box.write("email", user["email"]);
      box.write("password", password); // simpan password kembali
      box.write("photoProfile", user['profile_image_url']);

      if (user["is_email_verified"] == true) {
        if (user['user_status_id'] == 2) {
          Get.offNamed(Routes.LENGKAPI_BIODATA);
        } else {
          Get.offNamed(Routes.HOME, arguments: {'initialIndex': 0});
        }
      } else {
        Get.offNamed(Routes.EMAIL_VERIFICATION);
      }

      return true;
    } else {
      // Ambil pesan dari response
      print("asda ${result.toString()}");
      String errorMessage = result['message'] ?? "Email atau Password invalid.";
      Get.snackbar("Error", errorMessage);
      return false;
    }
  }
}
