import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class MyBimbelController extends GetxController {
  final _restClient = RestClient();
  var searchText = ''.obs;
  RxMap listBimbel = {}.obs;

  final count = 0.obs;
  @override
  void onInit() {
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

  void doSearch() {
    Get.snackbar('Cari', 'Fitur pencarian belum tersedia');
  }

  Future<void> getData() async {
    try {
      final url = await baseUrl + apiGetMyBimbel;
      var payload = {"perpage": 5};
      final result = await _restClient.postData(url: url, payload: payload);
      if (result["status"] == "success") {
        var data = result['data'];
        listBimbel.value = data;
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }
}
