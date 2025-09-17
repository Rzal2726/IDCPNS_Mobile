import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:skeletonizer/skeletonizer.dart';

class EBookController extends GetxController {
  //TODO: Implement EBookController

  final count = 0.obs;
  final restClient = RestClient();
  RxMap<String, bool> loading = <String, bool>{}.obs;
  RxMap<String, Color> categoryColor =
      <String, Color>{
        "CPNS": Colors.teal,
        "BUMN": Colors.blueAccent,
        "Kedinasan": Colors.orangeAccent,
        "PPPK": Colors.redAccent,
      }.obs;
  RxList<Map<String, dynamic>> eBook = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> eBookList = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> categoryList =
      <Map<String, dynamic>>[
        {"menu": "Semua", "id": ""},
      ].obs;
  RxString selectedKategori = "".obs;
  @override
  void onInit() {
    super.onInit();
    initEbook();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> initEbook() async {
    await getEbook();
    await getCategoryList();
  }

  Future<void> getEbook() async {
    loading['ebook'] = true;
    final payload = {"menu_category_id": selectedKategori.value};
    final response = await restClient.postData(
      url: baseUrl + apiGetEbook,
      payload: payload,
    );

    Map<String, dynamic> data = Map<String, dynamic>.from(response['data']);
    List<Map<String, dynamic>> dataList = List<Map<String, dynamic>>.from(
      data['data'],
    );
    print(payload);
    eBook.assignAll(dataList);
    loading['ebook'] = false;
  }

  Future<void> getEbookList(String id) async {
    loading['ebook-list'] = true;
    final payload = {"ebook_id": id};
    final response = await restClient.postData(
      url: baseUrl + apiGetEbookList,
      payload: payload,
    );

    List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      response['data'],
    );
    eBookList.assignAll(data);
    loading['ebook-list'] = false;
  }

  Future<void> getCategoryList() async {
    final response = await restClient.getData(url: baseUrl + apiGetCategory);

    List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      response['data'],
    );
    categoryList.addAll(data);
    print(data);
  }
}
