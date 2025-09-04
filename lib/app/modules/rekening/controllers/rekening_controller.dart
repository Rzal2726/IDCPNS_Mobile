import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class RekeningController extends GetxController {
  final _restClient = RestClient();
  var selectedBank = ''.obs;
  RxList rekeningUserData = [].obs;
  var bankList = [
    'Bank Mandiri',
    'Bank Rakyat Indonesia',
    'Bank BCA',
    'Bank BNI',
  ];
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
    // if (selectedBank.isNotEmpty &&
    //     accountNumberController.text.isNotEmpty &&
    //     ownerNameController.text.isNotEmpty) {
    //   savedAccounts.add({
    //     'bank': selectedBank.value,
    //     'number': accountNumberController.text,
    //     'owner': ownerNameController.text,
    //   });
    //
    // }

    try {
      final url = await baseUrl + apiAddRekening;

      var payload = {
        "bank": 1,
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
    accountNumberController.clear();
    ownerNameController.clear();
    selectedBank.value = '';
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
}
