import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Future<bool> showExitDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder:
        (ctx) => AlertDialog(
          title: const Text("Konfirmasi"),
          content: const Text("Apakah kamu yakin ingin keluar aplikasi?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text("Keluar"),
            ),
          ],
        ),
  );
  return result ?? false;
}
