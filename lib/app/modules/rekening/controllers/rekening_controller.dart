import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class RekeningController extends GetxController {
  var selectedBank = ''.obs;
  var bankList = [
    'Bank Mandiri',
    'Bank Rakyat Indonesia',
    'Bank BCA',
    'Bank BNI',
  ];
  var accountNumberController = TextEditingController();
  var ownerNameController = TextEditingController();
  final List<String> informationPoints = [
    'Pastikan data yang kamu masukkan sudah benar.',
    'Data yang telah ditambahkan tidak dapat diubah.',
    'Maksimal 3 rekening yang bisa ditambahkan.',
    'Kegagalan penarikan komisi karena kesalahan data bukan tanggung jawab kami.',
  ];
  final count = 0.obs;
  @override
  void onInit() {
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
  void saveAccount() {
    if (selectedBank.isNotEmpty &&
        accountNumberController.text.isNotEmpty &&
        ownerNameController.text.isNotEmpty) {
      savedAccounts.add({
        'bank': selectedBank.value,
        'number': accountNumberController.text,
        'owner': ownerNameController.text,
      });
      accountNumberController.clear();
      ownerNameController.clear();
      selectedBank.value = '';
    }
  }
}
