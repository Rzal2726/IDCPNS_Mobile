import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: const Text('Notifikasi', style: TextStyle(color: Colors.black)),
        centerTitle: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Stack(
              children: [
                const Icon(Icons.notifications_none, color: Colors.black),
                Positioned(
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: const Text(
                      '4',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),

          // Center(
          //   child: Column(
          //     children: const [
          //       Icon(Icons.notifications_none,
          //           size: 80, color: Colors.grey),
          //       SizedBox(height: 12),
          //       Text(
          //         "Tidak ada notifikasi",
          //         style: TextStyle(
          //             fontSize: 16,
          //             color: Colors.grey,
          //             fontWeight: FontWeight.w500),
          //       ),
          //     ],
          //   ),
          // ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSelectAll(),
              const SizedBox(height: 16),
              _buildSectionHeader('Belum dibaca'),
              const SizedBox(height: 8),
              _buildNotificationItem(
                'Pembayaran Gagal',
                '23 Aug 2025',
                borderColor: Colors.green,
              ),
              _buildNotificationItem(
                'Menunggu Pembayaran',
                '22 Aug 2025',
                borderColor: Colors.green,
              ),
              const SizedBox(height: 16),
              _buildSectionHeader('Sudah dibaca'),
              const SizedBox(height: 8),
              _buildNotificationItem(
                'Transaksi Berhasil',
                '21 Aug 2025',
                borderColor: Colors.green,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectAll() {
    return Row(
      children: [
        Checkbox(
          value: false,
          onChanged: (bool? value) {},
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        const Text('Select All', style: TextStyle(fontSize: 14)),
        const Spacer(),
        IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildNotificationItem(
    String title,
    String date, {
    required Color borderColor,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(
                value: false,
                onChanged: (bool? value) {},
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
          Text(date, style: const TextStyle(color: Colors.grey, fontSize: 12)),
          Divider(color: Colors.grey),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(40, 20),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  "Lihat",
                  style: TextStyle(color: Colors.cyan),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(40, 20),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  "Tandai sudah dibaca",
                  style: TextStyle(color: Colors.cyan),
                ),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(40, 20),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text("Hapus", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
