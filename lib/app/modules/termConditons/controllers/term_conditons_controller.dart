import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class TermConditonsController extends GetxController {
  final _restClient = RestClient();
  RxString htmlContent = "".obs;
  RxBool isLoading = false.obs;
  @override
  void onInit() {
    GetTermAndCond();
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

  // apiSyaratDanKetentuan
  Future<void> GetTermAndCond() async {
    final url = baseUrl + apiSyaratDanKetentuan;

    isLoading.value = true;
    try {
      final result = await _restClient.getData(url: url);
      htmlContent.value = result['value'];
    } catch (e) {
      debugPrint("Unexpected error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
