import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class PeringkatTryoutHarianController extends GetxController {
  //TODO: Implement PeringkatTryoutHarianController

  final count = 0.obs;
  late String uuid;
  final restClient = RestClient();
  final searchController = TextEditingController();
  RxList<Map<String, dynamic>> dataPoint = <Map<String, dynamic>>[].obs;
  Map<String, dynamic> dataPointPage = <String, dynamic>{}.obs;
  RxMap<String, bool> loading = <String, bool>{}.obs;
  RxList<Map<String, dynamic>> listProvinsi =
      <Map<String, dynamic>>[
        {"id": "", "nama": "Pilih Provinsi"},
      ].obs;
  RxList<Map<String, dynamic>> listKota =
      <Map<String, dynamic>>[
        {"id": "", "nama": "Pilih Kota/Kabupaten"},
      ].obs;
  RxString selectedProvinsi = "".obs;
  RxString selectedKota = "".obs;
  RxInt currentPage = 1.obs;
  RxInt totalPage = 1.obs;
  RxInt perPage = 10.obs;

  @override
  void onInit() {
    super.onInit();
    initRank();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> initRank() async {
    uuid = await Get.arguments;
    await getUserPoint();
    await getProvinsi();
  }

  Future<void> getUserPoint() async {
    try {
      loading['init'] = true;
      final payload = {
        "menu_category_uuid": uuid,
        "perpage": perPage.value,
        "search": searchController.text,
      };
      if (selectedProvinsi.value != "") {
        payload['provinsi'] = int.parse(selectedProvinsi.value);
      }
      if (selectedKota.value != "") {
        payload['kota_kabupaten'] = int.parse(selectedKota.value);
      }
      final response = await restClient.postData(
        url:
            baseUrl +
            apiGetTryoutHarianUserPoint +
            "?page=${currentPage.value.toString()}",
        payload: payload,
      );
      List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
        response['data']['data'],
      );
      Map<String, dynamic> page = Map<String, dynamic>.from(response['data']);
      dataPoint.assignAll(data);
      dataPointPage.assignAll(page);
      totalPage.value = ((page['total'] / perPage.value) as double).ceil();
    } catch (e) {
      print("fail: ${e}");
      dataPoint.clear();
    } finally {
      loading['init'] = false;
    }
  }

  Future<void> getProvinsi() async {
    final response = await restClient.getData(url: baseUrl + apiGetProvince);
    final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      response['data'],
    );
    listProvinsi.addAll(data);
  }

  Future<void> getKota() async {
    selectedKota.value = "";
    final response = await restClient.getData(
      url: baseUrl + apiGetKabup + "/" + selectedProvinsi.value,
    );
    final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      response['data'],
    );
    listKota.assign({"id": "", "nama": "Pilih Kota/Kabupaten"});
    listKota.addAll(data);
  }

  void getPage() {
    print(currentPage.value.toString());
  }

  // { kota_kabupaten: number; menu_category_uuid: string; params: string; perpage: number; provinsi: number; search: string }
}
