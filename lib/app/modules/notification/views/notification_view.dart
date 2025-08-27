import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        title: Text('Notifikasi', style: TextStyle(color: Colors.black)),
        centerTitle: false,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Stack(
              children: [
                Icon(Icons.notifications_none, color: Colors.teal),
                Positioned(
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: BoxConstraints(minWidth: 14, minHeight: 14),
                    child: Text(
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
          padding: EdgeInsets.all(16.0),

          // Center(
          //   child: Column(
          //     children:  [
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
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSectionHeader('Belum dibaca'),
                  IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
                ],
              ),

              SizedBox(height: 8),
              _buildNotificationItem(
                'Pembayaran Gagal',
                '23 Aug 2025',
                borderColor: Colors.teal,
              ),
              _buildNotificationItem(
                'Menunggu Pembayaran',
                '22 Aug 2025',
                borderColor: Colors.teal,
              ),
              SizedBox(height: 16),
              Divider(color: Colors.grey),
              SizedBox(height: 16),
              _buildSectionHeader('Sudah dibaca'),
              SizedBox(height: 8),
              _buildNotificationItem(
                'Transaksi Berhasil',
                '21 Aug 2025',
                borderColor: Colors.teal,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectAll() {
    final NotificationController controller = Get.put(NotificationController());
    return Row(
      children: [
        Checkbox(
          value: false,
          onChanged: (bool? value) {},
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),

        // biar dropdown gak overflow, bungkus dengan Flexible
        Flexible(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 100), // batas lebar maksimum
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.teal, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Obx(() {
                return DropdownButton<String>(
                  isExpanded: true,
                  value: controller.selectedFilter.value,
                  underline: SizedBox(),
                  items: [
                    DropdownMenuItem(
                      value: "Select All",
                      child: Text("Select all"),
                    ),
                    DropdownMenuItem(value: "Read", child: Text("Read")),
                    DropdownMenuItem(value: "Unread", child: Text("Unread")),
                  ],
                  onChanged: (String? value) {
                    if (value != null) {
                      controller.selectedFilter.value = value;
                      print("Selected: $value");
                    }
                  },
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildNotificationItem(
    String title,
    String date, {
    required Color borderColor,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor, width: 1),
        borderRadius: BorderRadius.circular(5),
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
              SizedBox(width: 5),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Text(
                    date,
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),

          Divider(color: Colors.grey),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size(40, 20),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text("Lihat", style: TextStyle(color: Colors.cyan)),
              ),
              SizedBox(width: 8),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size(40, 20),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  "Tandai sudah dibaca",
                  style: TextStyle(color: Colors.teal),
                ),
              ),
              SizedBox(width: 8),
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size(40, 20),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text("Hapus", style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
