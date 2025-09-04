import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class DetailBimbelController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final _restClient = RestClient();
  RxMap datalBimbelData = {}.obs;
  RxMap datalCheckList = {}.obs;
  RxString wishlistUuid = "".obs;
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
        getCheckWhislist();
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }

  Future<void> getCheckWhislist() async {
    try {
      final url = baseUrl + apiCheckWishList + "/" + idBimbel;
      final result = await _restClient.getData(url: url);

      if (result["status"] == "success") {
        var data = result['data'];
        if (data != null) {
          datalCheckList.value = data;
          wishlistUuid.value = data['uuid'] ?? "";
        } else {
          datalCheckList.value = {}; // kosongin kalau null
          wishlistUuid.value = "";
        }
      }
    } catch (e) {
      print("Error polling check wishlist: $e");
    }
  }

  Future<void> getAddWhislist() async {
    try {
      final url = await baseUrl + apiAddWhistlist;
      var payload = {
        "bimbel_parent_id": datalBimbelData['id'],
        "menu_category_id": datalBimbelData['menu_category_id'],
      };
      print("sad ${payload.toString()}");
      final result = await _restClient.postData(url: url, payload: payload);
      if (result["status"] == "success") {
        getCheckWhislist();
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> getDeleteWhisList() async {
    try {
      final url = await baseUrl + apiDeleteWhislist;
      var payload = {"uuid": datalCheckList['uuid']};
      final result = await _restClient.postData(url: url, payload: payload);
      if (result["status"] == "success") {
        getCheckWhislist();
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  void pilihPaket(String paket) {
    selectedPaket.value = paket;
  }
}
