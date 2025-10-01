import 'package:dio/dio.dart' as dio;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/notifCostume.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/modules/lengkapiBiodata/controllers/lengkapi_biodata_controller.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:intl/intl.dart';
import 'package:file_selector/file_selector.dart';
import 'package:image_cropper/image_cropper.dart';

class MyAccountController extends GetxController {
  final _restClient = RestClient();

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
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    getUser();
    getPendidikan();
    getRreferensi();
    getSosmed();
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

  // nanti buat function ambil data API7
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
      // buka cropper setelah file dipilih
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1), // kotak
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Edit Foto',
            toolbarColor: Colors.teal,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true, // biar fix kotak
          ),
          IOSUiSettings(title: 'Edit Foto', aspectRatioLockEnabled: true),
        ],
      );

      if (croppedFile != null) {
        newProfile.value = croppedFile.path; // simpan hasil crop
      }
    }
  }

  Future<void> getUser() async {
    int toInt(Object? v) => v is int ? v : int.tryParse('${v ?? ''}') ?? 0;
    isLoading.value = true;
    try {
      final url = baseUrl + apiGetUser;
      final result = await _restClient.getData(url: url);

      if (result is! Map || result['status'] != 'success') {
        return;
      }

      final data = result['data'] as Map<String, dynamic>?;
      if (data == null) return;
      final mc = data['menu_category'];
      namaLengkapController.text = (data['name'] ?? '').toString();
      emailController.text = (data['email'] ?? '').toString();
      hpController.text = (data['no_hp'] ?? '').toString();
      waController.text = (data['no_wa'] ?? '').toString();
      kabupatenController.text = "Bandung";

      tanggalLahir.value = (data['tanggal_lahir'] ?? '').toString();
      jenisKelamin.value = (data['jenis_kelamin'] ?? '').toString();
      pendidikanId.value = toInt(data['pendidikan_id']);
      sosmedId.value = toInt(data['referensi_id']);
      referensiId.value = mc is Map ? toInt(mc['id']) : 0;
      fotoProfile.value = data['profile_image_url'] ?? "";

      provinsiId.value = toInt(data['provinsi_id']);
      print("xxxvvv ${provinsiId.toString()}");
      kabupatenId.value = toInt(data['kotakab_id']);

      if (pendidikanId.value != 0) {
        await getPendidikan(id: pendidikanId.value.toString());
      }
      if (sosmedId.value != 0) {
        await getRreferensi(id: sosmedId.value.toString());
      }
      if (provinsiId.value != 0) {
        await getProvince(id: provinsiId.value.toString());
        await getKabupaten(
          id: provinsiId.value.toString(),
          selectedId: kabupatenId.value,
        );
      }
    } catch (_) {}
    isLoading.value = false;
  }

  Future<void> postProfile() async {
    String? errorMessage;
    if (namaLengkapController.text.isEmpty) {
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
      notifHelper.show(errorMessage, type: 0);
      return;
    }
    final url = baseUrl + apiGetUser;

    // Cek apakah ada foto baru
    final foto =
        (newProfile.value.isNotEmpty)
            ? await dio.MultipartFile.fromFile(
              newProfile.value,
              filename: "profile.jpg",
            )
            : null;

    final formData = dio.FormData.fromMap({
      if (foto != null)
        "foto": foto
      else
        "foto": fotoProfile.value, // pakai foto lama
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

    final result = await _restClient.postData(url: url, payload: formData);

    if (result["status"] == "success") {
      getUser();
      notifHelper.show("Profil berhasil diperbarui", type: 1);
    } else {
      notifHelper.show(result["message"] ?? "Terjadi kesalahan", type: 0);
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

  Future<void> getProvince({String? id}) async {
    try {
      final url = baseUrl + apiGetProvince;
      final result = await _restClient.getData(url: url);
      print("Result Province: ${result.toString()}");

      if (result["status"] == "success") {
        var data = result['data'];
        provinceData.value = data;

        // Reset provinsi.value dulu
        provinsi.value = "";

        if (id != null) {
          final found = data.firstWhere(
            (item) => item['id'].toString() == id,
            orElse: () => null,
          );

          if (found != null) {
            provinsi.value = found['nama'] ?? "";
          }
          // kalau id user tidak ditemukan, provinsi.value tetap "", tapi data lengkap tetap tampil
        }
      }
    } catch (e) {
      print("Error getProvince: $e");
    }
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

bool isValidEmail(String email) {
  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  return emailRegex.hasMatch(email);
}

// 🔧 Minimal digit nomor telepon (misal 10)
bool isValidPhone(String phone, {int minLength = 10}) {
  return phone.isNotEmpty && phone.length >= minLength;
}
