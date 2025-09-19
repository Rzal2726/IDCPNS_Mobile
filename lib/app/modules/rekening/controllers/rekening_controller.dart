import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    // Validasi Pilihan Bank
    if (bankId.value == 0) {
      Get.snackbar(
        "Gagal",
        "Silakan pilih bank",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }
    // Validasi Nomor Rekening
    if (accountNumberController.text.isEmpty) {
      Get.snackbar(
        "Gagal",
        "Nomor rekening harus diisi",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }
    // Validasi Nama Pemilik
    if (ownerNameController.text.isEmpty) {
      Get.snackbar(
        "Gagal",
        "Nama pemilik harus diisi",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    try {
      final url = await baseUrl + apiAddRekening;

      var payload = {
        "bank": bankId.value,
        "nama_pemilik": ownerNameController.text,
        "no_rekening": int.parse(accountNumberController.text),
      };
      print("Payload: $payload");

      final result = await _restClient.postData(url: url, payload: payload);

      if (result["status"] == "success") {
        Get.snackbar(
          "Berhasil",
          "Data berhasil disimpan",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.teal,
          colorText: Colors.white,
          margin: EdgeInsets.all(10),
        );
        getRekeningUser(); // refresh data rekening
      } else {
        Get.snackbar(
          "Gagal",
          result["message"] ?? "Terjadi kesalahan",
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      print("Error save account: $e");
      Get.snackbar(
        "Gagal",
        "Terjadi kesalahan saat menyimpan data",
        snackPosition: SnackPosition.TOP,
      );
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
