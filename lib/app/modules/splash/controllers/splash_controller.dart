import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idcpns_mobile/app/modules/login/controllers/login_controller.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';

class SplashController extends GetxController {
  final box = GetStorage();
  final LoginController loginController = Get.put(LoginController());

  @override
  void onInit() {
    super.onInit();
    // _checkLogin();
  }

  //
  // Future<void> _checkLogin() async {
  //   // Delay supaya splash terlihat
  //   await Future.delayed(const Duration(milliseconds: 800));
  //
  //   final email = box.read("email");
  //   final password = box.read("password");
  //
  //   if (email != null && password != null) {
  //     try {
  //       final success = await loginController.login(
  //         email: email,
  //         password: password,
  //       );
  //       if (success) {
  //         Get.offAllNamed(Routes.HOME);
  //       } else {
  //         Get.offAllNamed(Routes.LOGIN);
  //       }
  //     } catch (e) {
  //       Get.offAllNamed(Routes.LOGIN);
  //     }
  //   } else {
  //     Get.offAllNamed(Routes.LOGIN);
  //   }
  // }
}
