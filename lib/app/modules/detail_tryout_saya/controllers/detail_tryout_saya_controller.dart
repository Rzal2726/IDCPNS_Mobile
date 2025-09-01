import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/data/rest_client_provider.dart';
import 'package:idcpns_mobile/app/modules/tryout_saya/controllers/tryout_saya_controller.dart';

class DetailTryoutSayaController extends GetxController {
  //TODO: Implement DetailTryoutSayaController
  late String lateUuid;
  final count = 0.obs;
  RxMap<String, dynamic> tryOutSaya = <String, dynamic>{}.obs;
  RxMap<String, dynamic> nilaiChart = <String, dynamic>{}.obs;
  RxList<Map<String, dynamic>> listJabatan = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> listInstansi = <Map<String, dynamic>>[].obs;
  RxString uuid = "".obs;
  RxString nilaiBenar = "0".obs;
  RxString totalSoal = "0".obs;
  RxString selectedJabatan = " ".obs;
  RxString selectedInstansi = "".obs;

  final List<ChartData> chartData = [];
  @override
  void onInit() async {
    super.onInit();
    await initTryoutSaya();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> initTryoutSaya() async {
    lateUuid = await Get.arguments as String;

    await getDetailTryout();
    await getNilai();
    await getStatsNilai();
    await getServerTime();
    await getInstansi();
    await getJabatan();
  }

  Future<void> getDetailTryout() async {
    final client = Get.find<RestClientProvider>();
    final response = await client.get(
      headers: {
        "Authorization":
            "Bearer 18|V9PnP29RzhtFCKwwbb1NLFUliZ9YLK9PiFDCa5Ir9f6c4eb3",
      },
      '/tryout/me/detail/${lateUuid}',
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = Map<String, dynamic>.from(
        response.body['data'],
      );
      tryOutSaya.assignAll(data);
      print('Data Detail: ${response.body}');
    } else {
      print('Error: ${response.statusText}');
    }
  }

  Future<void> getNilai() async {
    final client = Get.find<RestClientProvider>();
    final response = await client.get(
      headers: {
        "Authorization":
            "Bearer 18|V9PnP29RzhtFCKwwbb1NLFUliZ9YLK9PiFDCa5Ir9f6c4eb3",
      },
      '/tryout/nilai/detail/${lateUuid}',
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = Map<String, dynamic>.from(
        response.body['data'],
      );
      nilaiChart.assignAll(data);
      print('Data Nilai: ${response.body}');
    } else {
      print('Error: ${response.statusText}');
    }
  }

  Future<void> getStatsNilai() async {
    final client = Get.find<RestClientProvider>();
    final response = await client.get(
      headers: {
        "Authorization":
            "Bearer 18|V9PnP29RzhtFCKwwbb1NLFUliZ9YLK9PiFDCa5Ir9f6c4eb3",
      },
      '/tryout/waktu/detail/${lateUuid}',
    );

    if (response.statusCode == 200) {
      print('Data Stat Nilai: ${response.body}');
    } else {
      print('Error: ${response.statusText}');
    }
  }

  Future<void> getServerTime() async {
    final client = Get.find<RestClientProvider>();
    final response = await client.get(
      headers: {
        "Authorization":
            "Bearer 18|V9PnP29RzhtFCKwwbb1NLFUliZ9YLK9PiFDCa5Ir9f6c4eb3",
      },
      '/general/server-time',
    );

    if (response.statusCode == 200) {
      print('Data Server Time: ${response.body}');
    } else {
      print('Error: ${response.statusText}');
    }
  }

  Future<void> getInstansi() async {
    final client = Get.find<RestClientProvider>();
    final response = await client.get(
      headers: {
        "Authorization":
            "Bearer 18|V9PnP29RzhtFCKwwbb1NLFUliZ9YLK9PiFDCa5Ir9f6c4eb3",
      },
      '/general/instansi/${tryOutSaya['tryout']['menu_category_id']}',
    );

    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
        response.body['data'],
      );
      listInstansi.assignAll(data);
      print('Data: ${response.body}');
    } else {
      print('Error: ${response.statusText}');
    }
  }

  Future<void> getJabatan() async {
    final client = Get.find<RestClientProvider>();
    final response = await client.get(
      headers: {
        "Authorization":
            "Bearer 18|V9PnP29RzhtFCKwwbb1NLFUliZ9YLK9PiFDCa5Ir9f6c4eb3",
      },
      '/general/jabatan/${tryOutSaya['tryout']['menu_category_id']}',
    );

    if (response.statusCode == 200) {
      final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
        response.body['data'],
      );
      listJabatan.assignAll(data);
      print('Data: ${response.body}');
    } else {
      print('Error: ${response.statusText}');
    }
  }

  Future<void> resetTryout() async {
    final client = Get.find<RestClientProvider>();
    final response = await client.post(
      headers: {
        "Authorization":
            "Bearer 18|V9PnP29RzhtFCKwwbb1NLFUliZ9YLK9PiFDCa5Ir9f6c4eb3",
      },
      '/tryout/quiz/reset/',
      {"tryout_transaction_id": lateUuid},
    );

    if (response.statusCode == 200) {
      initTryoutSaya();
      print('Data Detail: ${response.body}');
    } else {
      print('Error: ${response.statusText}');
    }
  }

  String hitungMasaAktif(String tanggal) {
    String expiredDate = tanggal;

    // parse string ke DateTime
    DateTime target = DateTime.parse(expiredDate);
    DateTime now = DateTime.now();

    // hitung difference
    Duration diff = target.difference(now);
    return diff.inDays.toString();
  }

  void checkList() {
    print("listJabatan: ${listJabatan}");
    print("listInstansi: ${listInstansi}");
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double y;
}
