import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: basicAppBarWithoutNotif("Notifikasi"),
      body: SafeArea(
        child: RefreshIndicator(
          backgroundColor: Colors.white,
          color: Colors.teal,
          onRefresh: () => controller.refresh(),
          child: Obx(() {
            return SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(16.0),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSelectAll(),

                    Visibility(
                      visible: controller.idSelected.isNotEmpty,
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  // Ambil tipe semua yang dipilih
                                  bool allRead = controller.idSelected.every(
                                    (e) => e['tipe'] == 0,
                                  );
                                  bool allUnread = controller.idSelected.every(
                                    (e) => e['tipe'] == 1,
                                  );

                                  List<int> ids =
                                      controller.idSelected
                                          .map((e) => e['id']!)
                                          .toList();

                                  if (allRead || (!allRead && !allUnread)) {
                                    controller.getReadNotif(
                                      id: 0,
                                      idNotif: ids,
                                    );
                                  } else if (allUnread) {
                                    controller.getUnreadNotif(
                                      id: 0,
                                      idNotif: ids,
                                    );
                                  }
                                  controller.idSelected.clear();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                                child: Text(
                                  // Tentukan teks tombol
                                  controller.idSelected.every(
                                        (e) => e['tipe'] == 1,
                                      )
                                      ? "Tandai semua belum dibaca"
                                      : "Tandai semua sudah dibaca",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              SizedBox(width: 10),
                              ElevatedButton(
                                onPressed: () {
                                  // Ambil semua ID yang dipilih, tidak peduli tipe
                                  List<int> ids =
                                      controller.idSelected
                                          .map((e) => e['id']!)
                                          .toList();

                                  // Panggil fungsi hapus (misal getDeleteNotif atau fungsi custom)
                                  controller.getDeleteNotif(idNotif: ids);

                                  // Kosongkan idSelected setelah dihapus
                                  controller.idSelected.clear();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.red, // warna merah untuk delete
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 12,
                                  ),
                                ),
                                child: Text(
                                  "Hapus",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSectionHeader('Belum dibaca'),
                        Visibility(
                          visible: controller.idSelected.isEmpty,
                          child: Align(
                            alignment:
                                Alignment
                                    .centerRight, // posisinya bisa di kanan
                            child: PopupMenuButton<String>(
                              icon: Icon(Icons.more_vert, color: Colors.teal),
                              onSelected: (value) {
                                if (value == 'markRead') {
                                  controller.getReadNotif(
                                    id: 0,
                                    idNotif: controller.allUnreadData,
                                  );
                                }
                                // Bisa tambah opsi lain kalau mau
                              },
                              itemBuilder:
                                  (BuildContext context) => [
                                    PopupMenuItem<String>(
                                      value: 'markRead',
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.mark_email_read,
                                            color: Colors.teal,
                                          ),
                                          SizedBox(width: 8),
                                          Text("Tandai semua sudah dibaca"),
                                        ],
                                      ),
                                    ),
                                  ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8),
                    Obx(() {
                      final unreadData =
                          controller.notifData
                              .where((d) => d['read'] == 0)
                              .toList();

                      return controller.isLoading.value
                          // ✅ Skeleton Loader
                          ? ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: 5,
                            itemBuilder:
                                (context, index) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 16.0,
                                  ),
                                  child: Container(
                                    padding: EdgeInsets.all(14),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.shade300,
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 20,
                                          width: 120,
                                          color: Colors.grey.shade300,
                                        ),
                                        SizedBox(height: 7),
                                        Container(
                                          height: 16,
                                          width: 180,
                                          color: Colors.grey.shade300,
                                        ),
                                        SizedBox(height: 7),
                                        Container(
                                          height: 14,
                                          width: 140,
                                          color: Colors.grey.shade300,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                          )
                          : unreadData.isEmpty
                          // ❌ Data kosong → Empty State
                          ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Center(
                              child: Text(
                                "Tidak ada pesan baru",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ),
                          )
                          // ✅ Data ada → render notifikasi
                          : Column(
                            children: [
                              for (var data in unreadData)
                                _buildNotificationItem(
                                  '${data['title']}',
                                  '${data['created_at']}',
                                  0,
                                  data['id'],
                                  data['parameter'] ?? "",
                                  data['description'],
                                  data['orderId']?.toString() ?? "",
                                ),
                            ],
                          );
                    }),
                    SizedBox(height: 16),
                    Divider(color: Colors.grey),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildSectionHeader('Sudah dibaca'),
                        Visibility(
                          visible: controller.idSelected.isEmpty,
                          child: Align(
                            alignment:
                                Alignment.centerRight, // posisinya di kanan
                            child: PopupMenuButton<String>(
                              icon: Icon(Icons.more_vert, color: Colors.teal),
                              onSelected: (value) {
                                if (value == 'markUnread') {
                                  controller.getUnreadNotif(
                                    id: 0,
                                    idNotif: controller.allReadData,
                                  );
                                }
                              },
                              itemBuilder:
                                  (BuildContext context) => [
                                    PopupMenuItem<String>(
                                      value: 'markUnread',
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.mark_email_unread,
                                            color: Colors.teal,
                                          ),
                                          SizedBox(width: 8),
                                          Text("Tandai semua belum dibaca"),
                                        ],
                                      ),
                                    ),
                                  ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    controller.isLoading.value
                        ? ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 3, // jumlah skeleton
                          itemBuilder:
                              (context, index) => Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 8.0,
                                  horizontal: 16.0,
                                ),
                                child: Container(
                                  padding: EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade300,
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        height: 20,
                                        width: 120,
                                        color: Colors.grey.shade300,
                                      ),
                                      SizedBox(height: 7),
                                      Container(
                                        height: 16,
                                        width: 180,
                                        color: Colors.grey.shade300,
                                      ),
                                      SizedBox(height: 7),
                                      Container(
                                        height: 14,
                                        width: 140,
                                        color: Colors.grey.shade300,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                        )
                        : () {
                          final readData =
                              controller.notifData
                                  .where((d) => d['read'] == 1)
                                  .toList();

                          if (readData.isNotEmpty) {
                            return Column(
                              children: [
                                for (var data in readData)
                                  _buildNotificationItem(
                                    '${data['title']}',
                                    '${data['created_at']}',
                                    1,
                                    data['id'],
                                    data['parameter'] ?? "",
                                    data['description'],
                                    data['orderId']?.toString() ?? "",
                                  ),
                              ],
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Center(
                                child: Text(
                                  "Tidak ada pesan yang sudah dibaca",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            );
                          }
                        }(),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSelectAll() {
    final NotificationController controller = Get.put(NotificationController());

    // Checkbox untuk select all
    return Row(
      children: [
        Obx(() {
          // Tentukan status checkbox: true kalau semua yang sesuai filter sudah dipilih
          bool isAllSelected = false;
          if (controller.selectedFilter.value == "Select All") {
            isAllSelected =
                controller.idSelected.length ==
                (controller.allReadData.length +
                    controller.allUnreadData.length);
          } else if (controller.selectedFilter.value == "Read") {
            isAllSelected =
                controller.idSelected.length == controller.allReadData.length &&
                controller.allReadData.isNotEmpty;
          } else if (controller.selectedFilter.value == "Unread") {
            isAllSelected =
                controller.idSelected.length ==
                    controller.allUnreadData.length &&
                controller.allUnreadData.isNotEmpty;
          }

          return Checkbox(
            value: isAllSelected,
            onChanged: (bool? value) {
              if (value == true) {
                // Centang semua sesuai filter
                controller.idSelected.clear();
                if (controller.selectedFilter.value == "Select All") {
                  controller.idSelected.addAll([
                    ...controller.allReadData.map(
                      (id) => {"id": id, "tipe": 1},
                    ),
                    ...controller.allUnreadData.map(
                      (id) => {"id": id, "tipe": 0},
                    ),
                  ]);
                } else if (controller.selectedFilter.value == "Read") {
                  controller.idSelected.addAll(
                    controller.allReadData.map((id) => {"id": id, "tipe": 1}),
                  );
                } else if (controller.selectedFilter.value == "Unread") {
                  controller.idSelected.addAll(
                    controller.allUnreadData.map((id) => {"id": id, "tipe": 0}),
                  );
                }
              } else {
                // Batalin semua
                controller.idSelected.clear();
              }
            },
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          );
        }),

        // Dropdown filter
        Flexible(
          child: UnconstrainedBox(
            alignment: Alignment.centerLeft,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.teal, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Obx(() {
                return DropdownButton<String>(
                  // isExpanded: true,
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
    String parameter,
    String desc,
    String idOrder,
  ) {
    // Cek apakah ID ini sudah ada di idSelected
    bool isChecked = controller.idSelected.any((e) => e['id'] == id);

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
                value: isChecked,
                onChanged: (bool? value) {
                  if (value == true) {
                    // centang -> tambah ke list
                    if (!controller.idSelected.any((e) => e['id'] == id)) {
                      controller.idSelected.add({"id": id, "tipe": tipe});
                    }
                  } else {
                    // batal -> hapus dari list
                    controller.idSelected.removeWhere((e) => e['id'] == id);
                  }
                },
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
                    DateFormat("dd/MM/yyyy HH:mm").format(DateTime.parse(date)),
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
                    parameter: parameter,
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
                  showDeleteBottomSheet(
                    title: "Hapus Pesan",
                    message: "Apakah anda yakin ingin menghapus pesan ini?",
                    onConfirm: () {
                      controller.getDeleteNotif(id: id);
                    },
                  );
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
  String? parameter,
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
                            : Get.toNamed(Routes.INVOICE, arguments: parameter);
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

void showDeleteBottomSheet({
  required String title,
  String? message,
  required VoidCallback onConfirm,
}) {
  showModalBottomSheet(
    backgroundColor: Colors.white,
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
            height: MediaQuery.of(context).size.height * 0.25,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
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

                SizedBox(height: 16),

                if (message != null)
                  Text(
                    message,
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                  ),

                Spacer(),

                // Tombol Aksi
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text("Batal"),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          onConfirm();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(
                          "Hapus",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
