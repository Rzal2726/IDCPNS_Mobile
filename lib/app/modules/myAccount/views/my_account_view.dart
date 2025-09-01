import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/my_account_controller.dart';

class MyAccountView extends GetView<MyAccountController> {
  const MyAccountView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text("Ubah Akun", style: TextStyle(color: Colors.black)),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications_none, color: Colors.teal),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    "9+",
                    style: TextStyle(fontSize: 10, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),

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
                Obx(
                  () => DropdownButtonFormField<String>(
                    value:
                        controller.jenisKelamin.value.isEmpty
                            ? null
                            : controller.jenisKelamin.value,
                    decoration: InputDecoration(
                      labelText: "Jenis Kelamin",
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: [
                      DropdownMenuItem(
                        value: "Laki-laki",
                        child: Text("Laki-laki"),
                      ),
                      DropdownMenuItem(
                        value: "Perempuan",
                        child: Text("Perempuan"),
                      ),
                    ],
                    onChanged:
                        (value) => controller.jenisKelamin.value = value ?? '',
                  ),
                ),
                SizedBox(height: 30),

                // Provinsi
                Obx(
                  () => DropdownButtonFormField<String>(
                    value:
                        controller.provinsi.value.isEmpty
                            ? null
                            : controller.provinsi.value,
                    decoration: InputDecoration(
                      labelText: "Provinsi",
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: [
                      DropdownMenuItem(value: "ACEH", child: Text("ACEH")),
                      DropdownMenuItem(
                        value: "JAWA BARAT",
                        child: Text("JAWA BARAT"),
                      ),
                    ],
                    onChanged:
                        (value) => controller.provinsi.value = value ?? '',
                  ),
                ),
                SizedBox(height: 30),

                // Kabupaten
                TextField(
                  controller: controller.kabupatenController,
                  decoration: InputDecoration(
                    labelText: "Kabupaten",
                    border: OutlineInputBorder(),
                    isDense: true,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
                SizedBox(height: 30),

                // Pendidikan
                TextField(
                  controller: controller.pendidikanController,
                  decoration: InputDecoration(
                    labelText: "Pendidikan",
                    border: OutlineInputBorder(),
                    isDense: true,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                  ),
                ),
                SizedBox(height: 30),

                // Darimana Mengetahui
                Obx(
                  () => DropdownButtonFormField<String>(
                    value:
                        controller.sumberInfo.value.isEmpty
                            ? null
                            : controller.sumberInfo.value,
                    decoration: InputDecoration(
                      labelText: "Darimana Anda Mengetahui IDCPNS",
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: [
                      DropdownMenuItem(
                        value: "Instagram",
                        child: Text("Instagram"),
                      ),
                      DropdownMenuItem(value: "Teman", child: Text("Teman")),
                    ],
                    onChanged:
                        (value) => controller.sumberInfo.value = value ?? '',
                  ),
                ),
                SizedBox(height: 30),

                // Preferensi Belajar
                Obx(
                  () => DropdownButtonFormField<String>(
                    value:
                        controller.preferensiBelajar.value.isEmpty
                            ? null
                            : controller.preferensiBelajar.value,
                    decoration: InputDecoration(
                      labelText: "Preferensi Belajar",
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    items: [
                      DropdownMenuItem(value: "BUMN", child: Text("BUMN")),
                      DropdownMenuItem(value: "CPNS", child: Text("CPNS")),
                    ],
                    onChanged:
                        (value) =>
                            controller.preferensiBelajar.value = value ?? '',
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
        ),
      ),
    );
  }
}
