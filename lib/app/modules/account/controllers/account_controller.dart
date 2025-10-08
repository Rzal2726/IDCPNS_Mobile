import 'dart:ffi';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:idcpns_mobile/app/Components/widgets/notifCostume.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountController extends GetxController {
  final _restClient = RestClient();
  final box = GetStorage();
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  RxString photoProfile = "".obs;
  RxString levelName = "".obs;
  RxString nameUser = "".obs;
  RxBool isLoggingOut = false.obs;
  RxInt saldo = 0.obs;

  @override
  void onInit() {
    refresh();
    super.onInit();
    checkMaintenance();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> refresh() async {
    await getUser();
  }

  /// Fungsi logout aman
  Future<void> logoutAkun() async {
    isLoggingOut.value = true;
    try {
      await box.erase();

      // Coba logout Google tanpa peduli user login pake apa
      try {
        await _googleSignIn.disconnect();
        await _googleSignIn.signOut();
        print('Google logout berhasil / atau tidak ada session Google.');
      } catch (e) {
        print('Tidak ada akun Google yang sedang login atau sudah logout: $e');
      }

      Get.offAllNamed(Routes.LOGIN);
    } catch (error) {
      print('Error saat logout: $error');
    }
    isLoggingOut.value = false;
  }

  /// Fungsi logout aman
  Future<void> launchWhatsApp() async {
    final Uri phoneNumber = Uri.parse("https://wa.me/6281377277248");

    if (await canLaunchUrl(phoneNumber)) {
      await launchUrl(phoneNumber, mode: LaunchMode.externalApplication);
    } else {
      notifHelper.show("Tidak dapat membuka WhatsApp.", type: 0);
    }
  }

  Future<void> launchHelp() async {
    final url = Uri.parse("https://panduan.idcpns.com/");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      notifHelper.show("Tidak dapat membuka URL.", type: 0);
    }
  }

  Future<void> getUser() async {
    try {
      final url = await baseUrl + apiGetUser;

      final result = await _restClient.getData(url: url);
      print("emailnnyaa ${result.toString()}");
      if (result["status"] == "success") {
        levelName.value = result['data']['level_name'];
        nameUser.value = result['data']['name'];
        photoProfile.value = result['data']['profile_image_url'];
        saldo.value = result['data']['saldo'];
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }

  Future<void> checkMaintenance() async {
    final response = await _restClient.getData(
      url: baseUrl + apiCheckMaintenance,
    );
    if (response['is_maintenance']) {
      Get.offAllNamed("/maintenance");
    }
  }
}
