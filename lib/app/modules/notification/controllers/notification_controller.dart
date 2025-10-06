import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class NotificationController extends GetxController {
  final _restClient = RestClient();
  RxString selectedFilter = "Select All".obs;
  RxList notifData = [].obs;
  RxList allReadData = [].obs;
  RxList allUnreadData = [].obs;
  RxBool isLoading = false.obs;
  RxList<Map<String, int>> idSelected = <Map<String, int>>[].obs;
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
      isLoading.value = true;
      final url = await baseUrl + apiGetNotif;

      final result = await _restClient.getData(url: url);
      print("emailnnyaa ${result.toString()}");

      if (result["status"] == "success") {
        final data = result['data'] as List<dynamic>;

        notifData.value = data;

        // Filter untuk allReadData
        allReadData.value =
            data
                .where((item) => item['read'] == 1)
                .map<int>((item) => item['id'] as int)
                .toList();

        // Filter untuk allUnreadData
        allUnreadData.value =
            data
                .where((item) => item['read'] == 0)
                .map<int>((item) => item['id'] as int)
                .toList();
      }
    } catch (e) {
      print("Error polling email verification: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getReadNotif({
    int? id,
    List? idNotif, // opsional, bisa banyak ID
  }) async {
    try {
      final url = await baseUrl + apiReadNotif + "/" + id.toString();

      // Buat payload kalau idNotif ada
      Map<String, dynamic>? payload;
      if (idNotif != null && idNotif.isNotEmpty) {
        payload = {"selectedIds": idNotif}; // bisa masukin banyak ID
      }

      final result = await _restClient.postData(
        url: url,
        payload: payload, // kalau payload null, dianggap tanpa body
      );

      print("Result: ${result.toString()}");

      if (result["status"] == "success") {
        getNotif();
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }

  Future<void> getUnreadNotif({
    required int id,
    List? idNotif, // opsional, bisa banyak ID
  }) async {
    try {
      final url = await baseUrl + apiUnreadNotif + "/" + id.toString();

      // Buat payload kalau idNotif ada
      Map<String, dynamic>? payload;
      if (idNotif != null && idNotif.isNotEmpty) {
        payload = {"selectedIds": idNotif}; // bisa masukin banyak ID
      }

      final result = await _restClient.postData(
        url: url,
        payload: payload, // kalau payload null, request tetap jalan tanpa body
      );

      print("Result: ${result.toString()}");

      if (result["status"] == "success") {
        getNotif(); // refresh data notif setelah update
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }

  Future<void> getDeleteNotif({
    int? id, // optional untuk single delete
    List<int>? idNotif, // optional untuk multiple delete
  }) async {
    try {
      // Kalau id diberikan, pakai itu; kalau idNotif, tetap pakai endpoint sama
      final url =
          await baseUrl + apiDeleteNotif + "/" + (id?.toString() ?? "0");

      Map<String, dynamic>? payload;
      if (idNotif != null && idNotif.isNotEmpty) {
        payload = {"selectedIds": idNotif};
      }

      final result = await _restClient.postData(
        url: url,
        payload: payload, // null kalau single delete tanpa payload
      );

      print("Result: ${result.toString()}");

      if (result["status"] == "success") {
        getNotif(); // refresh notif setelah hapus
      }
    } catch (e) {
      print("Error deleting notifications: $e");
    }
  }
}
