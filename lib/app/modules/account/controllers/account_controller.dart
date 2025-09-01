import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:url_launcher/url_launcher.dart';

class AccountController extends GetxController {
  final _restClient = RestClient();
  final box = GetStorage();
  final count = 0.obs;
  RxString photoProfile = "".obs;
  RxString levelName = "".obs;
  RxString nameUser = "".obs;

  RxInt saldo = 0.obs;

  @override
  void onInit() {
    getUser();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;

  /// Fungsi logout aman
  Future<void> launchWhatsApp() async {
    final Uri phoneNumber = Uri.parse("https://wa.me/6281377277248");

    if (await canLaunchUrl(phoneNumber)) {
      await launchUrl(phoneNumber, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar("Error", "Tidak dapat membuka WhatsApp.");
    }
  }

  Future<void> launchHelp() async {
    final url = Uri.parse("https://panduan.idcpns.com/");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar("Error", "Tidak dapat membuka URL.");
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
}
