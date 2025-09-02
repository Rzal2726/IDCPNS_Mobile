import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class RaporController extends GetxController {
  //TODO: Implement RaporController

  final count = 0.obs;
  late String uuid;
  final restClient = RestClient();
  RxMap<String, dynamic> tryoutSaya = <String, dynamic>{}.obs;
  RxMap<String, dynamic> nilaiChart = <String, dynamic>{}.obs;
  RxList<Map<String, dynamic>> statistics = <Map<String, dynamic>>[].obs;
  final selectedStatistic = ''.obs; // untuk simpan pilihan filter

  @override
  void onInit() async {
    super.onInit();
    await initRapor();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> initRapor() async {
    uuid = Get.arguments as String;
    await getDetailTryout();
    await getNilai();
    await getRapor();
  }

  Future<void> getDetailTryout() async {
    final response = await restClient.getData(
      url: baseUrl + apiGetDetailTryoutSaya + uuid,
    );

    final Map<String, dynamic> data = Map<String, dynamic>.from(
      response['data'],
    );
    tryoutSaya.assignAll(data);
  }

  Future<void> getNilai() async {
    final response = await restClient.getData(
      url: baseUrl + apiGetNilaiSaya + uuid,
    );

    final Map<String, dynamic> data = Map<String, dynamic>.from(
      response['data'],
    );
    nilaiChart.assignAll(data);
  }

  Future<void> getRapor() async {
    final payload = {
      "no_order": tryoutSaya['no_order'],
      "uuid": tryoutSaya['uuid'],
      "tryout_id": tryoutSaya['tryout']['id'],
      "submenu_category_id": tryoutSaya['submenu_category_id'],
    };
    final response = await restClient.postData(
      url: baseUrl + apiRaporDetail + uuid,
      payload: payload,
    );

    final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      response['data']['statistics'],
    );
    statistics.assignAll(data);
  }

  List<ChartData> get chartData {
    if (statistics.isEmpty) return [];

    final tbi = statistics.firstWhereOrNull((e) => e['label'] == 'TBI');
    final total = statistics.firstWhereOrNull((e) => e['label'] == 'Total');

    if (tbi == null || total == null) return [];

    final tbiNilais = (tbi['nilais'] as List?) ?? [];
    final totalNilais = (total['nilais'] as List?) ?? [];

    // ambil panjang minimum biar aman
    final length =
        tbiNilais.length < totalNilais.length
            ? tbiNilais.length
            : totalNilais.length;

    List<ChartData> data = [];

    for (int i = 0; i < length; i++) {
      final t = tbiNilais[i];
      final tot = totalNilais[i];

      data.add(
        ChartData(
          t['title']?.toString() ?? 'Unknown',
          (t['nilai'] as num?)?.toDouble() ?? 0,
          (tot['nilai'] as num?)?.toDouble() ?? 0,
        ),
      );
    }

    return data;
  }

  List<CartesianSeries<ChartData, String>> get filteredSeries {
    final data = chartData;

    // kalau data kosong, jangan render series (biar nggak crash)
    if (data.isEmpty) return [];

    if (selectedStatistic.value.isEmpty) {
      return [
        AreaSeries<ChartData, String>(
          name: 'TBI',
          dataSource: data,
          xValueMapper: (d, _) => d.x,
          yValueMapper: (d, _) => d.y1,
          color: Colors.yellow.shade200,
          borderColor: Colors.green,
          borderWidth: 1.5,
          markerSettings: const MarkerSettings(isVisible: true),
        ),
        AreaSeries<ChartData, String>(
          name: 'Total',
          dataSource: data,
          xValueMapper: (d, _) => d.x,
          yValueMapper: (d, _) => d.y2,
          color: Colors.cyan.shade100,
          borderColor: Colors.cyan,
          borderWidth: 1.5,
          markerSettings: const MarkerSettings(isVisible: true),
        ),
      ];
    } else if (selectedStatistic.value == 'TBI') {
      return [
        AreaSeries<ChartData, String>(
          name: 'TBI',
          dataSource: data,
          xValueMapper: (d, _) => d.x,
          yValueMapper: (d, _) => d.y1,
          color: Colors.yellow.shade200,
          borderColor: Colors.green,
          borderWidth: 1.5,
          markerSettings: const MarkerSettings(isVisible: true),
        ),
      ];
    } else if (selectedStatistic.value == 'Total') {
      return [
        AreaSeries<ChartData, String>(
          name: 'Total',
          dataSource: data,
          xValueMapper: (d, _) => d.x,
          yValueMapper: (d, _) => d.y2,
          color: Colors.cyan.shade100,
          borderColor: Colors.cyan,
          borderWidth: 1.5,
          markerSettings: const MarkerSettings(isVisible: true),
        ),
      ];
    }
    return [];
  }

  List<String> get statisticLabels {
    if (statistics.isEmpty) return [];
    return statistics.map<String>((e) => e['label'].toString()).toList();
  }
}

class ChartData {
  ChartData(this.x, this.y1, this.y2);
  final String x;
  final double y1;
  final double y2;
}
