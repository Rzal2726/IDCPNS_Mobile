import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';

import '../controllers/email_verification_controller.dart';

class EmailVerificationView extends GetView<EmailVerificationController> {
  const EmailVerificationView({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {},
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // HEADER
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset('assets/logo.png', height: 60),
                    Stack(
                      children: [
                        Icon(Icons.notifications_rounded, size: 28),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '4',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // KONTEN UTAMA (DITENGAH)
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Ilustrasi amplop
                          SvgPicture.asset(
                            'assets/verifyIcon.svg',
                            height: 240,
                          ),
                          SizedBox(height: 15),
                          Text(
                            "Segera Verifikasi Email Anda",
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 30),
                          ),

                          // Deskripsi
                          Obx(
                            () => Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 14,
                                  ),
                                  children: [
                                    TextSpan(
                                      text:
                                          "Sebelum melanjutkan, silahkan periksa email Anda ",
                                    ),
                                    TextSpan(
                                      text: controller.email.value,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          " untuk tautan verifikasi. Jika Anda tidak menerima email, silahkan klik tombol ",
                                    ),
                                    TextSpan(
                                      text: "Kirim Ulang Email",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey,
                                      ),
                                    ),
                                    TextSpan(text: " dibawah ini."),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          SizedBox(height: 24),

                          // Tombol
                          Obx(
                            () => SizedBox(
                              width: 200,
                              height: 45,
                              child: OutlinedButton(
                                onPressed:
                                    controller.isButtonEnabled.value
                                        ? () => controller.resendEmail()
                                        : null, // otomatis disable
                                style: OutlinedButton.styleFrom(
                                  foregroundColor:
                                      controller.isButtonEnabled.value
                                          ? Colors.teal
                                          : Colors.grey, // warna teks & icon
                                  side: BorderSide(
                                    color:
                                        controller.isButtonEnabled.value
                                            ? Colors.teal
                                            : Colors.grey, // warna border
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ),
                                child: Text(
                                  "Kirim Ulang Email",
                                  style: TextStyle(
                                    color:
                                        controller.isButtonEnabled.value
                                            ? Colors.teal
                                            : Colors.grey, // warna teks
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 12),

                          // Countdown
                          Obx(
                            () => Text(
                              controller.isButtonEnabled.value
                                  ? "Anda bisa kirim ulang email sekarang"
                                  : "Anda dapat mengirim ulang email dalam ${controller.countdown.value} detik",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          RichText(
                            text: TextSpan(
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                              children: [
                                TextSpan(text: "Email yang diinput salah? "),
                                TextSpan(
                                  text: "Ubah disini",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  recognizer:
                                      TapGestureRecognizer()
                                        ..onTap = () {
                                          _showChangeEmailDialog(
                                            context,
                                            "${controller.box.read("email")}",
                                          );
                                        },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void _showChangeEmailDialog(BuildContext context, String oldEmail) {
  TextEditingController oldEmailController = TextEditingController(
    text: oldEmail,
  );

  final controller = Get.put(EmailVerificationController());
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Judul & Close
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Ubah Email",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 13),

              // Email Lama
              _buildLabel("* Email Lama"),
              SizedBox(height: 6),
              TextField(
                controller: oldEmailController,
                readOnly: true,
                decoration: _inputDecoration(),
              ),
              SizedBox(height: 16),

              // Email Baru
              _buildLabel("* Email Baru"),
              SizedBox(height: 6),
              TextField(
                controller: controller.newEmailController,
                decoration: _inputDecoration(
                  hintText: "Masukkan alamat email baru",
                ),
              ),
              SizedBox(height: 20),

              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    controller.changeAndSendEmail();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    "Ubah Email",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget _buildLabel(String text) {
  return RichText(
    text: TextSpan(
      text: text.startsWith("*") ? "* " : "",
      style: TextStyle(color: Colors.red),
      children: [
        TextSpan(
          text: text.replaceFirst("* ", ""),
          style: TextStyle(color: Colors.black),
        ),
      ],
    ),
  );
}

InputDecoration _inputDecoration({String? hintText}) {
  return InputDecoration(
    hintText: hintText,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: Colors.teal, width: 1.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: Colors.teal, width: 2),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
  );
}
