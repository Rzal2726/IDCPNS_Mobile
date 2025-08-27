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
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Ubah Akun", style: TextStyle(color: Colors.black)),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications, color: Colors.black),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: const Text(
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
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Foto Profil
                Center(
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Data Diri",
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: NetworkImage(
                          "https://i.ibb.co/3vYwF5L/sample-food.jpg",
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text("Max 5mb"),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: () {},
                        child: const Text("Pilih Foto"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Provinsi
                Column(
                  children: [
                    // Nama Lengkap
                    TextField(
                      decoration: const InputDecoration(
                        labelText: "Nama Lengkap",
                        border: OutlineInputBorder(),
                        isDense: true,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Email
                    TextField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(),
                        isDense: true,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Nomor HP
                    TextField(
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: "Nomor HP",
                        border: OutlineInputBorder(),
                        isDense: true,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Nomor WhatsApp
                    TextField(
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: "Nomor WhatsApp",
                        border: OutlineInputBorder(),
                        isDense: true,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Tanggal Lahir
                    TextField(
                      readOnly: true,
                      decoration: const InputDecoration(
                        labelText: "Tanggal Lahir",
                        border: OutlineInputBorder(),
                        isDense: true,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Jenis Kelamin
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Jenis Kelamin",
                        border: OutlineInputBorder(),
                        isDense: true,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "Laki-laki",
                          child: Text("Laki-laki"),
                        ),
                        DropdownMenuItem(
                          value: "Perempuan",
                          child: Text("Perempuan"),
                        ),
                      ],
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 16),

                    // Provinsi
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Provinsi",
                        border: OutlineInputBorder(),
                        isDense: true,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      items: const [
                        DropdownMenuItem(value: "ACEH", child: Text("ACEH")),
                        DropdownMenuItem(
                          value: "JAWA BARAT",
                          child: Text("JAWA BARAT"),
                        ),
                      ],
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 16),

                    // Kabupaten
                    TextField(
                      decoration: const InputDecoration(
                        labelText: "Kabupaten",
                        border: OutlineInputBorder(),
                        isDense: true,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Pendidikan
                    TextField(
                      decoration: const InputDecoration(
                        labelText: "Pendidikan",
                        border: OutlineInputBorder(),
                        isDense: true,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Darimana Mengetahui
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Darimana Anda Mengetahui IDCPNS",
                        border: OutlineInputBorder(),
                        isDense: true,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: "Instagram",
                          child: Text("Instagram"),
                        ),
                        DropdownMenuItem(value: "Teman", child: Text("Teman")),
                      ],
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 16),

                    // Preferensi Belajar
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Preferensi Belajar",
                        border: OutlineInputBorder(),
                        isDense: true,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      items: const [
                        DropdownMenuItem(value: "BUMN", child: Text("BUMN")),
                        DropdownMenuItem(value: "CPNS", child: Text("CPNS")),
                      ],
                      onChanged: (value) {},
                    ),
                    const SizedBox(height: 20),
                  ],
                ),

                // Tombol Simpan
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
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
