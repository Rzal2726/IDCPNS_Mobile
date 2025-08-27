import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/logo.png', // Replace with your logo path
                        height: 70,
                      ),
                      SizedBox(height: 8),
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Masuk',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 32),
                _buildInputField(
                  label: 'Email',
                  hintText: 'Masukkan alamat email',
                  isPassword: false,
                ),
                SizedBox(height: 16),
                _buildInputField(
                  label: 'Kata Sandi',
                  hintText: 'Masukkan kata sandi',
                  isPassword: true,
                ),
                SizedBox(height: 16),
                _buildRememberForgotSection(),
                SizedBox(height: 24),
                _buildLoginButton(),
                SizedBox(height: 16),
                _buildGoogleLoginButton(),
                SizedBox(height: 24),
                _buildRegisterSection(),
                SizedBox(height: 32),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper methods from your original code
  Widget _buildInputField({
    required String label,
    required String hintText,
    required bool isPassword,
  }) {
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
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hintText,
            filled: false, // Pastikan tidak ada warna background
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.teal, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
              borderSide: BorderSide(color: Colors.teal, width: 2.0),
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            suffixIcon:
                isPassword
                    ? Icon(Icons.visibility_off, color: Colors.grey)
                    : null,
          ),
        ),
      ],
    );
  }

  Widget _buildRememberForgotSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Obx(
              () => Checkbox(
                value: controller.isAgreed.value,
                onChanged: (bool? newValue) {
                  controller.toggleTermsAndConditions(newValue ?? false);
                },
                activeColor: Colors.teal,
              ),
            ),
            Text('Ingat Saya', style: TextStyle(fontSize: 14)),
          ],
        ),
        TextButton(
          onPressed: () {
            Get.toNamed(Routes.FORGET_PASSWORD);
          },
          child: Text(
            'Lupa Kata Sandi?',
            style: TextStyle(color: Colors.teal, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    return ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        minimumSize: Size.fromHeight(50),
      ),
      child: Text(
        'Masuk',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildGoogleLoginButton() {
    return SizedBox(
      width: double.infinity, // Tombol selebar parent
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: Image.asset(
          'assets/goggleIcon.png', // Replace with your logo path
          height: 28,
        ),
        label: Text(
          'Lanjutkan dengan Google',
          style: TextStyle(
            color: Colors.black,
            fontSize: 19,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          side: BorderSide(color: Color(0xFFdddddd)),
        ),
      ),
    );
  }

  Widget _buildRegisterSection() {
    return Column(
      children: [
        Text('Tidak Punya Akun?', style: TextStyle(color: Colors.grey)),
        SizedBox(height: 16),
        OutlinedButton(
          onPressed: () {
            Get.toNamed(Routes.REGISTER);
          },
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16),
            side: BorderSide(color: Colors.teal, width: 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            minimumSize: Size.fromHeight(50),
          ),
          child: Text(
            'Daftar',
            style: TextStyle(
              color: Colors.teal,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Center(
      child: Text(
        'Bimbel Tryout CPNS, Soal Tes CPNS & Kedinasan - IDCPNS © 2025',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12, color: Colors.grey),
      ),
    );
  }
}
