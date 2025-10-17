import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class PeringkatTryoutController extends GetxController {
  //TODO: Implement PeringkatTryoutController

  final count = 0.obs;
  late String uuid;
  final restClient = RestClient();
  final searchController = TextEditingController();
  RxMap<String, dynamic> tryoutSaya = <String, dynamic>{}.obs;
  RxMap<String, bool> loading = <String, bool>{"filter": false}.obs;
  RxList<Map<String, dynamic>> listPeringkat = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> listPeringkatDummy =
      <Map<String, dynamic>>[
        {
          "no": "1",
          "user_name": "lorem",
          "provinsi_nama": "ipsum",
          "kabupaten_nama": "dolor",
          "total": "0",
          "islulus": 1,
        },
        {
          "no": "2",
          "user_name": "lorem",
          "provinsi_nama": "ipsum",
          "kabupaten_nama": "dolor",
          "total": "0",
          "islulus": 1,
        },
        {
          "no": "3",
          "user_name": "lorem",
          "provinsi_nama": "ipsum",
          "kabupaten_nama": "dolor",
          "total": "0",
          "islulus": 1,
        },
        {
          "no": "4",
          "user_name": "lorem",
          "provinsi_nama": "ipsum",
          "kabupaten_nama": "dolor",
          "total": "0",
          "islulus": 1,
        },
        {
          "no": "5",
          "user_name": "lorem",
          "provinsi_nama": "ipsum",
          "kabupaten_nama": "dolor",
          "total": "0",
          "islulus": 1,
        },
        {
          "no": "6",
          "user_name": "lorem",
          "provinsi_nama": "ipsum",
          "kabupaten_nama": "dolor",
          "total": "0",
          "islulus": 1,
        },
        {
          "no": "7",
          "user_name": "lorem",
          "provinsi_nama": "ipsum",
          "kabupaten_nama": "dolor",
          "total": "0",
          "islulus": 1,
        },
        {
          "no": "8",
          "user_name": "lorem",
          "provinsi_nama": "ipsum",
          "kabupaten_nama": "dolor",
          "total": "0",
          "islulus": 1,
        },
        {
          "no": "9",
          "user_name": "lorem",
          "provinsi_nama": "ipsum",
          "kabupaten_nama": "dolor",
          "total": "0",
          "islulus": 1,
        },
        {
          "no": "10",
          "user_name": "lorem",
          "provinsi_nama": "ipsum",
          "kabupaten_nama": "dolor",
          "total": "0",
          "islulus": 1,
        },
        {
          "no": "11",
          "user_name": "lorem",
          "provinsi_nama": "ipsum",
          "kabupaten_nama": "dolor",
          "total": "0",
          "islulus": 1,
        },
      ].obs;
  RxList<Map<String, dynamic>> listProvinsi =
      <Map<String, dynamic>>[
        {"id": "", "nama": "Pilih Provinsi"},
      ].obs;
  RxList<Map<String, dynamic>> listKota =
      <Map<String, dynamic>>[
        {"id": "", "nama": "Pilih Kota/Kabupaten"},
      ].obs;
  RxList<Map<String, dynamic>> listJabatan =
      <Map<String, dynamic>>[
        {"id": "", "nama": "Pilih Jabatan"},
      ].obs;
  RxList<Map<String, dynamic>> listInstansi =
      <Map<String, dynamic>>[
        {"id": "", "nama": "Pilih Instansi"},
      ].obs;
  RxInt currentPage = 1.obs;
  RxInt pesertaLulus = 0.obs;
  RxInt pesertTidakLulus = 0.obs;
  RxInt rank = 0.obs;
  RxInt total = 0.obs;
  RxInt totalPage = 0.obs;
  RxString selectedInstansi = "".obs;
  RxString selectedJabatan = "".obs;
  RxString selectedPeringkat = "".obs;
  RxString selectedProvinsi = "".obs;
  RxString selectedKota = "".obs;
  @override
  void onInit() {
    super.onInit();
    initPeringkat();
    checkMaintenance();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> initPeringkat() async {
    loading['filter'] = true;
    uuid = await Get.arguments;
    await getDetailTryout();
    await getRanking();
    await getInstansi();
    await getJabatan();
    await getProvinsi();
    loading['filter'] = false;
  }

  Future<void> getDetailTryout() async {
    final response = await restClient.getData(
      url: baseUrl + apiGetDetailTryoutSaya + uuid,
    );

    final Map<String, dynamic> data = Map<String, dynamic>.from(
      response['data'],
    );
    tryoutSaya.assignAll(data);
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

  Future<void> getJabatan() async {
    final response = await restClient.getData(url: baseUrl + apiGetJabatan);
    final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      response['data'],
    );
    listJabatan.addAll(data);
  }

  Future<void> getInstansi() async {
    final response = await restClient.getData(url: baseUrl + apiGetInstansi);
    final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      response['data'],
    );
    listInstansi.addAll(data);
  }

  Future<void> getRanking() async {
    final payload = {
      "perpage": "10",
      "page": currentPage.toString(),
      "tryout_id": tryoutSaya['tryout']['uuid'].toString(),
      "search": searchController.text,
    };
    if (selectedInstansi.value != "") {
      payload['instansi_id'] = selectedInstansi.value;
    }
    if (selectedJabatan.value != "") {
      payload['jabatan_id'] = selectedJabatan.value;
    }
    if (selectedKota.value != "") {
      payload['kotakab_id'] = selectedKota.value;
    }
    if (selectedProvinsi.value != "") {
      payload['provinsi_id'] = selectedProvinsi.value;
    }

    final response = await restClient.postData(
      url: baseUrl + apiRankingTryout + uuid,
      payload: payload,
    );

    print("payload: ${payload}");
    final List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      response['data']['data'],
    );
    listPeringkat.assignAll(data);
    total.value = response['total_filtered'];
    rank.value = response['rank'];
    pesertaLulus.value = response['peserta_lulus'];
    pesertTidakLulus.value = response['peserta_tidak_lulus'];
    totalPage.value =
        (response['data']['total'] / response['data']['per_page']).floor();
  }

  Future<void> checkMaintenance() async {
    final response = await restClient.getData(
      url: baseUrl + apiCheckMaintenance,
    );
    if (response['is_maintenance']) {
      Get.offAllNamed("/maintenance");
    }
  }
}
