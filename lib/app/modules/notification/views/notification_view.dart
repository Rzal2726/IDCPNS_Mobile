import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';
import 'package:intl/intl.dart';
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
      body: SafeArea(
        child: Obx(() {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),

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
                  for (var data in controller.notifData)
                    if (data['read'] == 0)
                      _buildNotificationItem(
                        '${data['title']}',
                        '${data['created_at']}',
                        0,
                        data['id'],
                        data['description'],
                        data['orderId']?.toString() ?? "",
                      ),
                  SizedBox(height: 16),
                  Divider(color: Colors.grey),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildSectionHeader('Sudah dibaca'),
                      IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
                    ],
                  ),
                  SizedBox(height: 8),
                  for (var data in controller.notifData)
                    if (data['read'] == 1)
                      _buildNotificationItem(
                        '${data['title']}',
                        '${data['created_at']}',
                        1,
                        data['id'],
                        data['description'],
                        data['orderId']?.toString() ?? "",
                      ),
                ],
              ),
            ),
          );
        }),
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
    String date,
    int tipe,
    int id,
    String desc,
    String idOrder,
  ) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: tipe == 0 ? Colors.teal : Colors.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(5),
        color: tipe == 0 ? Colors.white : Colors.grey.shade100,
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
                onPressed: () {
                  showPaymentBottomSheet(
                    title: title,
                    dateTime: date,
                    orderNo: idOrder,
                    message: desc,
                    id: id,
                  );
                  controller.getReadNotif(id: id);
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size(40, 20),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text("Lihat", style: TextStyle(color: Colors.cyan)),
              ),
              SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  tipe == 0
                      ? controller.getReadNotif(id: id)
                      : controller.getUnreadNotif(id: id);
                },
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size(40, 20),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  tipe == 0 ? "Tandai sudah dibaca" : "Tandai belum dibaca",
                  style: TextStyle(color: Colors.teal),
                ),
              ),
              SizedBox(width: 8),
              TextButton(
                onPressed: () {
                  controller.getDeleteNotif(id: id);
                },
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

void showPaymentBottomSheet({
  String? title,
  String? dateTime,
  String? orderNo,
  String? message,
  int? id,
}) {
  showModalBottomSheet(
    context: Get.context!,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title ?? "Judul tidak ada",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(Icons.close, color: Colors.grey[600]),
                    ),
                  ],
                ),

                SizedBox(height: 8),

                if (dateTime != null)
                  Text(
                    dateTime.isNotEmpty
                        ? DateFormat(
                          "dd/MM/yyyy HH:mm",
                        ).format(DateTime.parse(dateTime))
                        : "",
                    style: TextStyle(fontSize: 12, color: Colors.black54),
                  ),

                if (dateTime != null) SizedBox(height: 12),

                if (orderNo != null)
                  Text(
                    orderNo == "" ? "" : "No order : $orderNo",
                    style: TextStyle(fontSize: 13, color: Colors.black87),
                  ),

                if (orderNo != null) SizedBox(height: 12),

                if (message != null)
                  Text(
                    message,
                    style: TextStyle(fontSize: 13, color: Colors.black87),
                  ),

                Spacer(), // dorong tombol ke bawah

                Padding(
                  padding: EdgeInsets.only(
                    bottom: 12,
                  ), // kasih jarak biar enak dijangkau
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        title == "Menunggu Pembayaran"
                            ? Get.toNamed(Routes.TRANSACTION)
                            : Get.toNamed(Routes.INVOICE, arguments: id);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal, // ganti ke teal
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(
                        "Lihat selengkapnya",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
