import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class DetailBimbelController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final _restClient = RestClient();
  RxMap datalBimbelData = {}.obs;
  RxList datalCheckList = [].obs;
  var selectedPaket = 'Reguler'.obs;
  late TabController tabController;
  var idBimbel = Get.arguments;
  RxInt currentIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getDetailBimbel(id: idBimbel);
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future<void> getDetailBimbel({required id}) async {
    try {
      final url = await baseUrl + apiGetDetailBimbel + "/" + id;

      final result = await _restClient.getData(url: url);
      print("asdas ${result.toString()}");
      if (result["status"] == "success") {
        var data = result['data'];
        datalBimbelData.value = data;
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }

  Future<void> getCheckWhislist() async {
    try {
      final url = await baseUrl + apiCheckWishList;

      final result = await _restClient.getData(url: url);
      if (result["status"] == "success") {
        var data = result['data'];
        datalCheckList.value = data;
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }

  Future<void> getAddWhislist() async {
    try {
      final url = await baseUrl + apiAddWhistlist;

      final result = await _restClient.getData(url: url);
      if (result["status"] == "success") {
        var data = result['data'];
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }

  Future<void> getDeleteWhisList() async {
    try {
      final url = await baseUrl + apiDeleteWhislist;

      final result = await _restClient.getData(url: url);
      if (result["status"] == "success") {
        var data = result['data'];
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }

  void pilihPaket(String paket) {
    selectedPaket.value = paket;
  }
}
