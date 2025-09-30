import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';

import '../controllers/lengkapi_biodata_controller.dart';

class LengkapiBiodataView extends GetView<LengkapiBiodataController> {
  const LengkapiBiodataView({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.white,

        body: SafeArea(
          child: Obx(() {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Data Diri",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Obx(() {
                          ImageProvider image;
                          if (controller.newProfile.value.isNotEmpty) {
                            image = FileImage(
                              File(controller.newProfile.value),
                            );
                          } else if (controller.fotoProfile.value.isNotEmpty) {
                            image = NetworkImage(controller.fotoProfile.value);
                          } else {
                            image = AssetImage("assets/profileDefault.jpeg");
                          }

                          return CircleAvatar(
                            radius: 50,
                            backgroundImage: image,
                          );
                        }),
                        SizedBox(height: 8),
                        Text(
                          "Max 5mb",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        OutlinedButton(
                          onPressed: () => controller.pickFile(),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.teal),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                5,
                              ), // radius 5
                            ),
                          ),
                          child: Text(
                            "Pilih Foto",
                            style: TextStyle(color: Colors.teal),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                    // Nama Lengkap
                    TextField(
                      controller: controller.namaLengkapController,
                      decoration: InputDecoration(
                        labelText: "Nama Lengkap",
                        border: OutlineInputBorder(),
                        isDense: true,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    SizedBox(height: 30),

                    // Email
                    TextField(
                      controller: controller.emailController,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                        isDense: true,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    SizedBox(height: 30),

                    // Nomor HP
                    TextField(
                      controller: controller.hpController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(13),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        labelText: "Nomor HP",
                        border: OutlineInputBorder(),
                        isDense: true,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    SizedBox(height: 30),

                    TextField(
                      controller: controller.waController,
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(13),
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                      decoration: InputDecoration(
                        labelText: "Nomor WhatsApp",
                        border: OutlineInputBorder(),
                        isDense: true,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    SizedBox(height: 30),

                    // Tanggal Lahir
                    TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Tanggal Lahir",
                        hintText:
                            controller.tanggalLahir.value.isEmpty
                                ? "Pilih tanggal"
                                : controller.tanggalLahir.value,
                        border: OutlineInputBorder(),
                        isDense: true,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime(2000),
                          firstDate: DateTime(1950),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          controller.tanggalLahir.value =
                              picked.toIso8601String().split("T")[0];
                        }
                      },
                    ),
                    SizedBox(height: 30),

                    // Jenis Kelamin
                    DropdownSearch<String>(
                      items: (String? filter, LoadProps? props) {
                        return controller.jenisKelaminMap.keys.toList();
                      },
                      selectedItem:
                          controller.jenisKelamin.value.isEmpty
                              ? null
                              : controller.jenisKelamin.value,
                      itemAsString: (String kode) {
                        return controller.jenisKelaminMap[kode] ?? '';
                      },
                      popupProps: PopupProps.dialog(
                        showSearchBox: false, // tanpa search box
                        fit: FlexFit.loose,
                        dialogProps: DialogProps(
                          backgroundColor: Colors.white, // putih bersih
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              12,
                            ), // biar cantik
                          ),
                        ),
                      ),
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                          labelText: "Jenis Kelamin",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          isDense: true,
                        ),
                      ),
                      onChanged: (value) {
                        controller.jenisKelamin.value = value ?? '';
                      },
                    ),
                    SizedBox(height: 30),

                    // Provinsi & Kabupaten (dependent)
                    Column(
                      children: [
                        DropdownSearch<int>(
                          items: (String? filter, LoadProps? props) {
                            return controller.provinceData
                                .map<int>((data) => data['id'] as int)
                                .toList();
                          },
                          selectedItem:
                              controller.provinsiId.value == 0
                                  ? null
                                  : controller.provinsiId.value,
                          itemAsString: (int id) {
                            final prov = controller.provinceData.firstWhere(
                              (data) => data['id'] == id,
                              orElse: () => {'nama': ''},
                            );
                            return prov['nama'].toString();
                          },
                          popupProps: PopupProps.dialog(
                            showSearchBox:
                                true, // provinsi banyak, jadi butuh search
                            fit: FlexFit.loose,
                            dialogProps: DialogProps(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  12,
                                ), // biar manis
                              ),
                            ),
                          ),
                          decoratorProps: DropDownDecoratorProps(
                            decoration: InputDecoration(
                              labelText: "Provinsi",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              isDense: true,
                            ),
                          ),
                          onChanged: (value) {
                            if (value != null) {
                              controller.provinsiId.value = value;

                              controller.kabupatenId.value = 0;
                              controller.kabupatenData.clear();

                              controller.getKabupaten(id: value);
                            }
                          },
                        ),
                        SizedBox(height: 30),
                        DropdownSearch<int>(
                          items: (String? filter, LoadProps? props) {
                            return controller.kabupatenData
                                .map<int>((data) => data['id'] as int)
                                .toList();
                          },
                          selectedItem:
                              controller.kabupatenId.value == 0
                                  ? null
                                  : controller.kabupatenId.value,
                          itemAsString: (int id) {
                            final kab = controller.kabupatenData.firstWhere(
                              (data) => data['id'] == id,
                              orElse: () => {'nama': ''},
                            );
                            return kab['nama'].toString();
                          },
                          popupProps: PopupProps.dialog(
                            showSearchBox:
                                true, // kabupaten juga banyak, jadi enable search
                            fit: FlexFit.loose,
                            dialogProps: DialogProps(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          decoratorProps: DropDownDecoratorProps(
                            decoration: InputDecoration(
                              labelText: "Kabupaten",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              isDense: true,
                            ),
                          ),
                          onChanged:
                              controller.kabupatenData.isNotEmpty
                                  ? (value) =>
                                      controller.kabupatenId.value = value ?? 0
                                  : null,
                        ),
                      ],
                    ),
                    SizedBox(height: 30),

                    // Pendidikan
                    // Pendidikan
                    // Pendidikan
                    DropdownSearch<int>(
                      items: (String? filter, LoadProps? props) {
                        return controller.pendidikanData
                            .map<int>((data) => data['id'] as int)
                            .toList();
                      },
                      selectedItem:
                          controller.pendidikanId.value == 0
                              ? null
                              : controller.pendidikanId.value,
                      itemAsString: (int id) {
                        final item = controller.pendidikanData.firstWhere(
                          (data) => data['id'] == id,
                          orElse: () => {'pendidikan': ''},
                        );
                        return item['pendidikan'].toString();
                      },
                      popupProps: PopupProps.dialog(
                        showSearchBox:
                            true, // search akan tampil di dalam dialog popup (tengah layar)
                        fit: FlexFit.loose,
                        dialogProps: DialogProps(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        searchFieldProps: TextFieldProps(
                          textAlign: TextAlign.center, // teks search di tengah
                          decoration: InputDecoration(
                            hintText: "Cari Pendidikan...",
                            hintStyle: TextStyle(color: Colors.grey),
                            contentPadding: EdgeInsets.symmetric(vertical: 10),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                          labelText: "Pendidikan",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          isDense: true,
                        ),
                      ),
                      onChanged: (value) {
                        controller.pendidikanId.value = value ?? 0;
                      },
                    ),
                    SizedBox(height: 30),

                    // Sosmed
                    DropdownSearch<int>(
                      items: (String? filter, LoadProps? props) {
                        return controller.sosmedData
                            .map<int>((data) => data['id'] as int)
                            .toList();
                      },
                      selectedItem:
                          controller.sosmedId.value == 0
                              ? null
                              : controller.sosmedId.value,
                      itemAsString: (int id) {
                        final item = controller.sosmedData.firstWhere(
                          (data) => data['id'] == id,
                          orElse: () => {'referensi': ''},
                        );
                        return item['referensi'].toString();
                      },
                      popupProps: PopupProps.dialog(
                        showSearchBox: false, // Sosmed ga usah pake search
                        fit: FlexFit.loose,
                        dialogProps: DialogProps(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              12,
                            ), // biar manis
                          ),
                        ),
                      ),
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                          labelText: "Darimana Anda Mengetahui IDCPNS",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          isDense: true,
                        ),
                      ),
                      onChanged: (value) {
                        controller.sosmedId.value = value ?? 0;
                      },
                    ),
                    SizedBox(height: 30),

                    // Preferensi Belajar
                    DropdownSearch<int>(
                      items: (String? filter, LoadProps? props) {
                        return controller.referensiData
                            .map<int>((data) => data['id'] as int)
                            .toList();
                      },
                      selectedItem:
                          controller.referensiId.value == 0
                              ? null
                              : controller.referensiId.value,
                      itemAsString: (int id) {
                        final item = controller.referensiData.firstWhere(
                          (data) => data['id'] == id,
                          orElse: () => {'menu': ''},
                        );
                        return item['menu'].toString();
                      },
                      popupProps: PopupProps.dialog(
                        showSearchBox: false, // ga perlu search
                        fit: FlexFit.loose,
                        dialogProps: DialogProps(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                          labelText: "Preferensi Belajar",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                          ),
                          isDense: true,
                        ),
                      ),
                      onChanged: (value) {
                        controller.referensiId.value = value ?? 0;
                      },
                    ),

                    SizedBox(height: 20),
                    // Tombol Simpan
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed:
                                controller.isLoading.value
                                    ? null // tombol disable kalau loading
                                    : () {
                                      Get.defaultDialog(
                                        title: "Konfirmasi",
                                        middleText: "Apakah Anda ingin keluar?",
                                        backgroundColor: Colors.white,
                                        titleStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                        middleTextStyle: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 16,
                                        ),
                                        radius: 12,
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Get.back();
                                            },
                                            child: Text(
                                              "Batal",
                                              style: TextStyle(
                                                color: Colors.grey[700],
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              final box = GetStorage();
                                              final GoogleSignIn googleSignIn =
                                                  GoogleSignIn(
                                                    scopes: ['email'],
                                                  );
                                              googleSignIn
                                                  .disconnect(); // reset session supaya akun tidak otomatis dipilih
                                              googleSignIn
                                                  .signOut(); // logout dari akun
                                              box.erase();
                                              Get.offAllNamed(Routes.LOGIN);
                                              Get.back();
                                            },
                                            child: Text(
                                              "Keluar",
                                              style: TextStyle(
                                                color: Colors.redAccent,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  controller.isLoading.value
                                      ? Colors.grey
                                      : Colors.red,
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child:
                                controller.isLoading.value
                                    ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : Text(
                                      "Keluar",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          child: ElevatedButton(
                            onPressed:
                                controller.isLoading.value
                                    ? null
                                    : controller.simpanData,
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  controller.isLoading.value
                                      ? Colors.grey
                                      : Colors.teal,
                              padding: EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child:
                                controller.isLoading.value
                                    ? SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                    : Text(
                                      "Simpan",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
