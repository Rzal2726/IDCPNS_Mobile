import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/notifCostume.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';

class TryoutController extends GetxController {
  //TODO: Implement TryoutController
  final restClient = RestClient();

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
  RxList<Map<String, dynamic>> paketTryoutRecommendation =
      <Map<String, dynamic>>[].obs;
  RxString selectedPaketKategori = "Semua".obs;
  RxString selectedEventKategori = "Semua".obs;
  RxString selectedUuid = "".obs;
  final count = 0.obs;
  @override
  void onInit() async {
    super.onInit();
    initTryout();
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

  Future<void> initTryout() async {
    await fetchEventsTryout();
    await fetchPaketTryout();
    getRecommendation();
  }

  // ===========================
  void goToPage(int page) {
    if (page >= 1 && page <= totalPage.value) {
      currentPage.value = page;
      fetchPaketTryout(
        page: currentPage.value,
        menuCategory: optionsId[selectedPaketKategori.value].toString(),
      );
      // panggil API fetch data di sini jika perlu
    }
  }

  void nextPage() {
    if (currentPage.value < totalPage.value) {
      currentPage.value++;
      fetchPaketTryout(
        page: currentPage.value,
        menuCategory: optionsId[selectedPaketKategori.value].toString(),
      );
      // panggil API fetch data di sini
    }
  }

  void prevPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      fetchPaketTryout(
        page: currentPage.value,
        menuCategory: optionsId[selectedPaketKategori.value].toString(),
      );
      // panggil API fetch data di sini
    }
  }

  //======================================
  Future<void> fetchEventsTryout() async {
    loading['event'] = true;
    final response = await restClient.getData(url: baseUrl + apiGetTryoutEvent);

    final List<Map<String, dynamic>> paket = List<Map<String, dynamic>>.from(
      response['data'],
    );
    eventBaseTryout.assignAll(paket);
    print('Data: ${response['data']}');
    showEventTryout();
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

  Future<void> fetchPaketTryout({
    String menuCategory = "",
    String subMenuCategory = "",
    String search = "",
    int page = 1,
  }) async {
    try {
      isLoading.value = true;
      loading['paket'] = true;
      final payload = {
        "perpage": perPage.value,
        "menu_category_id": menuCategory,
        "submenu_category_id": subMenuCategory,
        "search": search,
      };

      final response = await restClient.postData(
        url: baseUrl + apiGetTryoutPaket + '?page=${page.toString()}',
        payload: payload,
      );
      print("xxx ${payload}");
      final List<Map<String, dynamic>> paket = List<Map<String, dynamic>>.from(
        response['data']['data'],
      );
      paketTryout.assignAll(paket);
      totalPaket.value = response['data']['total'];
      totalPage.value = (totalPaket.value / perPage.value).toInt();
      currentPage.value = response['data']['current_page'];
    } catch (e) {
      notifHelper.show("Terjadi Kesalahan", type: 0);
    } finally {
      isLoading.value = false;
      loading['paket'] = false;
    }
  }

  void getRecommendation() async {
    loading['paket'] = true;
    final payload = {};

    final response = await restClient.postData(
      url: baseUrl + apiGetTryoutPaket,
      payload: payload,
    );

    final List<Map<String, dynamic>> paket = List<Map<String, dynamic>>.from(
      response['data']['data'],
    );
    List<Map<String, dynamic>> paketRekomendasi =
        paket.where((data) => data['isfeatured'] == 1).toList();
    paketTryoutRecommendation.assignAll(paketRekomendasi);
    loading['paket'] = false;
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
