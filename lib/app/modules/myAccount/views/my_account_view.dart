import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';

import '../controllers/my_account_controller.dart';

class MyAccountView extends GetView<MyAccountController> {
  const MyAccountView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: secondaryAppBar(
        "Ubah Akun",
        onBack: () {
          Get.back();
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
                          image = FileImage(File(controller.newProfile.value));
                        } else if (controller.fotoProfile.value.isNotEmpty) {
                          image = NetworkImage(controller.fotoProfile.value);
                        } else {
                          image = AssetImage("assets/profileDefault.png");
                        }

                        return CircleAvatar(radius: 50, backgroundImage: image);
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
                            borderRadius: BorderRadius.circular(5), // radius 5
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
                    keyboardType: TextInputType.emailAddress,
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
                    decoration: InputDecoration(
                      labelText: "Nomor HP",
                      border: OutlineInputBorder(),
                      isDense: true,
                      floatingLabelBehavior: FloatingLabelBehavior.always,
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
                      floatingLabelBehavior: FloatingLabelBehavior.always,
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
                  ),
                  SizedBox(height: 30),

                  // Jenis Kelamin
                  DropdownButtonFormField<String>(
                    value:
                        controller.jenisKelamin.value.isEmpty
                            ? null
                            : controller
                                .jenisKelamin
                                .value, // tetap pakai "L" atau "P"
                    decoration: InputDecoration(
                      labelText: "Jenis Kelamin",
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items:
                        controller.jenisKelaminMap.entries
                            .map(
                              (entry) => DropdownMenuItem<String>(
                                value: entry.key, // "L" / "P"
                                child: Text(
                                  entry.value,
                                ), // "Laki-laki" / "Perempuan"
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      controller.jenisKelamin.value = value ?? '';
                    },
                  ),
                  SizedBox(height: 30),

                  // Provinsi
                  Obx(() {
                    return Column(
                      children: [
                        DropdownButtonFormField<int>(
                          value:
                              controller.provinsiId.value == 0
                                  ? null
                                  : controller.provinsiId.value,
                          decoration: const InputDecoration(
                            labelText: "Provinsi",
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          items:
                              controller.provinceData
                                  .map(
                                    (item) => DropdownMenuItem<int>(
                                      value: item['id'], // id sebagai value
                                      child: Text(
                                        item['nama'],
                                      ), // nama sebagai tampilan
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              controller.provinsiId.value = value;

                              controller.kabupatenId.value = 0;
                              controller.kabupatenData.clear();

                              // panggil API kabupaten sesuai provinsi
                              controller.getKabupaten(id: value);
                            }
                          },
                        ),
                        SizedBox(height: 30),
                        DropdownButtonFormField<int>(
                          value:
                              controller.kabupatenId.value == 0
                                  ? null
                                  : controller.kabupatenId.value,
                          decoration: const InputDecoration(
                            labelText: "Kabupaten",
                            border: OutlineInputBorder(),
                            isDense: true,
                          ),
                          items:
                              controller.kabupatenData
                                  .map(
                                    (item) => DropdownMenuItem<int>(
                                      value:
                                          item['id'], // <- id kabupaten (int)
                                      child: Text(
                                        item['nama'],
                                      ), // <- pakai 'nama' sesuai JSON
                                    ),
                                  )
                                  .toList(),
                          onChanged:
                              controller.kabupatenData.isNotEmpty
                                  ? (value) =>
                                      controller.kabupatenId.value = value ?? 0
                                  : null,
                        ),
                      ],
                    );
                  }),

                  SizedBox(height: 30),

                  // Pendidikan
                  Obx(
                    () => DropdownButtonFormField<int>(
                      value:
                          controller.pendidikanId.value == 0
                              ? null
                              : controller.pendidikanId.value,
                      decoration: const InputDecoration(
                        labelText: "Pendidikan",
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      items:
                          controller.pendidikanData
                              .map(
                                (item) => DropdownMenuItem<int>(
                                  value: item['id'], // simpan id pendidikan
                                  child: Text(
                                    item['pendidikan'],
                                  ), // tampilkan nama pendidikan
                                ),
                              )
                              .toList(),
                      onChanged: (value) {
                        controller.pendidikanId.value = value ?? 0;
                      },
                    ),
                  ),

                  SizedBox(height: 30),

                  // Darimana Mengetahui
                  // Obx(
                  //   () => DropdownButtonFormField<String>(
                  //     value:
                  //         controller.sumberInfo.value.isEmpty
                  //             ? null
                  //             : controller.sumberInfo.value,
                  //     decoration: InputDecoration(
                  //       labelText: "Darimana Anda Mengetahui IDCPNS",
                  //       border: OutlineInputBorder(),
                  //       isDense: true,
                  //     ),
                  //     items: [
                  //       DropdownMenuItem(
                  //         value: "Instagram",
                  //         child: Text("Instagram"),
                  //       ),
                  //       DropdownMenuItem(value: "Teman", child: Text("Teman")),
                  //     ],
                  //     onChanged:
                  //         (value) => controller.sumberInfo.value = value ?? '',
                  //   ),
                  // ),
                  Obx(
                    () => DropdownButtonFormField<int>(
                      value:
                          controller.sosmedId.value == 0
                              ? null
                              : controller.sosmedId.value,
                      decoration: InputDecoration(
                        labelText: "Darimana Anda Mengetahui IDCPNS",
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      items:
                          controller.sosmedData
                              .map(
                                (item) => DropdownMenuItem<int>(
                                  value: item['id'], // pakai id sebagai value
                                  child: Text(
                                    item['referensi'],
                                  ), // tampilannya nama
                                ),
                              )
                              .toList(),
                      onChanged:
                          (value) => controller.sosmedId.value = value ?? 0,
                    ),
                  ),
                  SizedBox(height: 30),

                  // Preferensi Belajar
                  Obx(
                    () => DropdownButtonFormField<int>(
                      value:
                          controller.referensiId.value == 0
                              ? null
                              : controller.referensiId.value,
                      decoration: InputDecoration(
                        labelText: "Preferensi Belajar",
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                      items:
                          controller.referensiData
                              .map(
                                (item) => DropdownMenuItem<int>(
                                  value: item['id'], // pakai id sebagai value
                                  child: Text(item['menu']), // tampilannya nama
                                ),
                              )
                              .toList(),
                      onChanged:
                          (value) => controller.referensiId.value = value ?? 0,
                    ),
                  ),

                  SizedBox(height: 20),

                  // Tombol Simpan
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: controller.simpanData,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        "Simpan",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
