import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/modules/notification/views/notification_view.dart';

import '../controllers/e_book_controller.dart';

class EBookView extends GetView<EBookController> {
  const EBookView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text("E-Book"),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications_rounded, color: Colors.teal),
                onPressed: () {
                  // ✅ Best practice: use a function for navigation
                  Get.to(() => NotificationView());
                },
              ),
              Positioned(
                right: 10,
                top: 10,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '4',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.white,
                      ),
                      iconAlignment: IconAlignment.end,
                      onPressed: () {
                        // showModalBottomSheet(
                        //   context: context,
                        //   builder: (ctx) {
                        //     return StatefulBuilder(
                        //       builder: (context, setState) {
                        //         return Container(
                        //           color: Colors.white,
                        //           padding: EdgeInsets.all(16),
                        //           child: Column(
                        //             mainAxisSize:
                        //                 MainAxisSize
                        //                     .min, // biar bottomsheet menyesuaikan isi
                        //             crossAxisAlignment:
                        //                 CrossAxisAlignment.start,
                        //             children: [
                        //               const Text(
                        //                 "Jenis Tryout",
                        //                 style: TextStyle(
                        //                   fontSize: 16,
                        //                   fontWeight: FontWeight.bold,
                        //                 ),
                        //               ),
                        //               const SizedBox(height: 8),

                        //               Obx(
                        //                 () => Wrap(
                        //                   spacing: 8,
                        //                   children:
                        //                       controller.options.value.map((
                        //                         option,
                        //                       ) {
                        //                         final isSelected =
                        //                             controller
                        //                                 .selectedEventKategori
                        //                                 .value ==
                        //                             option;
                        //                         return ChoiceChip(
                        //                           label: Text(
                        //                             option,
                        //                             style: TextStyle(
                        //                               color:
                        //                                   isSelected
                        //                                       ? Colors.teal
                        //                                       : Colors
                        //                                           .grey[700],
                        //                               fontWeight:
                        //                                   isSelected
                        //                                       ? FontWeight.bold
                        //                                       : FontWeight
                        //                                           .normal,
                        //                             ),
                        //                           ),
                        //                           selected: isSelected,
                        //                           selectedColor: Colors.teal
                        //                               .withOpacity(0.1),
                        //                           backgroundColor: Colors.white,
                        //                           shape: RoundedRectangleBorder(
                        //                             side: BorderSide(
                        //                               color:
                        //                                   isSelected
                        //                                       ? Colors.teal
                        //                                       : Colors
                        //                                           .grey
                        //                                           .shade400,
                        //                             ),
                        //                             borderRadius:
                        //                                 BorderRadius.circular(
                        //                                   6,
                        //                                 ),
                        //                           ),
                        //                           onSelected: (value) {
                        //                             controller
                        //                                 .selectedEventKategori
                        //                                 .value = option;
                        //                           },
                        //                         );
                        //                       }).toList(),
                        //                 ),
                        //               ),

                        //               const SizedBox(height: 12),
                        //               SizedBox(
                        //                 width: double.infinity,
                        //                 child: ElevatedButton(
                        //                   style: ElevatedButton.styleFrom(
                        //                     backgroundColor:
                        //                         Colors.teal, // warna tombol
                        //                     foregroundColor:
                        //                         Colors.white, // warna teks/icon
                        //                     shape: RoundedRectangleBorder(
                        //                       borderRadius:
                        //                           BorderRadius.circular(8),
                        //                     ),
                        //                     padding: const EdgeInsets.symmetric(
                        //                       horizontal: 24,
                        //                       vertical: 12,
                        //                     ),
                        //                   ),
                        //                   onPressed: () {
                        //                     Navigator.pop(context);
                        //                     controller.showEventTryout(
                        //                       name: eventTextController.text,
                        //                       category:
                        //                           controller
                        //                               .selectedEventKategori
                        //                               .value,
                        //                     );
                        //                   },
                        //                   child: const Text("Cari"),
                        //                 ),
                        //               ),
                        //             ],
                        //           ),
                        //         );
                        //       },
                        //     );
                        //   },
                        // );
                      },
                      label: Text(
                        "Filter",
                        style: TextStyle(color: Colors.teal),
                      ),
                      icon: Icon(Icons.arrow_drop_down, color: Colors.teal),
                    ),
                  ],
                ),
                _dataCard(
                  category: "CPNS",
                  judul: "Teks Materi Lengkap CPNS",
                  categoryColor: Colors.teal,
                  bab: "23",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dataCard({
    required String category,
    required String judul,
    required Color categoryColor,
    required String bab,
  }) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        padding: EdgeInsets.all(12),
        child: Column(
          spacing: 12,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 100,
              child: _badge(
                title: category,
                foregroundColor: Colors.white,
                backgroundColor: categoryColor,
              ),
            ),
            Text(
              judul,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text("${bab} Subab", style: TextStyle(color: Colors.grey)),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: () {},
                child: const Text(
                  "Buka E-Book",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _badge({
    required String title,
    required Color foregroundColor,
    required Color backgroundColor,
  }) {
    return Card(
      color: backgroundColor,
      elevation: 0,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Center(
          child: Text(title, style: TextStyle(color: foregroundColor)),
        ),
      ),
    );
  }
}
