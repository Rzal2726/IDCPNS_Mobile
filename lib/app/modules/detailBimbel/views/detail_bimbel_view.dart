import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/converts.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';
import 'package:idcpns_mobile/styles/app_style.dart';

import '../controllers/detail_bimbel_controller.dart';

class DetailBimbelView extends GetView<DetailBimbelController> {
  const DetailBimbelView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Get.back(),
          ),
          title: Text('Detail Bimbel', style: TextStyle(color: Colors.black)),
          actions: [
            IconButton(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(Icons.notifications_none, color: Colors.teal),
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        '9+',
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ),
                ],
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          var data = controller.datalBimbelData;
          return SingleChildScrollView(
            padding: AppStyle.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar dummy
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    '${data['gambar']}',
                    width: double.infinity,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 16),

                // Judul
                Text(
                  '${data['name']}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 8),

                // Rating dan peserta
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '${data['review']}',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    SizedBox(width: 8),
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.people, color: Colors.amber, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '${data['jumlah_dibeli']} Peserta Telah Bergabung',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                SizedBox(height: 25),
                // Jenis Paket
                Text(
                  'Jenis Paket',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Obx(
                  () => Column(
                    children: [
                      for (var subData in data['bimbel'])
                        _buildRadioOption(
                          '${subData['name']}',
                          '${formatRupiah(subData['harga'])}',
                          '${formatRupiah(subData['harga_fix'])}',
                          subData['id'],
                          controller,
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 16),

                // Tombol
                OutlinedButton.icon(
                  icon: Icon(
                    controller.datalCheckList.isNotEmpty
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color:
                        controller.datalCheckList.isNotEmpty
                            ? Colors.white
                            : Colors.teal,
                  ),
                  label: Text(
                    controller.datalCheckList.isNotEmpty
                        ? 'Hapus dari Wishlist -'
                        : 'Tambahkan ke Wishlist +',
                    style: TextStyle(
                      color:
                          controller.datalCheckList.isNotEmpty
                              ? Colors.white
                              : Colors.teal,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    backgroundColor:
                        controller.datalCheckList.isNotEmpty
                            ? Colors.teal
                            : Colors.white,
                    side: BorderSide(color: Colors.teal, width: 2),
                    minimumSize: const Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    if (controller.datalCheckList.isNotEmpty) {
                      controller.getDeleteWhisList();
                    } else {
                      controller.getAddWhislist();
                    }
                  },
                ),

                SizedBox(height: 8),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    minimumSize: Size.fromHeight(50),
                    shape: RoundedRectangleBorder(
                      // 🔹 border radius
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    if (controller.selectedPaket.value == 0) {
                      Get.snackbar(
                        "Peringatan",
                        "Silakan pilih paket terlebih dahulu.",
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red.withOpacity(0.8),
                        colorText: Colors.white,
                      );
                      return; // stop di sini
                    }

                    // lanjut kalau sudah pilih paket
                    Get.toNamed(
                      Routes.PAYMENT_DETAIL,
                      arguments: [data["uuid"], controller.selectedPaket.value],
                    );
                  },

                  child: Text(
                    'Daftar Sekarang',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // TabBar
                TabBar(
                  controller: controller.tabController,
                  labelColor: Colors.teal,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: Colors.teal,
                  tabs: [
                    Tab(text: 'Detail'),
                    Tab(text: 'Jadwal'),
                    Tab(text: 'FAQ'),
                  ],
                ),
                SizedBox(height: 12),

                Obx(() {
                  switch (controller.currentIndex.value) {
                    case 0:
                      return Html(data: data['deskripsi_pc']);
                    case 1:
                      return Text('Konten Jadwal');
                    case 2:
                      return Html(data: data['faq_pc']);
                    default:
                      return SizedBox.shrink();
                  }
                }),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildRadioOption(
    String title,
    String oldPrice,
    String newPrice,
    int id,
    DetailBimbelController controller,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Kiri: Radio + Title
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Radio<int>(
                value: id, // ✅ sekarang valuenya ID, bukan title
                groupValue: controller.selectedPaket.value,
                onChanged: (value) {
                  controller.pilihPaket(value!); // yg kepilih ID
                },
                activeColor: Colors.teal,
              ),
              Text(
                title, // 👈 yang dilihat user tetap title
                style: TextStyle(fontSize: 14), // opsional, biar rapi
              ),
            ],
          ),

          // Kanan: Harga lama + baru
          Column(
            crossAxisAlignment: CrossAxisAlignment.start, // tetap rata kiri
            mainAxisAlignment:
                MainAxisAlignment.center, // biar posisinya vertikal center
            children: [
              Text(
                oldPrice,
                style: TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 4), // pakai height biar rapi, jangan width
              Text(
                newPrice,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
