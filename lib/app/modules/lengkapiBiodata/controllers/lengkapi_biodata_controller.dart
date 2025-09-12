import 'package:dio/dio.dart' as dio;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';
import 'package:intl/intl.dart';
import 'package:file_selector/file_selector.dart';

class LengkapiBiodataController extends GetxController {
  final _restClient = RestClient();
  var box = GetStorage();
  // TextEditingController untuk inputan text
  final namaLengkapController = TextEditingController();
  final emailController = TextEditingController();
  final hpController = TextEditingController();
  final waController = TextEditingController();
  final kabupatenController = TextEditingController();
  final pendidikanController = TextEditingController();
  RxString fotoProfile = "".obs;
  RxString newProfile = "".obs;
  // Rx untuk dropdown / date
  var tanggalLahir = ''.obs;
  var jenisKelamin = ''.obs;
  RxString provinsi = ''.obs;
  var sumberInfo = ''.obs;
  RxString referensi = ''.obs;
  RxString sosmed = ''.obs;
  RxInt referensiId = 0.obs;
  RxInt sosmedId = 0.obs;
  RxInt provinsiId = 0.obs;
  RxInt kabupatenId = 0.obs;
  RxInt pendidikanId = 0.obs;
  RxList provinceData = [].obs;
  RxList pendidikanData = [].obs;
  RxList referensiData = [].obs;
  RxList kabupatenData = [].obs;
  RxList sosmedData = [].obs;
  RxBool isLoading = false.obs;
  @override
  void onInit() {
    getUser();
    getSosmed();
    getProvince();
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

  void simpanData() {
    postProfile();
  }

  Future<void> pickFile() async {
    final XFile? file = await openFile(
      acceptedTypeGroups: [
        XTypeGroup(label: 'images', extensions: ['jpg', 'jpeg', 'png']),
      ],
    );

    if (file != null) {
      newProfile.value = file.path; // ganti fotoProfile di tampilan sementara
    }
  }

  Future<void> getUser() async {
    final url = await baseUrl + apiGetUser;
    print("emailnnyaa ${box.read('token')}");
    final result = await _restClient.getData(url: url);

    if (result["status"] == "success") {
      var data = result['data'];
      namaLengkapController.text = data['name'];
      emailController.text = data['email'];
      await getPendidikan(id: data['pendidikan_id'].toString());
      await getRreferensi(id: data['referensi_id'].toString());
    } else {
      print("Error polling email verificationx: $result");
    }
  }

  Future<void> postProfile() async {
    String? errorMessage;
    isLoading.value = true;
    // urut sesuai form di gambar
    if (newProfile.isEmpty) {
      errorMessage = "Foto profil harus diisi.";
    } else if (namaLengkapController.text.isEmpty) {
      errorMessage = "Nama lengkap harus diisi.";
    } else if (emailController.text.isEmpty) {
      errorMessage = "Email harus diisi.";
    } else if (!isValidEmail(emailController.text)) {
      errorMessage = "Format email tidak valid.";
    } else if (hpController.text.isEmpty) {
      errorMessage = "Nomor HP harus diisi.";
    } else if (!isValidPhone(hpController.text, minLength: 10)) {
      errorMessage = "Nomor HP minimal 10 digit.";
    } else if (waController.text.isEmpty) {
      errorMessage = "Nomor WhatsApp harus diisi.";
    } else if (!isValidPhone(waController.text, minLength: 10)) {
      errorMessage = "Nomor WhatsApp minimal 10 digit.";
    } else if (tanggalLahir.value.isEmpty) {
      errorMessage = "Tanggal lahir harus diisi.";
    } else if (jenisKelamin.value.isEmpty) {
      errorMessage = "Jenis kelamin harus dipilih.";
    } else if (provinsiId.value == 0) {
      errorMessage = "Silakan pilih provinsi.";
    } else if (kabupatenId.value == 0) {
      errorMessage = "Silakan pilih kabupaten/kota.";
    } else if (pendidikanId.value == 0) {
      errorMessage = "Silakan pilih pendidikan.";
    } else if (sosmedId.value == 0) {
      errorMessage = "Silakan pilih sumber informasi IDCPNS.";
    } else if (referensiId.value == 0) {
      errorMessage = "Silakan pilih referensi.";
    }

    if (errorMessage != null) {
      showSnackbar("Gagal", errorMessage);
      return;
    }

    try {
      final url = baseUrl + apiGetUser;

      final formData = dio.FormData.fromMap({
        "foto": await dio.MultipartFile.fromFile(
          newProfile.value,
          filename: "profile.jpg",
        ),
        "name": namaLengkapController.text,
        "email": emailController.text,
        "no_hp": hpController.text,
        "no_wa": waController.text,
        "provinsi_id": provinsiId.value,
        "kotakab_id": kabupatenId.value,
        "menu_category_id": referensiId.value,
        "pendidikan_id": pendidikanId.value,
        "referensi_id": sosmedId.value,
        "tanggal_lahir": DateFormat(
          "yyyy-MM-dd",
        ).format(DateTime.parse(tanggalLahir.value)),
        "jenis_kelamin": jenisKelamin.value,
      });

      print("xxx $formData");
      final result = await _restClient.postData(url: url, payload: formData);
      print("response ${result.toString()}");

      if (result["status"] == "success") {
        Get.snackbar(
          "Berhasil",
          "Biodata berhasil disimpan.",
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.TOP,
          duration: Duration(seconds: 2),
        );

        // kasih delay sedikit biar snackbar sempat tampil
        await Future.delayed(Duration(milliseconds: 500));
        Get.offNamed(Routes.HOME, arguments: {'initialIndex': 0});
      }
    } catch (e) {
      print("Error post profile: $e");
    } finally {
      isLoading.value = false;
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
            pendidikanController.text = match['pendidikan'] ?? '';
          }
        }
      }
    } catch (e) {}
  }

  Future<void> getSosmed({String? id}) async {
    try {
      final url = await baseUrl + apiGetReference;

      final result = await _restClient.getData(url: url);

      if (result["status"] == "success") {
        var data = result['data'];
        sosmedData.value = data;

        // Kalau ada id, cari data yg sesuai
        if (id != null) {
          final found = data.firstWhere(
            (item) => item['id'].toString() == id,
            orElse: () => null,
          );

          if (found != null) {
            // preferensiBelajar.value = found['nama'] ?? "";
            sosmed.value = found['nama'] ?? "";
          }
        }
      }
    } catch (e) {
      print("Error getRreferensi: $e");
    }
  }

  Future<void> getRreferensi({String? id}) async {
    try {
      final url = await baseUrl + apiGetKategori;

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

  Future<void> getProvince() async {
    try {
      final url = baseUrl + apiGetProvince;
      final result = await _restClient.getData(url: url);
      print("Result Province: ${result.toString()}");

      if (result["status"] == "success") {
        var data = result['data'];
        provinceData.value = data;

        // Reset provinsi.value dulu
        // provinsi.value = "";
        //
        // if (id != null) {
        //   final found = data.firstWhere(
        //     (item) => item['id'].toString() == id,
        //     orElse: () => null,
        //   );
        //
        //   if (found != null) {
        //     provinsi.value = found['nama'] ?? "";
        //   }
        //   // kalau id user tidak ditemukan, provinsi.value tetap "", tapi data lengkap tetap tampil
        // }
      }
    } catch (e) {
      print("Error getProvince: $e");
    }
  }

  Future<void> getKabupaten({required id, int? selectedId}) async {
    try {
      final url = baseUrl + apiGetKabup + "/" + id.toString();
      final result = await _restClient.getData(url: url);

      if (result["status"] == "success") {
        var data = result['data'];
        kabupatenData.value = data;

        if (selectedId != null) {
          kabupatenId.value = selectedId; // set value setelah data ada
          print("xxc ${kabupatenId.value = selectedId}");
        }
      }
    } catch (e) {
      print("Error getKabupaten: $e");
    }
  }

  Map<String, String> jenisKelaminMap = {"L": "Laki-laki", "P": "Perempuan"};
}

void showSnackbar(String title, String message, {bool success = false}) {
  Get.snackbar(
    title,
    message,
    backgroundColor: success ? Colors.green : Colors.red,
    colorText: Colors.white,
    snackPosition: SnackPosition.TOP,
  );
}

// 🔧 Regex email validator sederhana
bool isValidEmail(String email) {
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return emailRegex.hasMatch(email);
}

// 🔧 Minimal digit nomor telepon (misal 10)
bool isValidPhone(String phone, {int minLength = 10}) {
  return phone.isNotEmpty && phone.length >= minLength;
}
