import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:idcpns_mobile/app/Components/widgets/exitDialog.dart';
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
                          fontSize: 18,
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
                        hintText: "Masukan Nama lengkap",
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
                        hintText: "Masukan email",
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
                        // return key "L" / "P"
                        return controller.jenisKelaminMap.keys.toList();
                      },
                      selectedItem:
                          controller.jenisKelamin.value.isEmpty
                              ? null
                              : controller.jenisKelamin.value,
                      itemAsString: (String kode) {
                        // tampilkan value map (Laki-laki / Perempuan)
                        return controller.jenisKelaminMap[kode] ?? '';
                      },
                      popupProps: PopupProps.dialog(
                        showSearchBox:
                            false, // ga perlu search box, datanya dikit
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
                          labelText: "Jenis Kelamin",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
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
                        Obx(
                          () => DropdownSearch<int>(
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
                              showSearchBox: true,
                              searchFieldProps: TextFieldProps(
                                cursorColor: Colors.blue,
                                decoration: const InputDecoration(
                                  hintText: "Cari provinsi...",
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 12,
                                  ),
                                ),
                              ),
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
                                labelText: "Provinsi",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
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
                        ),
                        SizedBox(height: 30),
                        Obx(
                          () => DropdownSearch<int>(
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
                              showSearchBox: true, // aktifkan search box
                              searchFieldProps: TextFieldProps(
                                cursorColor: Colors.blue,
                                decoration: const InputDecoration(
                                  hintText: "Cari kabupaten...",
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 12,
                                  ),
                                ),
                              ),
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
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                isDense: true,
                              ),
                            ),
                            onChanged: (value) {
                              controller.kabupatenId.value = value ?? 0;
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30),
                    DropdownSearch<int>(
                      items: (String? filter, LoadProps? props) {
                        // return list id pendidikan
                        return controller.pendidikanData
                            .map<int>((data) => data['id'] as int)
                            .toList();
                      },
                      selectedItem:
                          controller.pendidikanId.value == 0
                              ? null
                              : controller.pendidikanId.value,
                      itemAsString: (int id) {
                        // tampilkan nama pendidikan sesuai id
                        final item = controller.pendidikanData.firstWhere(
                          (data) => data['id'] == id,
                          orElse: () => {'pendidikan': ''},
                        );
                        return item['pendidikan'].toString();
                      },
                      popupProps: PopupProps.dialog(
                        showSearchBox: true, // bisa cari pendidikan
                        searchFieldProps: TextFieldProps(
                          decoration: InputDecoration(
                            labelText: 'Cari Pendidikan',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                        dialogProps: DialogProps(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      decoratorProps: DropDownDecoratorProps(
                        decoration: InputDecoration(
                          labelText: "Pendidikan",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
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
                        // return list id sosmed
                        return controller.sosmedData
                            .map<int>((data) => data['id'] as int)
                            .toList();
                      },
                      selectedItem:
                          controller.sosmedId.value == 0
                              ? null
                              : controller.sosmedId.value,
                      itemAsString: (int id) {
                        // tampilkan referensi sesuai id
                        final item = controller.sosmedData.firstWhere(
                          (data) => data['id'] == id,
                          orElse: () => {'referensi': ''},
                        );
                        return item['referensi'].toString();
                      },
                      popupProps: PopupProps.dialog(
                        showSearchBox: false, // tetap false karena data sedikit
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
                          labelText: "Darimana Anda Mengetahui IDCPNS",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 12,
                          ),
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
                        // return list id preferensi belajar
                        return controller.referensiData
                            .map<int>((data) => data['id'] as int)
                            .toList();
                      },
                      selectedItem:
                          controller.referensiId.value == 0
                              ? null
                              : controller.referensiId.value,
                      itemAsString: (int id) {
                        // tampilkan nama menu sesuai id
                        final item = controller.referensiData.firstWhere(
                          (data) => data['id'] == id,
                          orElse: () => {'menu': ''},
                        );
                        return item['menu'].toString();
                      },
                      popupProps: PopupProps.dialog(
                        showSearchBox:
                            false, // datanya sedikit, tidak perlu search
                        fit: FlexFit.loose, // height mengikuti jumlah item
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
                            borderRadius: BorderRadius.circular(5),
                          ),
                          isDense: true,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 12,
                          ),
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
                                      showLogoutDialogLengkapiBiodata(context);
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
