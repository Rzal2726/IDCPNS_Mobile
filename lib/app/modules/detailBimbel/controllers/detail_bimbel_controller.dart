import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class DetailBimbelController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final _restClient = RestClient();
  final tabs = ['Detail', 'Jadwal', 'FAQ'];
  var currentPage = 1.obs;
  var totalPage = 1.obs;
  final int pageSize = 5;
  RxMap datalBimbelData = {}.obs;
  RxMap datalCheckList = {}.obs;
  RxString wishlistUuid = "".obs;
  RxString selectedPaket = "".obs;
  late TabController tabController;
  var idBimbel = Get.arguments;
  RxInt currentIndex = 0.obs;
  List<JadwalFilter> jadwalFilter = [];
  RxBool isCheklist = false.obs;
  RxBool isLoadingButton = false.obs;

  @override
  void onInit() async {
    await initializeDateFormatting('id_ID', null);
    super.onInit();
    getCheckWhislist();
    getDetailBimbel(id: idBimbel);

    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  List<Map<String, dynamic>> getPaginatedData() {
    final grouped = groupJadwalByTanggal(jadwalFilter);
    final dataJadwal = grouped.values.toList();

    totalPage.value = (dataJadwal.length / pageSize).ceil();
    if (totalPage.value == 0) totalPage.value = 1;

    int startIndex = (currentPage.value - 1) * pageSize;
    int endIndex = startIndex + pageSize;
    if (endIndex > dataJadwal.length) endIndex = dataJadwal.length;

    return dataJadwal.sublist(startIndex, endIndex);
  }

  Future<void> getDetailBimbel({required String id}) async {
    try {
      final url = baseUrl + apiGetDetailBimbel + "/" + id;

      final result = await _restClient.getData(url: url);
      print("asdas ${result.toString()}");

      if (result["status"] == "success") {
        var data = result['data'];
        parseJadwalEvent(data);
        print("xx ${jadwalFilter.length}");
        datalBimbelData.value = data;

        // ambil id pertama dari list result['data']['bimbel']
        if (data['bimbel'] is List && (data['bimbel'] as List).isNotEmpty) {
          // filter data sesuai kondisi
          final filtered =
              (data['bimbel'] as List).where((item) {
                return (item['is_showing'] ?? false) &&
                    (item['is_purchase'] == false);
              }).toList();

          if (filtered.isNotEmpty) {
            // ambil data terakhir dari list awal yang sudah di-filter
            final lastItem = filtered.first;

            // ambil index pertama dari list awal setelah filter → ini sebenarnya lastItem
            selectedPaket.value = lastItem['uuid'];
            print("xxx3 ${selectedPaket.toString()}");
          }
        } else {
          selectedPaket.value = ""; // fallback, misal 0 berarti belum dipilih
        }
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }

  Future<void> getCheckWhislist() async {
    try {
      final url = baseUrl + apiCheckWishList + "/" + idBimbel;
      final result = await _restClient.getData(url: url);

      if (result["status"] == "success") {
        var data = result['data'];
        if (data != null && data.isNotEmpty) {
          datalCheckList.value = data;
          isCheklist.value = true; // ✅ set true kalau data ada
          wishlistUuid.value = data['uuid'] ?? "";
        } else {
          datalCheckList.value = {}; // kosongin kalau null/empty
          isCheklist.value = false; // ✅ set false kalau data kosong
          wishlistUuid.value = "";
        }
      }
    } catch (e) {
      print("Error polling check wishlist: $e");
      isCheklist.value = false; // ✅ fallback ke false kalau error
    }
  }

  Future<void> getAddWhislist() async {
    isLoadingButton.value = true;
    try {
      final url = await baseUrl + apiAddWhistlist;
      var payload = {
        "bimbel_parent_id": datalBimbelData['id'],
        "menu_category_id": datalBimbelData['menu_category_id'],
      };
      print("sad ${payload.toString()}");
      final result = await _restClient.postData(url: url, payload: payload);
      if (result["status"] == "success") {
        isCheklist.value = true;
        getCheckWhislist();
      }
    } catch (e) {
      print("Error: $e");
    }
    isLoadingButton.value = false;
  }

  Future<void> getDeleteWhisList() async {
    isLoadingButton.value = true;
    try {
      final url = await baseUrl + apiDeleteWhislist;
      var payload = {"uuid": datalCheckList['uuid']};
      final result = await _restClient.postData(url: url, payload: payload);
      if (result["status"] == "success") {
        isCheklist.value = false;
        getCheckWhislist();
      }
    } catch (e) {
      print("Error: $e");
    }
    isLoadingButton.value = false;
  }

  void pilihPaket(String paket) {
    selectedPaket.value = paket;
    print("xxx${paket.toString()}");
  }

  void parseJadwalEvent(dynamic data) {
    jadwalFilter.clear();

    if (data == null) return;

    final bimbelList = data['bimbel'];
    if (bimbelList is! List) return;

    for (var bimbel in bimbelList) {
      if (bimbel == null) continue;

      final name = bimbel['name'] ?? '';
      int type = 0;
      if (name.toLowerCase() == 'reguler') {
        type = 1;
      } else if (name.toLowerCase() == 'extended') {
        type = 2;
      } else if (name.toLowerCase().contains('platinum')) {
        type = 3;
      }

      final events = bimbel['events'];
      if (events is! List) continue;

      for (var event in events) {
        if (event == null) continue;

        final tanggalStr = event['tanggal'];
        if (tanggalStr == null) continue;

        final tgl = DateTime.parse(tanggalStr);

        jadwalFilter.add(
          JadwalFilter(
            judul: event['judul'] ?? '',
            deskripsi: event['deskripsi'] ?? '',
            tanggal: tgl, // simpan DateTime langsung
            tipe: type,
          ),
        );
      }
    }

    // sort berdasarkan DateTime asli
    jadwalFilter.sort((a, b) => a.tanggal.compareTo(b.tanggal));
  }

  Map<String, Map<String, String>> groupJadwalByTanggal(
    List<JadwalFilter> list,
  ) {
    final Map<String, Map<String, String>> result = {};

    for (var item in list) {
      // key pakai tanggal + jam + menit biar unik
      final keyTanggal =
          "${item.tanggal.year}-${item.tanggal.month}-${item.tanggal.day} "
          "${item.tanggal.hour}:${item.tanggal.minute}";

      if (!result.containsKey(keyTanggal)) {
        result[keyTanggal] = {
          "hari": DateFormat.EEEE('id_ID').format(item.tanggal),
          "tanggal": DateFormat("dd MMMM yyyy", "id_ID").format(item.tanggal),
          "jam": DateFormat.Hm().format(item.tanggal),
          "regulerTitle": "",
          "regulerDesc": "",
          "extendedTitle": "",
          "extendedDesc": "",
          "extendedPlatinumTitle": "",
          "extendedPlatinumDesc": "",
        };
      }

      switch (item.tipe) {
        case 1: // reguler
          result[keyTanggal]!["regulerTitle"] = item.judul;
          result[keyTanggal]!["regulerDesc"] = item.deskripsi;
          break;
        case 2: // extended
          result[keyTanggal]!["extendedTitle"] = item.judul;
          result[keyTanggal]!["extendedDesc"] = item.deskripsi;
          break;
        case 3: // platinum
          result[keyTanggal]!["extendedPlatinumTitle"] = item.judul;
          result[keyTanggal]!["extendedPlatinumDesc"] = item.deskripsi;
          break;
      }
    }

    return result;
  }

  void goToPage(int page) {
    if (page >= 1 && page <= totalPage.value) {
      currentPage.value = page;
    }
  }

  void nextPage() {
    if (currentPage.value < totalPage.value) {
      currentPage.value++;
    }
  }

  void prevPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
    }
  }
}

class JadwalFilter {
  final String judul;
  final String deskripsi;
  final DateTime tanggal; // simpan DateTime asli
  final int tipe;

  JadwalFilter({
    required this.judul,
    required this.deskripsi,
    required this.tanggal,
    required this.tipe,
  });

  String get hari => DateFormat.EEEE('id_ID').format(tanggal);
  String get tanggalFormatted =>
      DateFormat("dd MMMM yyyy", "id_ID").format(tanggal);
  String get jam => DateFormat.Hm("id_ID").format(tanggal);
}
