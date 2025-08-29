import 'package:flutter/gestures.dart';
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
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: Image.asset('assets/logo.png', height: 70)),
                SizedBox(height: 32),
                Text(
                  'Daftar',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Mari bergabung bersama jutaan peserta lainnya.',
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                ),
                SizedBox(height: 32),

                // Nama Lengkap
                Text(
                  "Nama Lengkap *",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: controller.nameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: _inputDecoration("Masukkan nama lengkap"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama tidak boleh kosong.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Email
                Text("Email *", style: TextStyle(fontWeight: FontWeight.w600)),
                SizedBox(height: 8),
                TextFormField(
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: _inputDecoration("Masukkan alamat email"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Email tidak boleh kosong.';
                    }
                    if (!GetUtils.isEmail(value.trim())) {
                      return 'Email tidak valid.';
                    }
                    if (controller.emailError.value.isNotEmpty) {
                      return controller.emailError.value;
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Password
                Text(
                  "Kata Sandi *",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                Obx(
                  () => TextFormField(
                    controller: controller.passwordController,
                    obscureText: !controller.isPasswordVisible.value,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: _inputDecoration(
                      "Masukkan kata sandi",
                    ).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.length < 8) {
                        return 'Password minimal 8 karakter.';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16),

                // Konfirmasi Password
                Text(
                  "Konfirmasi Kata Sandi *",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                Obx(
                  () => TextFormField(
                    controller: controller.confirmPasswordController,
                    obscureText: !controller.isConfirmPasswordVisible.value,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: _inputDecoration(
                      "Masukkan konfirmasi kata sandi",
                    ).copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isConfirmPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: controller.toggleConfirmPasswordVisibility,
                      ),
                    ),
                    validator: (value) {
                      if (value != controller.passwordController.text) {
                        return 'Konfirmasi password tidak cocok.';
                      }
                      return null;
                    },
                  ),
                ),
                SizedBox(height: 16),

                Text(
                  "Kode Afiliator",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: controller.affiliatorController,
                  decoration: _inputDecoration("Masukkan kode afiliator"),
                ),
                SizedBox(height: 16),

                // Checkbox Terms & Conditions
                Row(
                  children: [
                    Obx(
                      () => Checkbox(
                        value: controller.isAgreed.value,
                        onChanged:
                            (val) => controller.toggleTermsAndConditions(
                              val ?? false,
                            ),
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
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      Get.toNamed(Routes.TERM_CONDITONS);
                                      // Atau bisa pindah halaman:
                                      // Get.to(() => SyaratKetentuanPage());
                                    },
                            ),
                            TextSpan(text: ' yang berlaku'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),

                // Tombol Daftar
                Obx(
                  () => ElevatedButton(
                    onPressed:
                        controller.isLoading.value
                            ? null
                            : () {
                              if (controller.formKey.currentState!.validate()) {
                                if (!controller.isAgreed.value) {
                                  Get.snackbar(
                                    "Peringatan",
                                    "Anda harus menyetujui Syarat & Ketentuan",
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                  return;
                                }
                                controller.onRegister();
                              }
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: Size.fromHeight(50),
                    ),
                    child:
                        controller.isLoading.value
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                              'Daftar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ),
                SizedBox(height: 16),

                // Tombol Google
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: Image.asset('assets/goggleIcon.png', height: 28),
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
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    side: BorderSide(color: Colors.grey),
                  ),
                ),
                SizedBox(height: 24),

                // Sudah punya akun?
                Center(
                  child: Column(
                    children: [
                      Text(
                        'Sudah Punya Akun?',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: () => Get.toNamed(Routes.LOGIN),
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
                  ),
                ),
                SizedBox(height: 32),

                Center(
                  child: Text(
                    'Bimbel Tryout CPNS, Soal Tes CPNS & Kedinasan - IDCPNS © 2025',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade400, width: 1.2),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.teal, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 1.2),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red.shade700, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
