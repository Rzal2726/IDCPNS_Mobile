import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class TarikKomisiController extends GetxController {
  final _restClient = RestClient();
  RxList bankList = [].obs;
  RxInt rekeningNum = 0.obs;
  final List<String> informationPoints = [
    'Minimal penarikan komisi adalah Rp.500.000',
    'Biaya Admin setiap penarikan adalah Rp.4.950',
    'Pastikan komisi yang ditarik tidak lebih dari Komisi Tersedia',
    'Penarikan komisi akan diproses 3 Hari kerja (Tergantung antrian penarikan)',
  ];
  final count = 0.obs;
  @override
  void onInit() {
    getMutasi();
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

  Future<void> getMutasi() async {
    try {
      final url = baseUrl + apiGetRekeningUser;
      final result = await _restClient.getData(url: url);

      if (result["status"] == "success") {
        // map data ke format id + name
        bankList.value = result['data'];
      }
    } catch (e) {
      print("Error getBank: $e");
    }
  }

  Future<void> postMutasi() async {
    try {
      final url = baseUrl + apiPostMutasiSaldo;
      var payload = {"nominal": 0, "rekening": rekeningNum.value};
      final result = await _restClient.postData(url: url, payload: payload);

      if (result["status"] == "success") {}
    } catch (e) {
      print("Error getBankz: $e");
    }
  }
}
