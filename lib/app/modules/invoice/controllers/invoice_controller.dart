import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class InvoiceController extends GetxController {
  final _restClient = RestClient();
  RxMap notifData = {}.obs;
  final box = GetStorage();
  @override
  void onInit() async {
    await initializeDateFormatting('id_ID', null); // <-- tambahin ini
    getData();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> getData() async {
    print("Xxxc ${Get.arguments}");
    try {
      final url = await baseUrl + apiGetTransaction;

      final result = await _restClient.postData(url: url);

      if (result["status"] == "success") {
        var id = Get.arguments.toString();

        var data = result['data']['data'] as List;

        // 1️⃣ Cari berdasarkan id dulu
        var found = data.firstWhere(
          (item) => item['id'].toString() == id,
          orElse: () => null,
        );

        // 2️⃣ Kalau gak ketemu, baru cari berdasarkan uuid
        found ??= data.firstWhere(
          (item) => item['uuid'].toString() == id,
          orElse: () => null,
        );

        if (found != null) {
          notifData.value = found;
          print("✅ Ketemu data: ${notifData['uuid']}");
        } else {
          print("❌ Data dengan id/uuid $id tidak ditemukan");
        }
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }

  String formatTanggal(String? tanggalStr) {
    if (tanggalStr == null || tanggalStr.isEmpty) return "-";
    try {
      DateTime date = DateTime.parse(tanggalStr);
      // Format: 26 September 2025, 11:15
      return DateFormat("dd MMMM yyyy, HH:mm", "id_ID").format(date);
    } catch (e) {
      return tanggalStr; // fallback kalau gagal parse
    }
  }
}
