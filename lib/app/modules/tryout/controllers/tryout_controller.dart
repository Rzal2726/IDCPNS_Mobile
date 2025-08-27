import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/data/rest_client_provider.dart';

class TryoutController extends GetxController {
  //TODO: Implement TryoutController

  RxList<String> options = ["Semua", "CPNS", "BUMN", "Kedinasan", "PPPK"].obs;
  RxBool isLoading = false.obs;
  RxList<Map<String, dynamic>> eventTryout =
      <Map<String, dynamic>>[
        {
          "uuid": "abc123",
          "judul": "Tryout SKD CPNS 2024 Batch 3",
          "startDate": "22 Agustus",
          "endDate": "28 Agustus",
          "periode": "Pengerjaan",
        },
        {
          "uuid": "abc1234",
          "judul": "Tryout SKD CPNS 2024 Batch 4",
          "startDate": "1 Sept",
          "endDate": "7 Sept",
          "periode": "Pengerjaan",
        },
      ].obs;
  RxList<Map<String, dynamic>> paketTryout =
      <Map<String, dynamic>>[
        {
          "uuid": "abc123",
          "image":
              "https://cms.idcpns.com/storage/upload/tryout-formasi/2023-09/1694683777-thumb_cpns.png",
          "title": "Paket Tryout SKD CPNS",
          "harga-full": "Rp.149.000",
          "harga-diskon": "Rp.99.000",
          "kategori": "CPNS",
        },
        {
          "uuid": "abc1234",
          "image":
              "https://cms.idcpns.com/storage/upload/tryout-formasi/2023-09/1694683777-thumb_cpns.png",
          "title": "Paket Tryout SKD CPNS",
          "harga-full": "Rp.149.000",
          "harga-diskon": "Rp.99.000",
          "kategori": "CPNS",
        },
      ].obs;
  RxString selectedPaketKategori = "Semua".obs;
  RxString selectedEventKategori = "Semua".obs;
  RxString selectedUuid = "".obs;
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    fetchEventsTryout();
    fetchPaketTryout();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void fetchEventsTryout() async {
    final client = Get.find<RestClientProvider>();
    final response = await client.get(
      headers: {"Authorization": ""},
      '/tryout/event',
    );

    if (response.statusCode == 200) {
      print('Data: ${response.body}');
    } else {
      print('Error: ${response.statusText}');
    }
  }

  void fetchPaketTryout() async {
    final client = Get.find<RestClientProvider>();
    final response = await client.get(
      headers: {"Authorization": ""},
      '/tryout/formasi',
    );

    if (response.statusCode == 200) {
      print('Data: ${response.body}');
    } else {
      print('Error: ${response.statusText}');
    }
  }

  void showDetailTryout(BuildContext context) {
    Navigator.pushNamed(context, '/detail-tryout');
  }

  void setSelectedUuid(String uuid) {
    selectedUuid.value = uuid;
  }
}
