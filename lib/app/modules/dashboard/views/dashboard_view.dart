import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Highlight Section
            Text(
              'Highlight',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.blue.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'Banner Highlight\n(Placeholder)',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 24),

            // Pilih Layanan
            Text(
              'Pilih Layanan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text('Pilih layanan yang cocok sebagai teman belajar kamu'),
            SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: _buildServiceCard(
                    Icons.assignment,
                    'Tryout',
                    Colors.teal,
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: _buildServiceCard(Icons.school, 'Bimbel', Colors.teal),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: _buildServiceCard(
                    Icons.star,
                    'Platinum',
                    Colors.orange,
                    badge: 'Baru',
                  ),
                ),
              ],
            ),

            SizedBox(height: 24),

            // Pilih Kategori
            Text(
              'Pilih Kategori',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              style: TextStyle(color: Colors.grey),
              'Pilih kategori yang cocok sebagai teman belajar kamu',
            ),
            SizedBox(height: 16),

            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[300]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: GridView.count(
                crossAxisCount: 3,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                children: [
                  _buildCategoryItem('CPNS'),
                  _buildCategoryItem('BUMN'),
                  _buildCategoryItem('Kedinasan'),
                  _buildCategoryItem('Kategori 4'),
                  _buildCategoryItem('Kategori 5'),
                  _buildCategoryItem('Kategori 6'),
                ],
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Rekomendasi Penunjang Program CPNS',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text(
              style: TextStyle(color: Colors.grey),
              'Pilihan utama kami untuk anda',
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey[300]!),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 240,
                      width: 240,
                      decoration: BoxDecoration(color: const Color(0xFF5E9F94)),
                      child: Center(
                        // Menggunakan placeholder untuk gambar dummy
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.school,
                              size: 60,
                              color: Color(0xFF5E9F94),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Area gambar dengan background dan icon dummy
                  const SizedBox(height: 16),
                  // Judul "Platinum"
                  const Text(
                    'Platinum',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFCD915B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Deskripsi
                  const Text(
                    'Upgrade jenis akun Anda menjadi Platinum dan dapatkan berbagai macam fitur unggulan seperti Video Series, E-book, Tryout Harian, dan Webinar yang dapat meningkatkan persiapan kamu lebih optimal lagi.',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 16),
                  // Harga coret
                  const Text(
                    'Rp.149.000 - Rp.774.000',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                      decorationColor: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // Harga utama
                  const Text(
                    'Rp.129.000 - Rp.239.000',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  // Judul dan deskripsi
                  Text(
                    'Event Tryout Gratis',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    style: TextStyle(color: Colors.grey),
                    'Ikuti event tryout dari rekomendasi kita untuk anda!',
                  ),
                  const SizedBox(height: 16),
                  // Search field
                  Container(
                    height: 50,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.teal, width: 1.5),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 15.0,
                        ), // Sesuaikan nilai vertical
                        hintText: 'Cari',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        suffixIcon: Icon(Icons.search, color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Tombol Filter
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        foregroundColor:
                            Colors.teal, // Mengatur warna teks dan ikon
                      ),
                      child: Row(
                        mainAxisSize:
                            MainAxisSize
                                .min, // Agar Row tidak mengambil lebar penuh
                        children: [
                          Text('Filter', style: TextStyle(fontSize: 16)),
                          SizedBox(
                            width: 4,
                          ), // Memberikan jarak antara teks dan ikon
                          Icon(Icons.filter_list),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Tampilan kosong (empty state)
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 50), // Jarak atas yang lebih jauh
                        Icon(
                          Icons.archive_outlined,
                          size: 100,
                          color: Colors.black38,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Belum Ada Event Berlangsung',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                        SizedBox(height: 50), // Jarak bawah yang lebih jauh
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Rekomendasi Tryout',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            //
            Text(
              'Ikuti event tryout dari rekomendasi kita untuk anda!',
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 24),
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.blue.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'Banner Highlight\n(Placeholder)',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            SizedBox(height: 24),

            Container(
              height: 150,
              child: Center(
                child: Text(
                  'belum ada event',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey, fontSize: 20),
                ),
              ),
            ),
            SizedBox(height: 24),

            Text(
              'Program Afiliasi',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),

            Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.blue.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  'Banner Highlight\n(Placeholder)',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
            //
            SizedBox(height: 24),

            Text(
              'Bantuan Cepat',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bantuan Cepat',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildHelpContainer(
                      title: 'Hubungi Kami',
                      description:
                          'Punya pertanyaan atau bantuan? Silahkan hubungi kami.',
                      buttonText: 'Hubungi Kami',
                    ),
                    const SizedBox(width: 16),
                    _buildHelpContainer(
                      title: 'Panduan',
                      description:
                          'Pengguna baru? Silahkan baca panduan terlebih dahulu.',
                      buttonText: 'Panduan',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildHelpContainer({
  required String title,
  required String description,
  required String buttonText,
}) {
  return Expanded(
    child: Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.grey.shade300, width: 1),
        boxShadow: [
          BoxShadow(g
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
          const SizedBox(height: 16),
          Divider(color: Colors.grey[400], height: 1),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF16A085),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12.0),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildServiceCard(
  IconData icon,
  String title,
  Color color, {
  String? badge,
}) {
  return Stack(
    children: [
      Container(
        width: 100,
        height: 140,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 32),
            SizedBox(height: 8),
            Text(title, style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
      if (badge != null)
        Positioned(
          right: 4,
          top: 4,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              badge,
              style: TextStyle(color: Colors.white, fontSize: 10),
            ),
          ),
        ),
    ],
  );
}

Widget _buildCategoryItem(String title) {
  return Container(
    child: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center, // vertikal center
        crossAxisAlignment: CrossAxisAlignment.center, // horizontal center
        children: [
          Icon(Icons.apartment, size: 32, color: Colors.teal),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
