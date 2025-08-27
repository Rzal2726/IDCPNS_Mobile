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
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Image.asset('assets/logo.png', height: 70),
                    SizedBox(height: 20),
                  ],
                ),
              ),
              Text(
                'Masuk',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 32),

              // Email Input
              Text("Email *", style: TextStyle(fontWeight: FontWeight.w600)),
              SizedBox(height: 8),
              TextField(
                controller: controller.emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Masukkan alamat email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.teal, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.teal, width: 2),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Password Input
              Text(
                "Kata Sandi *",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 8),
              Obx(
                () => TextField(
                  controller: controller.passwordController,
                  obscureText: !controller.isPasswordVisible.value,
                  decoration: InputDecoration(
                    hintText: 'Masukkan kata sandi',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.teal, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.teal, width: 2),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        controller.isPasswordVisible.value
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: controller.togglePasswordVisibility,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),

              // Remember & Forgot
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Obx(
                  //   () => Row(
                  //     children: [
                  //       Checkbox(
                  //         value: controller.isAgreed.value,
                  //         onChanged:
                  //             (value) => controller.toggleTermsAndConditions(
                  //               value ?? false,
                  //             ),
                  //         activeColor: Colors.teal,
                  //       ),
                  //       Text('Ingat Saya'),
                  //     ],
                  //   ),
                  // ),
                  TextButton(
                    onPressed: () => Get.toNamed(Routes.FORGET_PASSWORD),
                    child: Text(
                      'Lupa Kata Sandi?',
                      style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),

              // Login Button
              Obx(
                () => ElevatedButton(
                  onPressed:
                      controller.isLoading.value
                          ? null
                          : () {
                            controller.login();
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
                            'Masuk',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                ),
              ),
              SizedBox(height: 16),

              // Google Login
              OutlinedButton.icon(
                onPressed: () {},
                icon: Image.asset('assets/goggleIcon.png', height: 28),
                label: Text(
                  'Lanjutkan dengan Google',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold),
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

              // Register Section
              Center(
                child: Text(
                  'Tidak Punya Akun?',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(height: 16),
              OutlinedButton(
                onPressed: () => Get.toNamed(Routes.REGISTER),
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
              SizedBox(height: 32),

              // Footer
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
    );
  }
}
