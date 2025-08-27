import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';
import '../controllers/forget_password_controller.dart';

class ForgetPasswordView extends GetView<ForgetPasswordController> {
  const ForgetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Konten scrollable
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Logo
                      Center(child: Image.asset('assets/logo.png', height: 70)),
                      SizedBox(height: 32),

                      // Judul & Subjudul
                      Text(
                        'Lupa Kata Sandi',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        'Masukkan alamat email yang sudah terdaftar.',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 32),

                      // Input Email
                      _buildInputField(
                        label: 'Email',
                        hintText: 'Masukkan alamat email',
                      ),
                      SizedBox(height: 24),

                      // Tombol Kirim
                      _buildSendButton(),
                      SizedBox(height: 16),

                      // Link Daftar
                      _buildRegisterLink(),
                      SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),

            // Footer tetap di bawah layar
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  // Input Field
  Widget _buildInputField({required String label, required String hintText}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: TextStyle(fontWeight: FontWeight.w600)),
            Text(' *', style: TextStyle(color: Colors.red)),
          ],
        ),
        SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.teal, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.teal, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  // Tombol Kirim
  Widget _buildSendButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        minimumSize: Size.fromHeight(50),
      ),
      child: Text(
        'Kirim',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Link ke halaman Register
  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text('Belum punya akun? ', style: TextStyle(color: Colors.grey)),
        GestureDetector(
          onTap: () {
            Get.toNamed(Routes.REGISTER);
          },
          child: Text(
            'Daftar',
            style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  // Footer
  Widget _buildFooter() {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Text(
        'Bimbel Tryout CPNS, Soal Tes CPNS & Kedinasan - IDCPNS © 2025',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12, color: Colors.grey),
      ),
    );
  }
}
