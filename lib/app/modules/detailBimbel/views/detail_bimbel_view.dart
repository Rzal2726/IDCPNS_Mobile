import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/detail_bimbel_controller.dart';

class DetailBimbelView extends GetView<DetailBimbelController> {
  const DetailBimbelView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Get.back(),
          ),
          title: const Text(
            'Detail Bimbel',
            style: TextStyle(color: Colors.black),
          ),
          actions: [
            IconButton(
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.notifications_none, color: Colors.teal),
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: const Text(
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
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar dummy
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  'https://placehold.co/600x400/png',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),

              // Judul
              const Text(
                'Bimbel SKD CPNS 2024 Batch 12',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              // Rating dan peserta
              Row(
                children: const [
                  Icon(Icons.star, color: Colors.amber, size: 16),
                  SizedBox(width: 4),
                  Text('5.0'),
                  SizedBox(width: 8),
                  Icon(Icons.people, color: Colors.grey, size: 16),
                  SizedBox(width: 4),
                  Text('100+ Peserta Telah Bergabung'),
                ],
              ),
              const SizedBox(height: 16),

              // Jenis Paket
              const Text(
                'Jenis Paket',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

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
              const SizedBox(height: 16),

              // Tombol
              OutlinedButton.icon(
                icon: const Icon(Icons.favorite_border, color: Colors.teal),
                label: const Text(
                  'Tambahkan ke Wishlist +',
                  style: TextStyle(color: Colors.teal),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.teal),
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {},
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  minimumSize: const Size.fromHeight(50),
                ),
                onPressed: () {
                  Get.snackbar(
                    'Daftar',
                    'Kamu memilih paket: ${controller.selectedPaket.value}',
                  );
                },
                child: const Text('Daftar Sekarang'),
              ),
              const SizedBox(height: 20),

              // TabBar
              TabBar(
                controller: controller.tabController,
                labelColor: Colors.teal,
                unselectedLabelColor: Colors.grey,
                indicatorColor: Colors.teal,
                tabs: const [
                  Tab(text: 'Detail'),
                  Tab(text: 'Jadwal'),
                  Tab(text: 'FAQ'),
                ],
              ),
              const SizedBox(height: 12),

              // TabBarView (pakai SizedBox agar ada tinggi minimal)
              SizedBox(
                height: 300,
                child: TabBarView(
                  controller: controller.tabController,
                  children: const [
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
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      subtitle: Row(
        children: [
          Text(
            oldPrice,
            style: const TextStyle(
              decoration: TextDecoration.lineThrough,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            newPrice,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.teal,
            ),
          ),
        ],
      ),
      leading: Radio<String>(
        value: title,
        groupValue: controller.selectedPaket.value,
        onChanged: (value) {
          controller.pilihPaket(value!);
        },
      ),
    );
  }
}
