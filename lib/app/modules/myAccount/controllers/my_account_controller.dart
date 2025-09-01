import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class MyAccountController extends GetxController {
  final _restClient = RestClient();

  // TextEditingController untuk inputan text
  final namaLengkapController = TextEditingController();
  final emailController = TextEditingController();
  final hpController = TextEditingController();
  final waController = TextEditingController();
  final kabupatenController = TextEditingController();
  final pendidikanController = TextEditingController();

  // Rx untuk dropdown / date
  var tanggalLahir = ''.obs;
  var jenisKelamin = ''.obs;
  var provinsi = ''.obs;
  var sumberInfo = ''.obs;
  var preferensiBelajar = ''.obs;

  @override
  void onInit() {
    getUser();
    super.onInit();
  }

  @override
  void onClose() {
    // Jangan lupa dispose controller
    namaLengkapController.dispose();
    emailController.dispose();
    hpController.dispose();
    waController.dispose();
    kabupatenController.dispose();
    pendidikanController.dispose();
    super.onClose();
  }

  // nanti buat function ambil data API
  void loadDataDariApi() async {
    // contoh isi value dari API
    namaLengkapController.text = "Nama dari API";
    emailController.text = "email@email.com";
    hpController.text = "08123456789";
    waController.text = "08123456789";
    kabupatenController.text = "Bandung";
    pendidikanController.text = "S1";

    tanggalLahir.value = "1998-01-01";
    jenisKelamin.value = "Laki-laki";
    provinsi.value = "JAWA BARAT";
    sumberInfo.value = "Instagram";
    preferensiBelajar.value = "CPNS";
  }

  void simpanData() {
    // contoh simpan ke API
    print("Nama Lengkap: ${namaLengkapController.text}");
    print("Email: ${emailController.text}");
    print("Nomor HP: ${hpController.text}");
    print("Nomor WA: ${waController.text}");
    print("Kabupaten: ${kabupatenController.text}");
    print("Pendidikan: ${pendidikanController.text}");
    print("Tanggal Lahir: ${tanggalLahir.value}");
    print("Jenis Kelamin: ${jenisKelamin.value}");
    print("Provinsi: ${provinsi.value}");
    print("Darimana tahu: ${sumberInfo.value}");
    print("Preferensi: ${preferensiBelajar.value}");
  }

  Future<void> getUser() async {
    try {
      final url = await baseUrl + apiGetUser;

      final result = await _restClient.getData(url: url);
      print("emailnnyaa ${result.toString()}");
      if (result["status"] == "success") {
        var data = result['data'];
        namaLengkapController.text = data['name'];
        emailController.text = data['email'];
        hpController.text = data["no_hp"];
        waController.text = data["no_wa"];
        kabupatenController.text = "Bandung";
        pendidikanController.text = "S1";

        tanggalLahir.value = data["tanggal_lahir"];
        jenisKelamin.value = data["jenis_kelamin"];
        provinsi.value = "JAWA BARAT";
        sumberInfo.value = "Instagram";
        preferensiBelajar.value = "CPNS";
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }
}
