import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class NotificationController extends GetxController {
  final _restClient = RestClient();
  RxString selectedFilter = "Select All".obs;
  RxList notifData = [].obs;
  var unreadNotifications =
      [
        {"title": "Pembayaran Gagal", "date": "23 Aug 2025"},
        {"title": "Menunggu Pembayaran", "date": "22 Aug 2025"},
        {"title": "Menunggu Pembayaran", "date": "22 Aug 2025"},
        {"title": "Menunggu Pembayaran", "date": "22 Aug 2025"},
      ].obs;

  var readNotifications =
      [
        {"title": "Pembayaran Sukses", "date": "20 Aug 2025"},
        {"title": "Tryout Selesai", "date": "18 Aug 2025"},
      ].obs;
  final count = 0.obs;
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
}
