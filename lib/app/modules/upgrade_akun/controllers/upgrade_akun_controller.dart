import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:webview_flutter/webview_flutter.dart';

class UpgradeAkunController extends GetxController {
  //TODO: Implement UpgradeAkunController

  final count = 0.obs;
  final restClient = RestClient();
  late final WebViewController webController;

  RxMap<String, Color> categoryColor =
      <String, Color>{
        "CPNS": Colors.teal,
        "BUMN": Colors.blueAccent,
        "Kedinasan": Colors.orangeAccent,
        "PPPK": Colors.redAccent,
      }.obs;
  RxMap<String, dynamic> detailAkun = <String, dynamic>{}.obs;
  RxList<Map<String, dynamic>> listDurasi = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> listBonus = <Map<String, dynamic>>[].obs;
  RxString selectedBonusUuid = "".obs;
  RxString selectedDurasi = "".obs;
  RxBool loading = true.obs;

  @override
  void onInit() {
    super.onInit();
    webController =
        WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted);
    initUpgrade();
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

  Future<void> checkMaintenance() async {
    final response = await restClient.getData(
      url: baseUrl + apiCheckMaintenance,
    );
    if (response['is_maintenance']) {
      Get.offAllNamed("/maintenance");
    }
  }

  Future<void> initUpgrade() async {
    loading.value = true;
    await fetchDetailUpgrade();
    await fetchListBonus();
    await fetchListDurasi();

    // Escape dynamic HTML safely
    final htmlContent = '''
    <!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <script src="https://cdn.tailwindcss.com"></script>
    </head>
    <body class=" px-4">
      ${detailAkun['deskripsi_mobile'] ?? ''}
    </body>
    </html>
    ''';

    // Load into the existing controller
    await webController.loadHtmlString(htmlContent);

    loading.value = false;
  }

  Future<void> fetchDetailUpgrade() async {
    final response = await restClient.getData(
      url: baseUrl + apiDetailUpgradeAkun,
    );
    Map<String, dynamic> data = Map<String, dynamic>.from(response['data']);
    detailAkun.assignAll(data);
  }

  Future<void> fetchListDurasi() async {
    final response = await restClient.getData(url: baseUrl + apiDurasiUpgrade);
    List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      response['data'],
    );
    listDurasi.assignAll(data);
  }

  Future<void> fetchListBonus() async {
    final response = await restClient.getData(url: baseUrl + apiBonusUpgrade);
    List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      response['data'],
    );
    listBonus.assignAll(data);
  }

  void upgradeSekarang() {
    Get.toNamed(
      '/payment-upgrade-akun',
      arguments: {
        "bonus_uuid": selectedBonusUuid.value,
        "durasi_uuid": selectedDurasi.value,
      },
    );
  }
}
