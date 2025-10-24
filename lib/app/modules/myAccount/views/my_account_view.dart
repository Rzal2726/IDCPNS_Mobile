import 'dart:io';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';
import 'package:idcpns_mobile/app/modules/home/controllers/home_controller.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/my_account_controller.dart';

class MyAccountView extends GetView<MyAccountController> {
  const MyAccountView({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // biar kita handle manual
      onPopInvoked: (didPop) async {
        if (didPop) return;
        Get.offAllNamed(Routes.HOME, arguments: {'initialIndex': 4});
        // (Get.find<HomeController>()).currentIndex.value = 4;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: secondaryAppBar(
          "Ubah Akun",
          onBack: () {
            Get.offAllNamed(Routes.HOME, arguments: {'initialIndex': 4});
            // (Get.find<HomeController>()).currentIndex.value = 4;
          },
        ),
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

                          return ClipOval(
                            child: Image(
                              image: image,
                              width:
                                  100, // sesuaikan dengan CircleAvatar radius*2
                              height: 100,
                              fit:
                                  BoxFit
                                      .cover, // biar memenuhi lingkaran tanpa blur
                            ),
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
                    controller.isLoading.value
                        ?
                        // === Skeletonizer dummy ===
                        Skeletonizer(
                          enabled: true,
                          child: Column(
                            children: [
                              // TextField Nama Lengkap
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              SizedBox(height: 20),

                              // TextField Email
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              SizedBox(height: 20),

                              // TextField No HP
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              SizedBox(height: 30),

                              // Dropdown Provinsi
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              SizedBox(height: 30),

                              // Dropdown Kabupaten
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              SizedBox(height: 30),
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              SizedBox(height: 30),
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              SizedBox(height: 30),
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              SizedBox(height: 30),
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              SizedBox(height: 30),
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              SizedBox(height: 30),
                              Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade300,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              SizedBox(height: 40),

                              // Tombol Simpan dummy
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {}, // dummy
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.teal,
                                    padding: EdgeInsets.symmetric(vertical: 14),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                  ),
                                  child: Text(
                                    "Simpan",
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                        : Column(
                          children: [
                            TextField(
                              controller: controller.namaLengkapController,
                              decoration: InputDecoration(
                                labelText: "Nama Lengkap",
                                border: OutlineInputBorder(),
                                isDense: true,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                            ),
                            SizedBox(height: 30),
                            // Email
                            TextField(
                              controller: controller.emailController,
                              enabled: false,
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: "Email",
                                border: OutlineInputBorder(),
                                isDense: true,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                            ),
                            SizedBox(height: 30),
                            // Nomor HP
                            TextField(
                              controller: controller.hpController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: "Nomor HP",
                                border: OutlineInputBorder(),
                                isDense: true,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(12),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                            SizedBox(height: 30),
                            // Nomor WhatsApp
                            TextField(
                              controller: controller.waController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                labelText: "Nomor WhatsApp",
                                border: OutlineInputBorder(),
                                isDense: true,
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always,
                              ),
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(12),
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                            ),
                            SizedBox(height: 30),
                            // Tanggal Lahir
                            Obx(
                              () => TextField(
                                controller: TextEditingController(
                                  text:
                                      controller.tanggalLahir.value.isEmpty
                                          ? null
                                          : controller
                                              .tanggalLahir
                                              .value, // <-- isi langsung dari database
                                ),
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: "Tanggal Lahir",
                                  hintText:
                                      "Pilih tanggal", // hanya jadi placeholder
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  suffixIcon: Icon(Icons.calendar_today),
                                ),
                                onTap: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate:
                                        controller.tanggalLahir.value.isNotEmpty
                                            ? DateTime.parse(
                                              controller.tanggalLahir.value,
                                            ) // kalau ada data, jadikan default
                                            : DateTime(2000), // fallback
                                    firstDate: DateTime(1950),
                                    lastDate: DateTime.now(),
                                  );
                                  if (picked != null) {
                                    controller.tanggalLahir.value =
                                        picked.toIso8601String().split("T")[0];
                                  }
                                },
                              ),
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
                            // Provinsi
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
                                      final prov = controller.provinceData
                                          .firstWhere(
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
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    decoratorProps: DropDownDecoratorProps(
                                      decoration: InputDecoration(
                                        labelText: "Provinsi",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            5,
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
                                      final kab = controller.kabupatenData
                                          .firstWhere(
                                            (data) => data['id'] == id,
                                            orElse: () => {'nama': ''},
                                          );
                                      return kab['nama'].toString();
                                    },
                                    popupProps: PopupProps.dialog(
                                      showSearchBox:
                                          true, // aktifkan search box
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
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                    ),
                                    decoratorProps: DropDownDecoratorProps(
                                      decoration: InputDecoration(
                                        labelText: "Kabupaten",
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
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
                                final item = controller.pendidikanData
                                    .firstWhere(
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
                            Obx(
                              () => DropdownSearch<int>(
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
                                  showSearchBox:
                                      false, // tetap false karena data sedikit
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
                                    labelText:
                                        "Darimana Anda Mengetahui IDCPNS",
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
                            ),
                            SizedBox(height: 30),
                            // Preferensi Belajar
                            Obx(
                              () => DropdownSearch<int>(
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
                                  final item = controller.referensiData
                                      .firstWhere(
                                        (data) => data['id'] == id,
                                        orElse: () => {'menu': ''},
                                      );
                                  return item['menu'].toString();
                                },
                                popupProps: PopupProps.dialog(
                                  showSearchBox:
                                      false, // datanya sedikit, tidak perlu search
                                  fit:
                                      FlexFit
                                          .loose, // height mengikuti jumlah item
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
                            ),
                            SizedBox(height: 20),
                            // Tombol Simpan
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed:
                                    controller.isLoading.value
                                        ? null
                                        : controller.simpanData,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                ),
                                child: Text(
                                  "Simpan",
                                  style: TextStyle(
                                    fontSize: 14,
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
