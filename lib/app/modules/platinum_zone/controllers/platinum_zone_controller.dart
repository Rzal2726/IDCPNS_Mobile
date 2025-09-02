import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class PlatinumZoneController extends GetxController {
  //TODO: Implement PlatinumZoneController

  final restClient = RestClient();
  RxMap<String, dynamic> data = <String, dynamic>{}.obs;
  @override
  void onInit() async {
    super.onInit();
    await initPlatinum();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> initPlatinum() async {
    await cekPlatinum();
    print(data);
  }

  Future<void> cekPlatinum() async {
    final response = restClient.getData(url: baseUrl + apiCekPlatinumExpired);
    Map<String, dynamic> responseData = Map<String, dynamic>.from(
      response['data'],
    );
    data.assignAll(responseData);
  }
}
