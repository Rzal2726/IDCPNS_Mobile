import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/data/rest_client_provider.dart';
import 'package:idcpns_mobile/app/modules/tryout_saya/controllers/tryout_saya_controller.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/chart_data_model.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DetailTryoutSayaController extends GetxController {
  //TODO: Implement DetailTryoutSayaController
  final restClient = RestClient();
  late String lateUuid;
  late dynamic localStorage;
  final count = 0.obs;
  RxMap<String, dynamic> loading = <String, dynamic>{}.obs;

  RxMap<String, dynamic> tryOutSaya = <String, dynamic>{}.obs;
  RxMap<String, dynamic> nilaiChart = <String, dynamic>{}.obs;
  RxMap<String, dynamic> nilaiChartStat = <String, dynamic>{}.obs;
  RxList<Map<String, dynamic>> listJabatan =
      <Map<String, dynamic>>[
        {"id": 0, "uuid": "", "nama": "Pilih Jabatan", "menu_category_id": 0},
      ].obs;
  RxList<Map<String, dynamic>> listInstansi =
      <Map<String, dynamic>>[
        {"id": 0, "uuid": "", "nama": "Pilih Instansi", "menu_category_id": 0},
      ].obs;
  RxString uuid = "".obs;
  RxString nilaiBenar = "0".obs;
  RxString totalSoal = "0".obs;
  RxString selectedJabatan = "0".obs;
  RxString selectedInstansi = "0".obs;
  RxInt totalValue = 0.obs;

  final remaining = ''.obs;
  Timer? _ticker;

  final RxList<ChartData> chartData = <ChartData>[].obs;
  List<ChartData>? get chartDataList => chartData;

  @override
  void onInit() async {
    await initializeDateFormatting('id_ID', null);
    super.onInit();
    await initTryoutSaya();
    checkMaintenance();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    _ticker?.cancel();
    super.onClose();
  }

  Future<void> initTryoutSaya() async {
    loading['chart'] = true;
    localStorage = await SharedPreferences.getInstance();
    lateUuid = await Get.arguments as String;

    await getDetailTryout();
    await getNilai();
    await getServerTime();
    await getInstansi();
    await getJabatan();
    await getStatsNilai();

    startCountdown(
      startDate: DateTime.now(),
      endDate: DateTime.parse(tryOutSaya['tryout']['startdate']),
    );

    loading['chart'] = false;
  }

  Future<void> getDetailTryout() async {
    final response = await restClient.getData(
      url: baseUrl + apiGetDetailTryoutSaya + lateUuid,
    );

    final Map<String, dynamic> data = Map<String, dynamic>.from(
      response['data'],
    );
    tryOutSaya.assignAll(data);
    print(data);
    print("tanggal sekarang ${DateTime.now()}");
  }

  Future<void> getNilai() async {
    final response = await restClient.getData(
      url: baseUrl + apiGetNilaiSaya + lateUuid,
    );

    final Map<String, dynamic> data = Map<String, dynamic>.from(
      response['data'],
    );
    nilaiChart.assignAll(data);
  }

  Future<void> getStatsNilai() async {
    try {
      final response = await restClient.getData(
        url: baseUrl + apiGetNilaiDetail + lateUuid,
      );

      final Map<String, dynamic> data = Map<String, dynamic>.from(
        response['data'],
      );
      print("chart nilai: ${data}");

      // Simpan semua data untuk digunakan di widget
      nilaiChartStat.assignAll(data);

      // Bersihkan data lama
      chartData.clear();

      // Ambil statistik untuk subcategories agar masuk ke Bar Chart
      if (data['statistics'] != null) {
        for (var stat in data['statistics']) {
          String label = stat['label']; // TWK, TIU, TKP

          for (var soal in stat['waktu_pengerjaan']) {
            final title = soal['title'] ?? '';
            final noSoal = soal['no_soal'] ?? 0;
            final value = soal['value'] ?? 0;

            // Misal value 1 = benar, 0 = salah/kosong
            Color color;
            String status;
            if (value == 1) {
              color = Colors.green;
              status = 'Benar';
            } else {
              color = Colors.red;
              status = 'Salah';
            }

            chartData.add(
              ChartData('Soal $noSoal', value.toString(), Colors.amberAccent),
            );
          }
        }
      }

      for (var stat in nilaiChartStat['statistics']) {
        for (var waktu in stat['waktu_pengerjaan']) {
          totalValue.value += waktu['value'] as int;
        }
      }
    } catch (e) {
      return;
    }
  }

  Future<void> getServerTime() async {
    final response = await restClient.getData(url: baseUrl + apiGetServerTime);
  }

  Future<void> getInstansi() async {
    final response = await restClient.getData(
      url:
          baseUrl +
          apiGetInstansi +
          tryOutSaya['tryout']['menu_category_id'].toString(),
    );

    final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      response['data'],
    );
    listInstansi.addAll(data);
  }

  Future<void> getJabatan() async {
    final response = await restClient.getData(
      url:
          baseUrl +
          apiGetJabatan +
          tryOutSaya['tryout']['menu_category_id'].toString(),
    );

    final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      response['data'],
    );
    listJabatan.addAll(data);
  }

  Future<void> resetTryout() async {
    final payload = {"tryout_transaction_id": lateUuid};

    final response = await restClient.postData(
      url: baseUrl + apiResetTryout,
      payload: payload,
    );

    await getDetailTryout();
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

  int hitungTotalMasaAktif(String tanggalBeli, String tanggalKadaluarsa) {
    String expiredDate = tanggalKadaluarsa;
    String buyDate = tanggalBeli;

    // parse string ke DateTime
    DateTime target = DateTime.parse(expiredDate);
    DateTime targetBuy = DateTime.parse(buyDate);

    // hitung difference
    Duration diff = target.difference(targetBuy);
    return diff.inDays;
  }

  void checkList() {
    print("listJabatan: ${listJabatan}");
    print("listInstansi: ${listInstansi}");
  }

  Future<void> checkMaintenance() async {
    final response = await restClient.getData(
      url: baseUrl + apiCheckMaintenance,
    );
    if (response['is_maintenance']) {
      Get.offAllNamed("/maintenance");
    }
  }

  String formatTanggal(String? tanggalStr) {
    if (tanggalStr == null || tanggalStr.isEmpty) return "-";
    try {
      DateTime date = DateTime.parse(tanggalStr);
      return DateFormat("dd MMMM yyyy", "id_ID").format(date);
    } catch (e) {
      return tanggalStr; // fallback kalau gagal parse
    }
  }

  void startCountdown({
    required DateTime startDate,
    required DateTime endDate,
  }) {
    _ticker?.cancel();
    final two = NumberFormat('00');

    void update() {
      final now = DateTime.now();
      if (now.isAfter(endDate)) {
        remaining.value =
            '${two.format(0)} Hari ${two.format(0)} Jam ${two.format(0)} Menit ${two.format(0)} Detik';
        _ticker?.cancel();
        return;
      }

      // choose target (start if not yet started, else end)
      final target = now.isBefore(startDate) ? startDate : endDate;

      var diff = target.difference(now);
      if (diff.isNegative) diff = Duration.zero;

      final d = diff.inDays;
      final h = diff.inHours % 24;
      final m = diff.inMinutes % 60;
      final s = diff.inSeconds % 60;

      remaining.value =
          '${two.format(d)} Hari ${two.format(h)} Jam ${two.format(m)} Menit ${two.format(s)} Detik';
    }

    update(); // initial paint
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => update());
  }

  Future<void> addToCalendar({
    required String title,
    required DateTime startDate,
    required DateTime endDate,
    String? description,
    String? location,
    String? url, // optional source link
  }) async {
    // ----- helpers -----
    String _fmtICS(DateTime dt) =>
        DateFormat("yyyyMMdd'T'HHmmss'Z'").format(dt.toUtc());

    String _esc(String s) => s
        .replaceAll('\\', '\\\\')
        .replaceAll(';', r'\;')
        .replaceAll(',', r'\,')
        .replaceAll('\n', r'\n');

    String _icsContent() {
      final now = _fmtICS(DateTime.now());
      final uid = '${DateTime.now().millisecondsSinceEpoch}@yourapp';
      return [
        'BEGIN:VCALENDAR',
        'VERSION:2.0',
        'PRODID:-//Your App//id',
        'CALSCALE:GREGORIAN',
        'METHOD:PUBLISH',
        'BEGIN:VEVENT',
        'UID:$uid',
        'DTSTAMP:$now',
        'DTSTART:${_fmtICS(startDate)}',
        'DTEND:${_fmtICS(endDate)}',
        'SUMMARY:${_esc(title)}',
        if (description?.isNotEmpty == true)
          'DESCRIPTION:${_esc(description!)}',
        if (location?.isNotEmpty == true) 'LOCATION:${_esc(location!)}',
        if (url?.isNotEmpty == true) 'URL:${_esc(url!)}',
        'END:VEVENT',
        'END:VCALENDAR',
      ].join('\r\n');
    }

    Future<void> _openGoogle() async {
      final q = {
        'action': 'TEMPLATE',
        'text': title,
        'dates': '${_fmtICS(startDate)}/${_fmtICS(endDate)}',
        if (description?.isNotEmpty == true) 'details': description!,
        if (location?.isNotEmpty == true) 'location': location!,
        'sf': 'true',
        'output': 'xml',
      };
      final uri = Uri.https('calendar.google.com', '/calendar/render', q);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }

    Future<void> _openOutlook() async {
      final q = {
        'rru': 'addevent',
        'startdt': startDate.toUtc().toIso8601String(),
        'enddt': endDate.toUtc().toIso8601String(),
        'subject': title,
        if (description?.isNotEmpty == true) 'body': description!,
        if (location?.isNotEmpty == true) 'location': location!,
      };
      final uri = Uri.https(
        'outlook.live.com',
        '/calendar/0/deeplink/compose',
        q,
      );
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }

    Future<void> _openYahoo() async {
      final q = {
        'v': '60',
        'view': 'd',
        'type': '20',
        'title': title,
        'st': _fmtICS(startDate),
        'et': _fmtICS(endDate),
        if (description?.isNotEmpty == true) 'desc': description!,
        if (location?.isNotEmpty == true) 'in_loc': location!,
      };
      final uri = Uri.https('calendar.yahoo.com', '/', q);
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }

    Future<void> _shareICS() async {
      final dir = await getTemporaryDirectory();
      final path =
          '${dir.path}/event_${DateTime.now().millisecondsSinceEpoch}.ics';
      final file = File(path)..writeAsStringSync(_icsContent());

      final params = ShareParams(
        text: 'Add "$title" to your calendar',
        files: [XFile(path, mimeType: 'text/calendar')],
      );

      await SharePlus.instance.share(params);
    }

    // ----- UI sheet -----
    await Get.bottomSheet(
      SafeArea(
        child: Wrap(
          children: [
            _Tile(icon: '🗓️', label: 'Google', onTap: _openGoogle),
            _Tile(icon: '📅', label: 'iCal File', onTap: _shareICS),
            _Tile(icon: '📧', label: 'Outlook.com', onTap: _openOutlook),
            _Tile(icon: '🟪', label: 'Yahoo', onTap: _openYahoo),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Get.back(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                    side: BorderSide(color: Colors.teal),
                  ),
                ),
                child: Text('Kembali'),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}

class LineChartData {
  LineChartData(this.x, this.y, this.color);

  final String x;
  final String y;
  final Color color;
}

class _Tile extends StatelessWidget {
  final String icon;
  final String label;
  final Future<void> Function() onTap;
  const _Tile({
    required this.icon,
    required this.label,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(icon, style: const TextStyle(fontSize: 20)),
      title: Text(label),
      onTap: () async {
        Get.back(); // close sheet
        await onTap();
      },
    );
  }
}
