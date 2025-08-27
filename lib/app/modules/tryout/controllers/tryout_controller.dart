import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/data/rest_client_provider.dart';
import 'package:intl/intl.dart';

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
  RxList<Map<String, dynamic>> paketTryout = <Map<String, dynamic>>[].obs;
  RxString selectedPaketKategori = "Semua".obs;
  RxString selectedEventKategori = "Semua".obs;
  RxString selectedUuid = "".obs;
  final count = 0.obs;
  @override
  void onInit() async {
    super.onInit();
    fetchEventsTryout();
    fetchPaketTryout(perPage: "3");
    print(paketTryout);
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
      headers: {
        "Authorization":
            "Bearer 56759|KK0mqNkVsumxcvbvS48Ee3my8hvITEJi6YZuYmnqdf8b5cf3",
      },
      '/tryout/event',
    );

    if (response.statusCode == 200) {
      print('Data: ${response.body}');
    } else {
      print('Error: ${response.statusText}');
    }
  }

  void fetchPaketTryout({
    String perPage = "",
    String menuCategory = "",
    String subMenuCategory = "",
    String search = "",
  }) async {
    try {
      isLoading.value = true;

      final client = Get.find<RestClientProvider>();
      final response = await client.post(
        '/tryout/formasi',
        {
          "perpage": perPage,
          "menu_category_id": menuCategory,
          "submenu_category_id": subMenuCategory,
          "search": search,
        },
        headers: {
          "Authorization":
              "Bearer 56759|KK0mqNkVsumxcvbvS48Ee3my8hvITEJi6YZuYmnqdf8b5cf3", // ambil dari storage
        },
      );

      if (response.statusCode == 200 && response.body != null) {
        final List<Map<String, dynamic>> paket =
            List<Map<String, dynamic>>.from(response.body['data']['data']);
        paketTryout.assignAll(paket);
        print(paketTryout);
        // print("✅ Paket Tryout: ${paketTryout.length.toString()} items");
      } else {
        Get.snackbar("Error", response.statusText ?? "Gagal ambil data");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  String formatCurrency(dynamic number) {
    var customFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp.',
      decimalDigits: 0,
    );
    var formattedValue = customFormatter.format(int.parse(number));
    return formattedValue.toString();
  }

  void showDetailTryout(BuildContext context) {
    Get.toNamed('/detail-tryout');
  }

  void setSelectedUuid(String uuid) {
    selectedUuid.value = uuid;
  }
}
