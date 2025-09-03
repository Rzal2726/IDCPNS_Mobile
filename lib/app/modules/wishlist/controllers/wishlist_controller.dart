import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class WishlistController extends GetxController {
  final _restClient = RestClient();
  var searchQuery = ''.obs;
  RxMap whistlistData = {}.obs;
  @override
  void onInit() {
    getWhislist();
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

  void updateSearch(String value) {
    searchQuery.value = value;
  }

  Future<void> getWhislist() async {
    try {
      final url = await baseUrl + apiGetwhislist;

      final result = await _restClient.postData(url: url);
      print("emailnnyaa ${result.toString()}");
      if (result["status"] == "success") {
        whistlistData.value = result['data'];
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }
}
