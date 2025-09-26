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
    try {
      final url = await baseUrl + apiGetTransaction;

      final result = await _restClient.postData(url: url);

      if (result["status"] == "success") {
        var id = Get.arguments;

        // pastikan result['data'] berupa list
        var data = result['data']['data'] as List;

        // cari data pertama yang id-nya sesuai dengan argument
        var found = data.firstWhere(
          (item) => item['id'] == id,
          orElse: () => null, // biar gak error kalau ga ketemu
        );

        if (found != null) {
          notifData.value = found;
        } else {
          print("Data dengan id $id tidak ditemukan");
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
