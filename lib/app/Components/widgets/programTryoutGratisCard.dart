import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget buildRecomenTryoutCard({
  required String title,
  required String periode,
  required String type,
  required VoidCallback onPressed, // <- tambahkan ini
}) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.teal,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Judul
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),

        // Narasi
        Text(
          "Memanggil semua pejuang $type yang bersiap menghadapi perang! "
          "Ayo segera bergabung bersama peserta lainnya di $title. "
          "Terkhusus pejuang-pejuang yang baru bergabung, daftar akun saja tidak cukup. "
          "Teman-teman harus segera bergabung pada tryout ini juga.",
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 12),

        // Periode
        Text(
          "Periode Pengerjaan Tryout Gratis : $periode",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),

        // Tombol
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          onPressed: onPressed, // <- gunakan parameter
          child: const Text("Gabung Sekarang"),
        ),
      ],
    ),
  );
}
