import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';

class ForgetPasswordController extends GetxController {
  final _restClient = RestClient(); // pastikan RestClient sudah didefinisikan
  TextEditingController forgetEmailController = TextEditingController();
  RxBool isLoading = false.obs;

  Future<void> sendEmail(BuildContext context) async {
    final email = forgetEmailController.text.trim();

    if (email.isEmpty) {
      Get.snackbar("Peringatan", "Email harus diisi!");
      return;
    }

    final url = baseUrl + apiForgetPassword;
    final payload = {"email": email};

    isLoading.value = true;
    try {
      final result = await _restClient.postData(url: url, payload: payload);
      showEmailSentBottomSheet(context);
    } catch (e) {
      debugPrint("Unexpected error: $e");
      Get.snackbar("Error", "Gagal mengirim email. Silakan coba lagi.");
    } finally {
      isLoading.value = false;
    }
  }
}

void showEmailSentBottomSheet(BuildContext context) {
  showModalBottomSheet(
    useSafeArea: false,
    context: context,
    isDismissible: false,
    backgroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 40), // space untuk tombol X
                  SvgPicture.asset(
                    'assets/sendEmail.svg',
                    width: 120, // sesuaikan ukuran
                    height: 120, // sesuaikan ukuran
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Email Terkirim",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Silakan periksa kotak masuk Anda untuk email permintaan reset password.",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.teal),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            "Tutup",
                            style: TextStyle(color: Colors.teal, fontSize: 16),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            Get.toNamed(Routes.LOGIN);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: Text(
                            "Masuk",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                ],
              ),
              // Tombol X di kanan atas
              Positioned(
                right: 0,
                top: 0,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.grey[700]),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
