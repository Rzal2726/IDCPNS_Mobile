import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class NotificationController extends GetxController {
  final _restClient = RestClient();
  RxString selectedFilter = "Select All".obs;
  RxList notifData = [].obs;
  @override
  void onInit() {
    getNotif();
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

  Future<void> getNotif() async {
    try {
      final url = await baseUrl + apiGetNotif;

      final result = await _restClient.getData(url: url);
      print("emailnnyaa ${result.toString()}");
      if (result["status"] == "success") {
        notifData.value = result['data'];
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }

  Future<void> getReadNotif({required int id}) async {
    try {
      final url = await baseUrl + apiReadNotif + "/" + id.toString();

      final result = await _restClient.postData(url: url);
      print("emailnnyaa ${result.toString()}");
      if (result["status"] == "success") {
        getNotif();
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }

  Future<void> getUnreadNotif({required int id}) async {
    try {
      final url = await baseUrl + apiUnreadNotif + "/" + id.toString();

      final result = await _restClient.postData(url: url);
      print("emailnnyaa ${result.toString()}");
      if (result["status"] == "success") {
        getNotif();
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }

  Future<void> getDeleteNotif({required int id}) async {
    try {
      final url = await baseUrl + apiDeleteNotif + "/" + id.toString();

      final result = await _restClient.postData(url: url);
      print("emailnnyaa ${result.toString()}");
      if (result["status"] == "success") {
        getNotif();
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }
}
