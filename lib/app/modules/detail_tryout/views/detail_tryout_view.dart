import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';

import '../controllers/detail_tryout_controller.dart';

class DetailTryoutView extends GetView<DetailTryoutController> {
  DetailTryoutView({super.key});
  final controller = Get.put(DetailTryoutController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: const Text('Detail Tryout'),
        centerTitle: false,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.transparent),
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              padding: EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  16,
                ), // <-- radius untuk gambar
                child: Obx(
                  () =>
                      controller.isLoading.value == true
                          ? CircularProgressIndicator()
                          : Image.network(
                            controller.detailData['gambar'] ??
                                '', // pastikan ada url
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null)
                                return child; // ✅ tampilkan gambar kalau sudah selesai
                              return Center(
                                child: CircularProgressIndicator(
                                  value:
                                      loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress
                                                  .cumulativeBytesLoaded /
                                              (loadingProgress
                                                      .expectedTotalBytes ??
                                                  1)
                                          : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.broken_image,
                                size: 50,
                                color: Colors.grey,
                              );
                            },
                          ),
                ),
              ),
            ),

            Obx(
              () => Container(
                margin: EdgeInsets.symmetric(horizontal: 32.0),
                child: Container(
                  child:
                      controller.detailData['formasi'] == null
                          ? CircularProgressIndicator()
                          : Text(
                            controller.detailData['formasi'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                          ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.star, color: Colors.orange),
                  SizedBox(width: 4),
                  Text("5"),
                  SizedBox(width: 4),
                  Icon(Icons.circle, size: 8),
                  SizedBox(width: 4),
                  Icon(Icons.people, color: Colors.orange),
                  SizedBox(width: 4),
                  Text("500+ Sudah Bergabung"),
                ],
              ),
            ),
            SizedBox(height: 8),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Jenis Paket",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 32.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text("Bundling"),
                  Text(
                    "Rp.50.000",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                children: [
                  Expanded(
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: () async {
                          if (!controller.isLoading.value) {
                            ScaffoldMessenger.of(context).clearSnackBars();

                            bool success;
                            if (controller.isOnWishlist.value == false) {
                              success = await controller.addToWishList();
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      "Wishlist berhasil disimpan!",
                                    ),
                                    duration: Duration(seconds: 2),
                                    backgroundColor: Colors.teal,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Gagal menyimpan wishlist!"),
                                    duration: Duration(seconds: 2),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            } else {
                              success = await controller.removeFromWishList();
                              if (success) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Wishlist berhasil dihapus!"),
                                    duration: Duration(seconds: 2),
                                    backgroundColor: Colors.teal,
                                  ),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text("Gagal menghapus wishlist!"),
                                    duration: Duration(seconds: 2),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            }
                          }
                        },

                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          foregroundColor: Colors.teal.shade300,
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: Colors.teal.shade300, // ganti warna border
                              width: 1.5,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child:
                            controller.isOnWishlist.value == false
                                ? Text("Tambahkan Ke Wishlist +")
                                : Text("Hapus Dari Wishlist -"),
                      ),
                    ),
                  ),
                  SizedBox(width: 8), // jarak antar tombol
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, "/tryout-payment");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal.shade300,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: Text("Daftar"),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),

            Obx(() {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children:
                    controller.option.map((option) {
                      final isSelected =
                          controller.selectedOption.value == option;
                      return GestureDetector(
                        onTap: () => controller.selectedOption.value = option,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                option,
                                style: TextStyle(
                                  color:
                                      isSelected
                                          ? Colors.teal
                                          : Colors.grey[700],
                                  fontWeight:
                                      isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                ),
                              ),
                              SizedBox(height: 4),
                              AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                height: 2,
                                width: isSelected ? 20 : 0,
                                color: Colors.teal,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
              );
            }),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color.fromARGB(250, 240, 240, 240)),
                ),
              ),
            ),

            Obx(() {
              final option = controller.selectedOption.value;

              if (option == "Bundling") {
                return SingleChildScrollView(
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.bundling.length,
                      itemBuilder: (context, index) {
                        final data = controller.bundling[index];
                        return _cardBundling(
                          data['name'] ?? "",
                          data['jumlah_soal']?.toString() ?? "",
                          data['waktu_pengerjaan']?.toString() ?? "",
                        );
                      },
                    ),
                  ),
                );
              }

              if (option == "FAQ") {
                return Container(
                  margin: const EdgeInsets.all(16),
                  child:
                      controller.FAQ.value == null
                          ? const Center(child: CircularProgressIndicator())
                          : _htmlCard(controller.FAQ.value ?? ''),
                );
              }

              // Default -> Detail
              return Container(
                margin: const EdgeInsets.all(16),
                child:
                    controller.Detail.value == null
                        ? const Center(child: CircularProgressIndicator())
                        : _htmlCard(controller.Detail.value ?? ''),
              );
            }),
          ],
        ),
      ),
    );
  }
}

Widget _cardBundling(String Judul, String soal, String durasi) {
  return Card(
    elevation: 0, // hapus shadow
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: BorderSide(
        color: Colors.grey, // ganti warna border
        width: 0.5,
      ),
    ),
    color: Colors.white,

    child: Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Row(children: [Text(Judul, style: TextStyle(fontSize: 16))]),
          SizedBox(height: 8),
          Row(
            spacing: 8,
            children: [
              Icon(Icons.list, color: Colors.blueAccent),
              Text("${soal} Soal"),
              Icon(Icons.timer, color: Colors.teal),
              Text("${durasi} Menit"),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _htmlCard(String isi) {
  return Html(
    data: isi,
    style: {
      ".mt-3": Style(margin: Margins.only(top: 12)),
      ".p-4": Style(padding: HtmlPaddings.all(16)),
      ".border": Style(border: Border.all(color: Colors.grey.shade300)),
      ".text-lg": Style(fontSize: FontSize(18)),
      ".font-bold": Style(fontWeight: FontWeight.bold),
      ".text-muted-700": Style(color: Colors.grey.shade700),
    },
  );
}
