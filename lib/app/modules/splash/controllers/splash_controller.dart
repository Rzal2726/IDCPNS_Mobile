import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/modules/login/controllers/login_controller.dart';
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

    try {
      final result = await _restClient.postData(url: url, payload: payload);
      final data = result["data"];
      final user = data["user"];

      box.write("token", data["access_token"]);
      box.write("name", user["name"]);
      box.write("afiCode", user["kode_afiliasi"]);
      box.write("idUser", user["id"]);
      box.write("email", user["email"]);
      box.write("password", password); // simpan password kembali
      box.write("photoProfile", user['profile_image_url']);
      print("masuk3 ${email} dan ${password}");
      Get.toNamed(Routes.HOME, arguments: {'initialIndex': 0});
      return true;
    } catch (e) {
      Get.snackbar("Error", "Email atau Password invalid.");
      debugPrint("Unexpected error: $e");
      return false;
    }
  }
}
