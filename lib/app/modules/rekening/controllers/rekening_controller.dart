import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class RekeningController extends GetxController {
  final _restClient = RestClient();
  var selectedBank = ''.obs;
  RxList rekeningUserData = [].obs;
  RxList<Map<String, dynamic>> bankList = <Map<String, dynamic>>[].obs;
  RxString selectedBankName = ''.obs; // untuk menampilkan nama di dropdown
  RxInt bankId = 0.obs; // untuk simpan id bank yang dipilih
  final accountNumberController = TextEditingController();
  final ownerNameController = TextEditingController();
  final List<String> informationPoints = [
    'Pastikan data yang kamu masukkan sudah benar.',
    'Data yang telah ditambahkan tidak dapat diubah.',
    'Maksimal 3 rekening yang bisa ditambahkan.',
    'Kegagalan penarikan komisi karena kesalahan data bukan tanggung jawab kami.',
  ];
  final count = 0.obs;
  @override
  void onInit() {
    getRekeningUser();
    getBank();
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

  var savedAccounts =
      [
        {
          'bank': 'Bank Mandiri',
          'number': '127371241',
          'owner': 'MUHAMMAD FARIS RAFI',
        },
        {
          'bank': 'Bank Rakyat Indonesia',
          'number': '127371241',
          'owner': 'MUHAMMAD FARIS RAFI',
        },
      ].obs;
  void saveAccount() async {
    try {
      final url = await baseUrl + apiAddRekening;

      var payload = {
        "bank": bankId.value, // ambil dari RxInt bankId
        "nama_pemilik": ownerNameController.text,
        "no_rekening": int.parse(accountNumberController.text),
      };
      print("payy ${payload}");
      final result = await _restClient.postData(url: url, payload: payload);
      if (result["status"] == "success") {
        Get.snackbar("berhasil", "data berhasil");
        getRekeningUser();
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }

    // Reset semua field
    accountNumberController.clear();
    ownerNameController.clear();
    selectedBank.value = '';
    bankId.value = 0;
  }

  Future<void> getRekeningUser() async {
    try {
      final url = await baseUrl + apiGetRekeningUser;

      final result = await _restClient.getData(url: url);
      if (result["status"] == "success") {
        rekeningUserData.value = result['data'];
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }

  Future<void> getBank() async {
    try {
      final url = baseUrl + apiGetBank;
      final result = await _restClient.getData(url: url);

      if (result["status"] == "success") {
        // map data ke format id + name
        bankList.value =
            (result['data'] as List)
                .map(
                  (e) => {
                    'id': e['id'], // id bank
                    'name': e['name'], // nama bank
                  },
                )
                .toList();
        print("xxx ${bankList.toString()}");
      }
    } catch (e) {
      print("Error getBank: $e");
    }
  }
}
