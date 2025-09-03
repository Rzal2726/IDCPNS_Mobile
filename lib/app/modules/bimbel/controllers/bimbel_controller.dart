import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class BimbelController extends GetxController {
  final _restClient = RestClient();
  RxList bimbelData = [].obs;
  var selectedUuid = ''.obs;
  var searchQuery = ''.obs;
  final count = 0.obs;
  @override
  void onInit() {
    getBimbel();
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

  void searchPaket(String query) {
    searchQuery.value = query;
    // Dummy: hanya update query, belum filter real.
  }

  Future<void> getBimbel() async {
    try {
      final url = await baseUrl + apiGetBimbel;
      // var payload = {
      //   "perpage": 1,
      //   "menu_category_id": "1",
      //   "submenu_category_id": "1",
      //   "search": "",
      // };
      final result = await _restClient.postData(url: url);
      if (result["status"] == "success") {
        var data = result['data']['data'];
        bimbelData.value = data;
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }
}
