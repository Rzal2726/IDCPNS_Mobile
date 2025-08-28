import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/data/rest_client_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class TryoutController extends GetxController {
  //TODO: Implement TryoutController

  RxList<String> options = ["Semua", "CPNS", "BUMN", "Kedinasan", "PPPK"].obs;
  RxMap<String, dynamic> optionsId =
      <String, dynamic>{
        "CPNS": 1,
        "BUMN": 2,
        "Kedinasan": 3,
        "PPPK": 4,
        "Semua": "",
      }.obs;
  RxMap<String, Color> categoryColor =
      <String, Color>{
        "CPNS": Colors.teal,
        "BUMN": Colors.blueAccent,
        "Kedinasan": Colors.orangeAccent,
        "PPPK": Colors.redAccent,
      }.obs;
  RxBool isLoading = false.obs;
  RxMap<String, bool> loading =
      <String, bool>{"event": false, "paket": false}.obs;
  RxInt perPage = 5.obs;
  RxInt totalPaket = 1.obs;
  RxString prevPageUrl = "".obs;
  RxString nextPageUrl = "".obs;
  RxString lastPageUrl = "".obs;
  RxString firstPageUrl = "".obs;
  RxInt currentPage = 1.obs;
  RxInt totalPage = 1.obs;
  RxList<Map<String, dynamic>> eventBaseTryout = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> eventTryout = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> paketTryout = <Map<String, dynamic>>[].obs;
  RxString selectedPaketKategori = "Semua".obs;
  RxString selectedEventKategori = "Semua".obs;
  RxString selectedUuid = "".obs;
  final count = 0.obs;
  @override
  void onInit() async {
    super.onInit();
    fetchEventsTryout();
    fetchPaketTryout();
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
    loading['event'] = true;

    final client = Get.find<RestClientProvider>();
    final response = await client.get(
      headers: {
        "Authorization":
            "Bearer 18|V9PnP29RzhtFCKwwbb1NLFUliZ9YLK9PiFDCa5Ir9f6c4eb3",
      },
      '/tryout/event',
    );

    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> paket = List<Map<String, dynamic>>.from(
        response.body['data'],
      );
      eventBaseTryout.assignAll(paket);
      print('Data: ${response.body['data']}');
      showEventTryout();
    } else {
      print('Error: ${response.statusText}');
    }
    loading['event'] = false;
  }

  void showEventTryout({String name = "", String category = "Semua"}) {
    eventTryout.assignAll(
      eventBaseTryout.where((f) {
        final matchName =
            name.isEmpty ||
            (f['name']?.toString().toUpperCase().contains(name.toUpperCase()) ??
                false);

        final matchCategory = f['menu_category_id'] == optionsId[category];

        if (category == "Semua") {
          return matchName;
        } else {
          return matchName && matchCategory;
        }
      }),
    );
    print("Search: ${name}");
    print("Kategori: ${category}");
  }

  void fetchPaketTryout({
    String menuCategory = "",
    String subMenuCategory = "",
    String search = "",
    int page = 1,
  }) async {
    try {
      isLoading.value = true;
      loading['paket'] = true;
      final client = Get.find<RestClientProvider>();
      final response = await client.post(
        '/tryout/formasi?page=${page.toString()}',
        {
          "perpage": perPage.value,
          "menu_category_id": menuCategory,
          "submenu_category_id": subMenuCategory,
          "search": search,
        },
        headers: {
          "Authorization":
              "Bearer 18|V9PnP29RzhtFCKwwbb1NLFUliZ9YLK9PiFDCa5Ir9f6c4eb3", // ambil dari storage
        },
      );

      if (response.statusCode == 200 && response.body != null) {
        final List<Map<String, dynamic>> paket =
            List<Map<String, dynamic>>.from(response.body['data']['data']);
        paketTryout.assignAll(paket);
        totalPaket.value = response.body['data']['total'];
        totalPage.value = (totalPaket.value / perPage.value).toInt();
        currentPage.value = response.body['data']['current_page'];
      } else {
        Get.snackbar("Error", response.statusText ?? "Gagal ambil data");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
      loading['paket'] = false;
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

  String formatTanggalRange(String range) {
    // Pisah tanggal start & end
    final parts = range.split(" - ");
    final start = DateTime.parse(parts[0]);
    final end = DateTime.parse(parts[1]);

    // Format dengan nama bulan Indonesia
    final formatter = DateFormat("d MMMM");
    final formatterWithYear = DateFormat("d MMMM yyyy");

    // Kalau tahun sama, tampilkan di akhir
    if (start.year == end.year) {
      return "${formatter.format(start)} - ${formatterWithYear.format(end)}";
    } else {
      return "${formatterWithYear.format(start)} - ${formatterWithYear.format(end)}";
    }
  }

  void showDetailTryout(BuildContext context) {
    Get.toNamed('/detail-tryout');
  }

  void setSelectedUuid(String uuid) {
    selectedUuid.value = uuid;
  }
}
