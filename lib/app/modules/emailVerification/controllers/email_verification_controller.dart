import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idcpns_mobile/app/Components/widgets/notifCostume.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';
// import 'package:idcpns_mobile/app/routes/app_pages.dart';

class EmailVerificationController extends GetxController {
  final _restClient = RestClient();
  final box = GetStorage();
  var countdown = 0.obs; // mulai dari 0
  var isButtonEnabled = true.obs; // bisa langsung klik
  RxBool isLoading = false.obs;
  TextEditingController newEmailController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  Timer? pollingTimer;
  RxString email = "".obs;
  @override
  void onInit() {
    email.value = box.read('email');
    countdown.value = 30; // mulai dari 30 detik
    isButtonEnabled.value = false; // tombol disable saat countdown
    startCountdown(); // mulai countdown otomatis
    // polling email sementara tetap di-comment
    // startEmailVerificationPolling();
    checkMaintenance();
    super.onInit();
  }

  @override
  void onClose() {
    pollingTimer?.cancel();
    super.onClose();
  }

  void startCountdown() async {
    while (countdown.value > 0) {
      await Future.delayed(const Duration(seconds: 1));
      countdown.value--;
    }
    isButtonEnabled.value = true;
  }

  void resendEmail() {
    countdown.value = 30;
    isButtonEnabled.value = false;
    apiSendEmail();
    startCountdown();
  }

  Future<void> apiSendEmail() async {
    isLoading.value = true;

    final url = baseUrl + apiEmailResend;
    final payload = {"name": box.read("name"), "email": box.read("email")};

    final result = await _restClient.postData(url: url, payload: payload);

    if (result["status"] == "success") {
      notifHelper.show(result['message'], type: 1);
    } else {
      notifHelper.show(result["message"], type: 0);
    }

    isLoading.value = false;
  }

  Future<void> sendOtp(String otp) async {
    isLoading.value = true;

    final url = baseUrl + apiSendOtp;
    final payload = {"otp_code": otp, "email": box.read("email")};

    final result = await _restClient.postData(url: url, payload: payload);

    if (result["status"] == "success") {
      notifHelper.show("Register berhasil", type: 1);
      otpController.clear();
      Get.toNamed(Routes.LOGIN);
    } else {
      notifHelper.show(result["message"], type: 0);
    }

    isLoading.value = false;
  }

  Future<void> changeAndSendEmail() async {
    isLoading.value = true;
    try {
      final url = baseUrl + apiEmailChange;
      final payload = {
        "old_email": box.read("email"),
        "email": newEmailController.text,
      };
      final result = await _restClient.postData(url: url, payload: payload);

      if (result["status"] == "success") {
        notifHelper.show(
          "Email berhasil diperbarui. Silakan cek email untuk verifikasi.",
          type: 1,
        );
        box.write("email", newEmailController.text);
        email.value = newEmailController.text; // update Rx variable
        resendEmail();
      } else {
        final errorMessage =
            (result["message"] is Map && result["message"]["email"] != null)
                ? result["message"]["email"][0]
                : "Terjadi kesalahan, silakan coba lagi.";
        notifHelper.show(errorMessage, type: 0);
      }
    } catch (e) {
      notifHelper.show("Email ini sudah terdaftar.", type: 0);
    } finally {
      newEmailController.clear();
      isLoading.value = false;
    }
  }

  // sementara fungsi polling di-comment

  // Future<void> startEmailVerificationPolling() async {
  //   pollingTimer?.cancel();
  //   pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
  //     try {
  //       final url = await baseUrl + apiGetUser;
  //
  //       final result = await _restClient.getData(url: url);
  //       print("emailnnyaa ${result.toString()}");
  //       if (result["status"] == "success") {
  //         print("emailnnyaa ${result["data"].toString()}");
  //         final isVerified = result["data"]["is_email_verified"] ?? false;
  //         if (isVerified) {
  //           timer.cancel();
  //           notifHelper.show("Register berhasil", type: 1);
  //           otpController.clear();
  //           Get.toNamed(Routes.LOGIN);
  //         }
  //       }
  //     } catch (e) {
  //       print("Error polling email verification: $e");
  //     }
  //   });
  // }

  Future<void> checkMaintenance() async {
    final response = await _restClient.getData(
      url: baseUrl + apiCheckMaintenance,
    );
    if (response['is_maintenance']) {
      Get.offAllNamed("/maintenance");
    }
  }
}
