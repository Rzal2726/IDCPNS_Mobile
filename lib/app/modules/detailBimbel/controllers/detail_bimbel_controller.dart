import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:intl/intl.dart';

class DetailBimbelController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final _restClient = RestClient();
  final tabs = ['Detail', 'Jadwal', 'FAQ'];
  RxMap datalBimbelData = {}.obs;
  RxMap datalCheckList = {}.obs;
  RxString wishlistUuid = "".obs;
  RxString selectedPaket = "".obs;
  late TabController tabController;
  var idBimbel = Get.arguments;
  RxInt currentIndex = 0.obs;
  List<JadwalFilter> jadwalFilter = [];

  @override
  void onInit() {
    super.onInit();
    getDetailBimbel(id: idBimbel);
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future<void> getDetailBimbel({required String id}) async {
    try {
      final url = baseUrl + apiGetDetailBimbel + "/" + id;

      final result = await _restClient.getData(url: url);
      print("asdas ${result.toString()}");

      if (result["status"] == "success") {
        var data = result['data'];
        parseJadwalEvent(data);
        print("Jumlah jadwal: ${jadwalFilter.length}");
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
            final lastItem = filtered.last;

            // ambil index pertama dari list awal setelah filter → ini sebenarnya lastItem
            selectedPaket.value = lastItem['uuid'];
            print("xxx ${selectedPaket.toString()}");
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
        if (data != null) {
          datalCheckList.value = data;
          wishlistUuid.value = data['uuid'] ?? "";
        } else {
          datalCheckList.value = {}; // kosongin kalau null
          wishlistUuid.value = "";
        }
      }
    } catch (e) {
      print("Error polling check wishlist: $e");
    }
  }

  Future<void> getAddWhislist() async {
    try {
      final url = await baseUrl + apiAddWhistlist;
      var payload = {
        "bimbel_parent_id": datalBimbelData['id'],
        "menu_category_id": datalBimbelData['menu_category_id'],
      };
      print("sad ${payload.toString()}");
      final result = await _restClient.postData(url: url, payload: payload);
      if (result["status"] == "success") {
        getCheckWhislist();
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> getDeleteWhisList() async {
    try {
      final url = await baseUrl + apiDeleteWhislist;
      var payload = {"uuid": datalCheckList['uuid']};
      final result = await _restClient.postData(url: url, payload: payload);
      if (result["status"] == "success") {
        getCheckWhislist();
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  void pilihPaket(String paket) {
    selectedPaket.value = paket;
    print("xxx${paket.toString()}");
  }

  void parseJadwalEvent(dynamic data) {
    jadwalFilter.clear();

    if (data == null) return;

    // ambil langsung dari data['bimbel']
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

      final events = bimbel['event'];
      if (events is! List) continue;

      for (var event in events) {
        if (event == null) continue;

        final tanggalStr = event['tanggal'];
        String hari = '';
        String tglFormatted = '';
        String jam = '';

        if (tanggalStr != null && tanggalStr.toString().isNotEmpty) {
          final tgl = DateTime.parse(tanggalStr);
          hari = DateFormat.EEEE('id_ID').format(tgl);
          tglFormatted = DateFormat("dd MMMM yyyy", "id_ID").format(tgl);
          jam = DateFormat.Hm("id_ID").format(tgl);
        }

        jadwalFilter.add(
          JadwalFilter(
            judul: event['judul'] ?? '',
            deskripsi: event['deskripsi'] ?? '',
            tanggal: "$hari, $tglFormatted $jam",
            tipe: type,
          ),
        );
      }
    }

    // sort by date
    jadwalFilter.sort((a, b) {
      final dateA = DateTime.parse(
        (a.tanggal
            .split(", ")
            .last
            .split(" ")
            .reversed
            .take(3)
            .toList()
            .reversed
            .join(" ")),
      );
      final dateB = DateTime.parse(
        (b.tanggal
            .split(", ")
            .last
            .split(" ")
            .reversed
            .take(3)
            .toList()
            .reversed
            .join(" ")),
      );
      return dateA.compareTo(dateB);
    });
  }
}

class JadwalFilter {
  final String judul;
  final String deskripsi;
  final String tanggal;
  final int tipe;

  JadwalFilter({
    required this.judul,
    required this.deskripsi,
    required this.tanggal,
    required this.tipe,
  });
}
