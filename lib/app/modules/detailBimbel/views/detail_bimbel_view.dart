import 'package:flutter/material.dart';

import 'package:get/get.dart';
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
        child: SingleChildScrollView(
          padding: AppStyle.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar dummy
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'https://placehold.co/600x600/png',
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),

              // Judul
              Text(
                'Bimbel SKD CPNS 2024 Batch 12',
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
                  Text('5', style: TextStyle(fontWeight: FontWeight.w700)),
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
                    '100+ Peserta Telah Bergabung',
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
                    _buildRadioOption(
                      'Reguler',
                      'Rp.349.000',
                      'Rp.199.000',
                      controller,
                    ),
                    _buildRadioOption(
                      'Extended',
                      'Rp.399.000',
                      'Rp.239.000',
                      controller,
                    ),
                    _buildRadioOption(
                      'Extended + Platinum Zone',
                      'Rp.498.000',
                      'Rp.289.000',
                      controller,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),

              // Tombol
              OutlinedButton.icon(
                icon: Icon(Icons.favorite_border, color: Colors.teal),
                label: Text(
                  'Tambahkan ke Wishlist +',
                  style: TextStyle(
                    color: Colors.teal,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.teal, width: 2),
                  minimumSize: Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: () {},
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
                  Get.toNamed(Routes.PAYMENT_DETAIL);
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

              // TabBarView (pakai SizedBox agar ada tinggi minimal)
              SizedBox(
                height: 300,
                child: TabBarView(
                  controller: controller.tabController,
                  children: [
                    Center(child: Text('Konten Detail')),
                    Center(child: Text('Konten Jadwal')),
                    Center(child: Text('Konten FAQ')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadioOption(
    String title,
    String oldPrice,
    String newPrice,
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
              Radio<String>(
                value: title,
                groupValue: controller.selectedPaket.value,
                onChanged: (value) {
                  controller.pilihPaket(value!);
                },
                activeColor: Colors.teal, // 🎯 bikin bulatan aktif jadi teal
              ),
              Align(alignment: Alignment.center, child: Text(title)),
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
