import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';

import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});
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
                  child: Image.asset(
                    'assets/logo.png', // Ganti dengan path logo Anda
                    height: 70,
                  ),
                ),
                SizedBox(height: 32),
                Text(
                  'Daftar',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Mari bergabung bersama jutaan peserta lainnya.',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                SizedBox(height: 32),
                _buildInputField(
                  label: 'Nama Lengkap',
                  hintText: 'Masukkan nama lengkap',
                ),
                SizedBox(height: 16),
                _buildInputField(
                  label: 'Email',
                  hintText: 'Masukkan alamat email',
                ),
                SizedBox(height: 16),
                Obx(
                  () => _buildInputField(
                    label: 'Kata Sandi',
                    hintText: 'Masukkan kata sandi',
                    isPassword: true,
                    isPasswordVisible: controller.isPasswordVisible.value,
                    onToggleVisibility: controller.togglePasswordVisibility,
                  ),
                ),
                SizedBox(height: 16),
                Obx(
                  () => _buildInputField(
                    label: 'Konfirmasi Kata Sandi',
                    hintText: 'Masukkan konfirmasi kata sandi',
                    isPassword: true,
                    isPasswordVisible:
                        controller.isConfirmPasswordVisible.value,
                    onToggleVisibility:
                        controller.toggleConfirmPasswordVisibility,
                  ),
                ),
                SizedBox(height: 16),
                _buildTermsAndConditions(controller),
                SizedBox(height: 24),
                _buildRegisterButton(),
                SizedBox(height: 16),
                _buildGoogleRegisterButton(),
                SizedBox(height: 24),
                _buildLoginSection(),
                SizedBox(height: 32),
                _buildFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Metode untuk membuat input field
  Widget _buildInputField({
    required String label,
    required String hintText,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? onToggleVisibility,
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
          obscureText: isPassword && !isPasswordVisible,
          decoration: InputDecoration(
            hintText: hintText,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            suffixIcon:
                isPassword
                    ? IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: onToggleVisibility,
                    )
                    : null,
            // Tambahin ini biar outline muncul
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

  // Metode untuk membuat bagian Syarat & Ketentuan
  Widget _buildTermsAndConditions(RegisterController controller) {
    return Row(
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
        Expanded(
          child: RichText(
            text: TextSpan(
              text: 'Saya menyetujui ',
              style: TextStyle(color: Colors.black54, fontSize: 14),
              children: [
                TextSpan(
                  text: 'Syarat & Ketentuan',
                  style: TextStyle(
                    color: Color(0xFF007bff),
                    fontWeight: FontWeight.w600,
                    decoration: TextDecoration.underline,
                  ),
                ),
                TextSpan(
                  text: ' yang berlaku',
                  style: TextStyle(color: Colors.black54, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // Metode untuk membuat tombol 'Daftar'
  Widget _buildRegisterButton() {
    return ElevatedButton(
      onPressed: () {
        controller.onRegister();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        padding: EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        minimumSize: Size.fromHeight(50),
      ),
      child: Text(
        'Daftar',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Metode untuk membuat tombol 'Lanjutkan dengan Google'
  Widget _buildGoogleRegisterButton() {
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
          side: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }

  // Metode untuk membuat bagian 'Sudah Punya Akun?'
  Widget _buildLoginSection() {
    return Column(
      children: [
        Text('Sudah Punya Akun?', style: TextStyle(color: Colors.grey)),
        SizedBox(height: 16),
        OutlinedButton(
          onPressed: () {
            Get.toNamed(Routes.LOGIN);
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
            'Masuk',
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

  // Metode untuk membuat footer
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
