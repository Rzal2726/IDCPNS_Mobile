import 'package:flutter/material.dart';
import 'package:get/get.dart';

class notifHelper {
  /// type: 1 = success, 0 = error
  static void show(String message, {int type = 1}) {
    final isSuccess = type == 1;

    Get.snackbar(
      isSuccess ? "Berhasil" : "Error",
      message,
      backgroundColor: isSuccess ? Colors.teal : Colors.pink,
      colorText: Colors.white,
      snackPosition: SnackPosition.TOP,
      borderRadius: 12,
      margin: const EdgeInsets.all(12),
      duration: const Duration(seconds: 3),
    );
  }
}
