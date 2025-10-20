import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool> showExitDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false, // klik luar nggak bisa nutup
    builder:
        (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: const [
              Icon(Icons.exit_to_app, color: Colors.red),
              SizedBox(width: 8),
              Text("Konfirmasi Keluar"),
            ],
          ),
          content: Text(
            "Apakah kamu yakin ingin keluar dari aplikasi?",
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text("Batal", style: TextStyle(color: Colors.grey[600])),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
              ),
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text("Keluar"),
            ),
          ],
        ),
  );
  return result ?? false;
}

Future<bool> showLogoutDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false, // klik luar nggak bisa nutup
    builder:
        (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: const [
              Icon(Icons.logout, color: Colors.red),
              SizedBox(width: 8),
              Text("Konfirmasi Logout"),
            ],
          ),
          content: Text(
            "Apakah kamu yakin ingin keluar dari akun?",
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text("Batal", style: TextStyle(color: Colors.grey[600])),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
              ),
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text("Keluar"),
            ),
          ],
        ),
  );
  return result ?? false;
}

Future<bool> showExitDialogPretest(BuildContext context) async {
  final result = await showDialog(
    context: context,
    builder:
        (context) => AlertDialog(
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
        ),
  );
  return result ?? false;
}
