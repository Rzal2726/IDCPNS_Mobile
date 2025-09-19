import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';

void showSyaratKetentuanDialog({VoidCallback? onAgree}) {
  Get.dialog(
    WillPopScope(
      onWillPop: () async => false, // blokir tombol back HP
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Text(
          "Syarat dan Ketentuan",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "Saya setuju untuk tidak menyebarkan konten-konten "
          "yang ada di website IDCPNS kepada pihak lain.",
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                onPressed: () {
                  Get.back(); // tutup dialog
                  Get.back(); // kalau mau balik 2 halaman
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.teal),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  "Tidak Setuju",
                  style: TextStyle(color: Colors.teal),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  Get.back(); // tutup dialog
                  if (onAgree != null) {
                    onAgree(); // jalankan callback
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  "Setuju",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
    barrierDismissible: false, // tidak bisa klik luar dialog
  );
}
