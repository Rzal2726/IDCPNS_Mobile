import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardController extends GetxController {
  final _restClient = RestClient();
  RxList kategoriData = [].obs;
  RxMap recomenData = {}.obs;
  RxList bannerData = [].obs;
  RxList bimbelRemainder = [].obs;
  RxInt menuCategoryId = 0.obs;
  RxInt bimbelParentId = 0.obs;
  RxInt tryoutFormasiId = 0.obs;
  RxInt upgradeId = 0.obs;

  final count = 0.obs;
  @override
  void onInit() {
    getUser();
    getBanner();
    getKategori();
    getRecomendation();
    getBimbelRemainder();
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

  Future<void> getKategori() async {
    try {
      final url = await baseUrl + apiGetKategori;

      final result = await _restClient.getData(url: url);
      if (result["status"] == "success") {
        var listData = result['data'];
        kategoriData.value = listData;
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }

  Future<void> getBanner() async {
    try {
      final url = await baseUrl + apiGetBannerHighlight;

      final result = await _restClient.getData(url: url);
      if (result["status"] == "success") {
        var data = result['data'];
        bannerData.value = data;
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }

  Future<void> getUser() async {
    try {
      final url = await baseUrl + apiGetUser;

      final result = await _restClient.getData(url: url);
      if (result["status"] == "success") {
        var data = result['data'];
        menuCategoryId.value = data['menu_category_id'];
        print("saa ${data['menu_category_id']}");
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }

  Future<void> getRecomendation() async {
    try {
      final url = await baseUrl + apiGetRekomendasi;

      final result = await _restClient.getData(url: url);
      if (result["status"] == "success") {
        var data = result['data'];
        recomenData.value = data;
        print("asdad ${data}");
      }
    } catch (e) {
      print("Error polling email verification: $e");
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

  Future<void> launchWhatsApp() async {
    final Uri phoneNumber = Uri.parse("https://wa.me/6281377277248");

    if (await canLaunchUrl(phoneNumber)) {
      await launchUrl(phoneNumber, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar("Error", "Tidak dapat membuka WhatsApp.");
    }
  }

  Future<void> getBimbelRemainder() async {
    try {
      final url = await baseUrl + apiBimbelReminder;

      final result = await _restClient.getData(url: url);
      if (result["status"] == "success") {
        var data = result['data'];
        bimbelRemainder.value = data;
      }
    } catch (e) {}
  }
}
