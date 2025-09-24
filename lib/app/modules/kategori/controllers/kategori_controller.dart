import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/notifCostume.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:intl/intl.dart';

class KategoriController extends GetxController {
  //TODO: Implement KategoriController

  final count = 0.obs;
  final restClient = RestClient();
  final paketTextController = TextEditingController();
  final bimbelTextController = TextEditingController();
  final eventTextController = TextEditingController();
  late String categoryId;
  RxMap<String, Color> categoryColor =
      <String, Color>{
        "CPNS": Colors.teal,
        "BUMN": Colors.blueAccent,
        "Kedinasan": Colors.orangeAccent,
        "PPPK": Colors.redAccent,
      }.obs;
  RxMap<String, Image> categoryImage =
      <String, Image>{
        "CPNS": Image.asset("assets/zona_cpns.png"),
        "BUMN": Image.asset("assets/zona_bumn.png"),
        "Kedinasan": Image.asset("assets/zona_sekdin.png"),
        "PPPK": Image.asset("assets/zona_pppk.png"),
      }.obs;
  RxMap<String, bool> loading = <String, bool>{}.obs;
  Color currentCategoryColor = Colors.teal;
  RxList<Map<String, dynamic>> eventBaseTryout = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> eventTryout = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> paketTryout = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> bimbelList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> categoryList = <Map<String, dynamic>>[].obs;
  RxMap<String, dynamic> categoryData = <String, dynamic>{}.obs;
  RxInt perPage = 5.obs;
  RxInt totalPaket = 1.obs;
  RxInt currentPage = 1.obs;
  RxInt totalPage = 1.obs;

  RxInt totalBimbel = 1.obs;
  RxInt currentBimbelPage = 1.obs;
  RxInt totalBimbelPage = 1.obs;
  RxString selectedUuid = "".obs;
  @override
  void onInit() {
    super.onInit();
    initKategori();
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

  Future<void> initKategori() async {
    categoryId = await Get.arguments;
    await getKategori();
    categoryData.assignAll(
      Map<String, dynamic>.from(
        categoryList.firstWhere((test) => test['id'] == int.parse(categoryId)),
      ),
    );
    currentCategoryColor = categoryColor[categoryData['menu']]!;

    await fetchEventsTryout();
    await fetchPaketTryout();
    await fetchBimbel();
    showEventTryout();
  }

  Future<void> fetchEventsTryout() async {
    loading['event'] = true;
    final response = await restClient.getData(url: baseUrl + apiGetTryoutEvent);

    final List<Map<String, dynamic>> paket = List<Map<String, dynamic>>.from(
      response['data'],
    );
    eventBaseTryout.assignAll(paket);

    loading['event'] = false;
  }

  void showEventTryout({String name = ""}) {
    eventTryout.assignAll(
      eventBaseTryout.where((f) {
        final matchName =
            name.isEmpty ||
            (f['name']?.toString().toUpperCase().contains(name.toUpperCase()) ??
                false);

        final matchCategory =
            f['menu_category_id'].toString() == categoryId.toString();

        return matchName && matchCategory;
      }),
    );
  }

  Future<void> fetchPaketTryout({
    String menuCategory = "",
    String subMenuCategory = "",
    String search = "",
    int page = 1,
  }) async {
    try {
      loading['paket'] = true;
      final payload = {
        "perpage": perPage.value,
        "menu_category_id": categoryId,
        "submenu_category_id": subMenuCategory,
        "search": search,
      };

      final response = await restClient.postData(
        url: baseUrl + apiGetTryoutPaket + '?page=${page.toString()}',
        payload: payload,
      );

      final List<Map<String, dynamic>> paket = List<Map<String, dynamic>>.from(
        response['data']['data'],
      );
      paketTryout.assignAll(paket);
      totalPaket.value = response['data']['total'];
      totalPage.value = (totalPaket.value / perPage.value).toInt();
      currentPage.value = response['data']['current_page'];
    } catch (e) {
      notifHelper.show("terjadi kesalahan", type: 0);
    } finally {
      loading['paket'] = false;
    }
  }

  Future<void> fetchBimbel({
    String menuCategory = "",
    String subMenuCategory = "",
    String search = "",
    int page = 1,
  }) async {
    try {
      loading['bimbel'] = true;
      final payload = {
        "perpage": perPage.value,
        "menu_category_id": categoryId,
        "submenu_category_id": subMenuCategory,
        "search": search,
      };

      final response = await restClient.postData(
        url: baseUrl + apiGetBimbel + '?page=${page.toString()}',
        payload: payload,
      );

      final List<Map<String, dynamic>> paket = List<Map<String, dynamic>>.from(
        response['data']['data'],
      );
      bimbelList.assignAll(paket);
      totalBimbel.value = response['data']['total'];
      totalBimbelPage.value = (totalBimbel.value / perPage.value).toInt();
      currentBimbelPage.value = response['data']['current_page'];
    } catch (e) {
      notifHelper.show("terjadi kesalahan", type: 0);
    } finally {
      loading['bimbel'] = false;
    }
  }

  Future<void> getKategori() async {
    try {
      final url = await baseUrl + apiGetKategori;

      final result = await restClient.getData(url: url);
      if (result["status"] == "success") {
        List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
          result['data'],
        );
        categoryList.assignAll(data);
      }
    } catch (e) {
      print("Error polling email verification: $e");
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

  Future<void> checkMaintenance() async {
    final response = await restClient.getData(
      url: baseUrl + apiCheckMaintenance,
    );
    if (response['is_maintenance']) {
      Get.offAllNamed("/maintenance");
    }
  }
}
