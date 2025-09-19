import 'package:flutter/material.dart';

Future<bool> showExitConfirmationDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Konfirmasi'),
        content: const Text(
          "Apakah kamu yakin ingin kembali?\nProgres tryout yang belum selesai akan hilang.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.pink),
            child: const Text('Ya', style: TextStyle(color: Colors.white)),
          ),
        ],
      );
    },
  );

  return result ?? false; // default false kalau user tutup dialog tanpa pilih
}
