import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UnauthenticatedDialog extends StatelessWidget {
  final Future<void> Function() onLogout;

  const UnauthenticatedDialog({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: const [
          Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
          SizedBox(width: 8),
          Text(
            "Peringatan",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.black87,
            ),
          ),
        ],
      ),
      content: const Text(
        "Akun ini terhubung dengan device lain.\n\n"
        "Untuk melanjutkan, silakan login kembali.",
        style: TextStyle(fontSize: 15, height: 1.4, color: Colors.black54),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          onPressed: () async {
            await onLogout();
          },
          child: const Text(
            "OK",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ],
    );
  }
}
