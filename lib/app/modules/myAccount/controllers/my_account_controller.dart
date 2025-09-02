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
  RxString referensi = ''.obs;
  RxList provinceData = [].obs;
  RxList pendidikanData = [].obs;
  RxList kabupData = [].obs;
  RxList referensiData = [].obs;

  @override
  void onInit() {
    getUser();
    getPendidikan();
    getProvince();
    getRreferensi();
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
        await getPendidikan(id: data['pendidikan_id'].toString());
        await getRreferensi(id: data['referensi_id'].toString());
        await getProvince(id: data['provinsi_id'].toString());

        tanggalLahir.value = data["tanggal_lahir"];
        jenisKelamin.value = data["jenis_kelamin"];
        sumberInfo.value = "Instagram";
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }

  Future<void> getPendidikan({String? id}) async {
    try {
      final url = await baseUrl + apiGetPendidikan;

      final result = await _restClient.getData(url: url);
      if (result["status"] == "success") {
        var data = result['data'];

        pendidikanData.value = data;

        // Kalau id dikirim, cari data yang sesuai
        if (id != null && id.isNotEmpty) {
          final match = data.firstWhere(
            (item) => item['id'].toString() == id,
            orElse: () => null,
          );

          if (match != null) {
            print("sadasd ${match.toString()}");
            pendidikanController.text = match['pendidikan'] ?? '';
          }
        }
      }
    } catch (e) {
      print("xx verification: $e");
    }
  }

  Future<void> getProvince({String? id}) async {
    try {
      final url = await baseUrl + apiGetProvince;

      final result = await _restClient.getData(url: url);
      print("Result Province: ${result.toString()}");

      if (result["status"] == "success") {
        var data = result['data'];
        provinceData.value = data;

        // Kalau ada id, cari data yg sesuai
        if (id != null) {
          final found = data.firstWhere(
            (item) => item['id'].toString() == id,
            orElse: () => null,
          );

          if (found != null) {
            provinsi.value = found['nama'] ?? "";
          }
        }
      }
    } catch (e) {
      print("Error getProvince: $e");
    }
  }

  Future<void> getRreferensi({String? id}) async {
    try {
      final url = await baseUrl + apiGetReference;

      final result = await _restClient.getData(url: url);
      print("Result Referensi: ${result.toString()}");

      if (result["status"] == "success") {
        var data = result['data'];
        referensiData.value = data;

        // Kalau ada id, cari data yg sesuai
        if (id != null) {
          final found = data.firstWhere(
            (item) => item['id'].toString() == id,
            orElse: () => null,
          );

          if (found != null) {
            // preferensiBelajar.value = found['nama'] ?? "";
            referensi.value = found['nama'] ?? "";
          }
        }
      }
    } catch (e) {
      print("Error getRreferensi: $e");
    }
  }

  Future<void> getKabupaten({required id}) async {
    try {
      final url = await baseUrl + apiGetKabup + "/" + id;

      final result = await _restClient.getData(url: url);
      if (result["status"] == "success") {
        var data = result['data'];
        kabupData.value = data;
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }

  Map<String, String> jenisKelaminMap = {"L": "Laki-laki", "P": "Perempuan"};
}
