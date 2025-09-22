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
  RxList<Statistic> statistics = <Statistic>[].obs;
  RxString selectedStatistic = ''.obs; // untuk simpan pilihan filter

  @override
  void onInit() async {
    super.onInit();
    await initRapor();
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

  Future<void> initRapor() async {
    uuid = Get.arguments as String;
    nilaiChart = <String, dynamic>{}.obs;
    statistics = <Statistic>[].obs;
    tryoutSaya = <String, dynamic>{}.obs;
    selectedStatistic = ''.obs;
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
    print("payload: ${payload}");

    // Convert list of maps ke list of Statistic
    final List<dynamic> rawData = response['data']['statistics'];

    final parsedStatistics =
        rawData
            .map((item) => Statistic.fromJson(Map<String, dynamic>.from(item)))
            .toList();

    statistics.assignAll(parsedStatistics);
  }

  List<CartesianSeries<ChartData, String>> buildSeries(
    List<Statistic> statistics,
  ) {
    final colors = [
      Colors.yellow,
      Colors.cyan,
      Colors.pink,
      Colors.green,
      Colors.orange,
    ];

    // Filter statistik sesuai dropdown
    final filteredStats =
        selectedStatistic.value.isEmpty
            ? statistics
            : statistics
                .where((stat) => stat.label == selectedStatistic.value)
                .toList();

    return filteredStats.asMap().entries.map((entry) {
      final index = entry.key;
      final stat = entry.value;

      // Mapping nilai menjadi ChartData
      final data = stat.nilais.map((n) => ChartData(n.title, n.nilai)).toList();

      return AreaSeries<ChartData, String>(
        name: stat.label, // contoh: TWK, TIU
        dataSource: data,
        xValueMapper: (d, _) => d.x,
        yValueMapper: (d, _) => d.y,
        color: colors[index % colors.length].withOpacity(0.3),
        borderColor: colors[index % colors.length],
        borderWidth: 1.5,
        markerSettings: const MarkerSettings(isVisible: true),
      );
    }).toList();
  }

  List<String> get statisticLabels {
    if (statistics.isEmpty) return [];
    return statistics.map((e) => e.label).toList();
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

class ChartData {
  final String x; // contoh: "TO 1", "TO 2"
  final int y; // nilai

  ChartData(this.x, this.y);
}

class Nilai {
  final int id;
  final String title;
  final int nilai;

  Nilai({required this.id, required this.title, required this.nilai});

  factory Nilai.fromJson(Map<String, dynamic> json) {
    return Nilai(id: json['id'], title: json['title'], nilai: json['nilai']);
  }
}

class Statistic {
  final int id;
  final String label;
  final List<Nilai> nilais;

  Statistic({required this.id, required this.label, required this.nilais});

  factory Statistic.fromJson(Map<String, dynamic> json) {
    return Statistic(
      id: json['id'],
      label: json['label'],
      nilais: (json['nilais'] as List).map((e) => Nilai.fromJson(e)).toList(),
    );
  }
}
