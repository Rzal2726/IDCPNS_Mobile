import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class CommisionDetailController extends GetxController {
  final _restClient = RestClient();
  RxMap komisiDetailData = {}.obs;
  @override
  void onInit() {
    getRincianKomisi();
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

  Future<void> getRincianKomisi() async {
    try {
      final url = await baseUrl + apiGetRincianKomisi;

      final result = await _restClient.postData(url: url);
      print("emailnnyaa ${result.toString()}");
      if (result["status"] == "success") {
        var data = result['data'];
        komisiDetailData.value = data;
        print("asda ${data['data'][0]['user'].toString()}");
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }
}
