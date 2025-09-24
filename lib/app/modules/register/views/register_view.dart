import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/notifCostume.dart';
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
                RichText(
                  text: TextSpan(
                    text: "Nama Lengkap ",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(text: "*", style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: controller.nameController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: _inputDecoration("Masukkan nama lengkap"),
                ),
                SizedBox(height: 16),

                // Email
                RichText(
                  text: TextSpan(
                    text: "Email ",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(text: "*", style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                TextFormField(
                  controller: controller.regEmailController,
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: _inputDecoration("Masukkan alamat email"),
                ),
                SizedBox(height: 16),

                // Password
                RichText(
                  text: TextSpan(
                    text: "Password ",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(text: "*", style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Obx(
                  () => TextFormField(
                    controller: controller.regPasswordController,
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
                  ),
                ),
                SizedBox(height: 16),

                // Konfirmasi Password
                RichText(
                  text: TextSpan(
                    text: "Konfirmasi Password ",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 14,
                    ),
                    children: [
                      TextSpan(text: "*", style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Obx(
                  () => TextFormField(
                    controller: controller.confirmPasswordController,
                    obscureText: !controller.isConfirmPasswordVisible.value,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: _inputDecoration(
                      "Masukkan konfirmasi password",
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
                  ),
                ),
                SizedBox(height: 16),

                // Kode Afiliator
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
                                  notifHelper.show(
                                    "Anda harus menyetujui Syarat & Ketentuan",
                                    type: 0,
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
                  onPressed:
                      controller.isLoading.value
                          ? null
                          : () => controller.handleSignIn(),
                  icon: Image.asset('assets/goggleIcon.png', height: 28),
                  label:
                      controller.isLoading.value
                          ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.black,
                            ),
                          )
                          : Text(
                            'Lanjutkan dengan Google',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size.fromHeight(50),
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
