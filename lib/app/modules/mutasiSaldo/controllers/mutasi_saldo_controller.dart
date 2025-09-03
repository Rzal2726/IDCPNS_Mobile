import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class MutasiSaldoController extends GetxController {
  final _restClient = RestClient();
  RxMap mutasiSaldoData = {}.obs;
  @override
  void onInit() {
    getMutasiSaldo();
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

  Future<void> getMutasiSaldo() async {
    try {
      final url = await baseUrl + apiGetMutasiSaldo;

      final result = await _restClient.postData(url: url);
      print("emailnnyaa ${result.toString()}");
      if (result["status"] == "success") {
        var data = result['data'];
        mutasiSaldoData.value = data;
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }
}
