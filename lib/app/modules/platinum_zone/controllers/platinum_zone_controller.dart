import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class PlatinumZoneController extends GetxController {
  //TODO: Implement PlatinumZoneController

  final restClient = RestClient();
  RxMap<String, dynamic> data = <String, dynamic>{}.obs;
  RxMap<String, dynamic> userData = <String, dynamic>{}.obs;
  RxBool isActive = false.obs;
  RxBool loading = true.obs;
  @override
  void onInit() {
    super.onInit();
    init();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> init() async {
    await cekPlatinum();
    await cekUser();
    loading.value = false;
  }

  Future<void> cekPlatinum() async {
    final response = await restClient.getData(
      url: baseUrl + apiCekPlatinumExpired,
    );
    Map<String, dynamic> responseData = Map<String, dynamic>.from(
      response['data'],
    );
    data.assignAll(responseData);
  }

  Future<void> cekUser() async {
    final response = await restClient.getData(url: baseUrl + apiGetUser);
    Map<String, dynamic> responseData = Map<String, dynamic>.from(
      response['data'],
    );
    userData.assignAll(responseData);
    if (responseData['level_name'] == "Basic") {
      isActive.value = true;
    }
  }
}
