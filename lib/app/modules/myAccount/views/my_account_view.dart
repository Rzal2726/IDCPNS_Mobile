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
          onPressed: () => Navigator.pop(context),
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
                // Foto Profil
                Center(
                  child: Column(
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
                      SizedBox(height: 10),
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                          "https://i.ibb.co/3vYwF5L/sample-food.jpg",
                        ),
                      ),
                      SizedBox(height: 8),
                      Text("Max 5mb"),
                      SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: Colors.teal,
                            width: 2,
                          ), // warna dan ketebalan border
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              8,
                            ), // sudut kotak
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ), // padding dalam tombol
                        ),
                        child: Text(
                          "Pilih Foto",
                          style: TextStyle(
                            color: Colors.teal,
                            fontWeight: FontWeight.bold,
                          ), // teks warna teal
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                // Provinsi
                Column(
                  children: [
                    // Nama Lengkap
                    TextField(
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
                    TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: "Tanggal Lahir",
                        border: OutlineInputBorder(),
                        isDense: true,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                    ),
                    SizedBox(height: 30),

                    // Jenis Kelamin
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Jenis Kelamin",
                        border: OutlineInputBorder(),
                        isDense: true,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
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
                      onChanged: (value) {},
                    ),
                    SizedBox(height: 30),

                    // Provinsi
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Provinsi",
                        border: OutlineInputBorder(),
                        isDense: true,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      items: [
                        DropdownMenuItem(value: "ACEH", child: Text("ACEH")),
                        DropdownMenuItem(
                          value: "JAWA BARAT",
                          child: Text("JAWA BARAT"),
                        ),
                      ],
                      onChanged: (value) {},
                    ),
                    SizedBox(height: 30),

                    // Kabupaten
                    TextField(
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
                      decoration: InputDecoration(
                        labelText: "Pendidikan",
                        border: OutlineInputBorder(),
                        isDense: true,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ),
                    SizedBox(height: 30),

                    // Darimana Mengetahui
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Darimana Anda Mengetahui IDCPNS",
                        border: OutlineInputBorder(),
                        isDense: true,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      items: [
                        DropdownMenuItem(
                          value: "Instagram",
                          child: Text("Instagram"),
                        ),
                        DropdownMenuItem(value: "Teman", child: Text("Teman")),
                      ],
                      onChanged: (value) {},
                    ),
                    SizedBox(height: 30),

                    // Preferensi Belajar
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Preferensi Belajar",
                        border: OutlineInputBorder(),
                        isDense: true,
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                      items: [
                        DropdownMenuItem(value: "BUMN", child: Text("BUMN")),
                        DropdownMenuItem(value: "CPNS", child: Text("CPNS")),
                      ],
                      onChanged: (value) {},
                    ),
                    SizedBox(height: 20),
                  ],
                ),

                // Tombol Simpan
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
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
