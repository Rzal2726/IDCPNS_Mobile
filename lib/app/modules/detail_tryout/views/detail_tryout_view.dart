import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/detail_tryout_controller.dart';

class DetailTryoutView extends GetView<DetailTryoutController> {
  DetailTryoutView({super.key});
  final controller = Get.put(DetailTryoutController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(25),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: AppBar(
            elevation: 0,
            scrolledUnderElevation: 0,
            title: const Text('Detail Tryout'),
            centerTitle: false,
            backgroundColor: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        controller.detailData['gambar'] == null
                            ? Skeletonizer(child: Icon(Icons.image_search))
                            : Image.network(
                              controller.detailData['gambar'] ??
                                  '', // pastikan ada url
                              fit: BoxFit.cover,
                              loadingBuilder: (
                                context,
                                child,
                                loadingProgress,
                              ) {
                                if (loadingProgress == null)
                                  return child; // ✅ tampilkan gambar kalau sudah selesai
                                return Center(
                                  child: CircularProgressIndicator(
                                    value:
                                        loadingProgress.expectedTotalBytes !=
                                                null
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
                            ? Skeletonizer(
                              enabled: true,
                              child: Text(
                                "Judul Tryout Formasi Judul Tryout Formasi Judul Tryout Formasi",
                              ),
                            )
                            : Text(
                              textAlign: TextAlign.start,
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
                child: Obx(
                  () => Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.star, color: Colors.orange),
                      SizedBox(width: 4),
                      controller.detailData['review'] == null
                          ? Skeletonizer(child: Text("5"))
                          : Text("${controller.detailData['review']}"),
                      SizedBox(width: 4),
                      Icon(Icons.circle, size: 8),
                      SizedBox(width: 4),
                      Icon(Icons.people, color: Colors.orange),
                      SizedBox(width: 4),
                      controller.detailData['jumlah_dibeli'] == null
                          ? Skeletonizer(child: Text("500+ Sudah Bergabung"))
                          : Text(
                            "${controller.detailData['jumlah_dibeli']} Sudah Bergabung",
                          ),
                    ],
                  ),
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
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
                    Obx(
                      () =>
                          controller.detailData['harga_fix'] == null
                              ? Skeletonizer(
                                enabled: true,
                                child: Text("Rp.50.000"),
                              )
                              : Text(
                                controller.formatCurrency(
                                  controller.detailData['harga_fix'].toString(),
                                ),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),

              Obx(
                () =>
                    controller.detailData.isEmpty
                        ? Skeletonizer(
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text("data"),
                          ),
                        )
                        : Container(
                          margin: EdgeInsets.symmetric(horizontal: 32),
                          child: Obx(
                            () =>
                                controller.detailData['is_purchase'] == true
                                    ? SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Get.toNamed(
                                            "tryout-saya",
                                            arguments:
                                                controller.detailData['uuid'],
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.teal.shade300,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                          ),
                                        ),
                                        child: Text("Tryout Saya"),
                                      ),
                                    )
                                    : Row(
                                      children: [
                                        Expanded(
                                          child: Obx(
                                            () => ElevatedButton(
                                              onPressed:
                                                  controller.isLoading['wishlist'] ==
                                                          true
                                                      ? null // disable tombol saat loading
                                                      : () async {
                                                        bool success;
                                                        if (!controller
                                                            .isOnWishlist
                                                            .value) {
                                                          success =
                                                              await controller
                                                                  .addToWishList();
                                                          _showSnackBar(
                                                            context,
                                                            success,
                                                            "Wishlist berhasil disimpan!",
                                                            "Gagal menyimpan wishlist!",
                                                          );
                                                          if (success)
                                                            controller
                                                                .isOnWishlist
                                                                .value = true;
                                                        } else {
                                                          success =
                                                              await controller
                                                                  .removeFromWishList();
                                                          _showSnackBar(
                                                            context,
                                                            success,
                                                            "Wishlist berhasil dihapus!",
                                                            "Gagal menghapus wishlist!",
                                                          );
                                                          if (success)
                                                            controller
                                                                .isOnWishlist
                                                                .value = false;
                                                        }
                                                      },
                                              style: ElevatedButton.styleFrom(
                                                elevation: 0,
                                                foregroundColor:
                                                    Colors.teal.shade300,
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  side: BorderSide(
                                                    color: Colors.teal.shade300,
                                                    width: 1.5,
                                                  ),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      vertical: 12,
                                                    ),
                                              ),
                                              child:
                                                  controller.isLoading['wishlist'] ==
                                                          true
                                                      ? const SizedBox(
                                                        height: 20,
                                                        width: 20,
                                                        child:
                                                            CircularProgressIndicator(
                                                              strokeWidth: 2,
                                                            ),
                                                      )
                                                      : Text(
                                                        controller
                                                                .isOnWishlist
                                                                .value
                                                            ? "Hapus Dari Wishlist -"
                                                            : "Tambahkan Ke Wishlist +",
                                                      ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 8,
                                        ), // jarak antar tombol
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              controller.selectedUUid.value =
                                                  controller.detailData['uuid'];
                                              Get.toNamed("/tryout-payment");
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  Colors.teal.shade300,
                                              foregroundColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 12,
                                                  ),
                                            ),
                                            child: Text("Daftar"),
                                          ),
                                        ),
                                      ],
                                    ),
                          ),
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

                if (controller.isLoading['detail'] == true) {
                  return const Center(child: CircularProgressIndicator());
                }

                switch (option) {
                  case "Bundling":
                    return SingleChildScrollView(
                      child: Skeletonizer(
                        enabled: controller.isLoading['detail']!,
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
                      ),
                    );

                  case "FAQ":
                    return Skeletonizer(
                      enabled: controller.isLoading['detail']!,
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        child:
                            controller.FAQ.value.isEmpty
                                ? const Center(child: Text("Tidak ada FAQ"))
                                : _htmlCard(controller.FAQ.value),
                      ),
                    );

                  default: // Detail
                    return Skeletonizer(
                      enabled: controller.isLoading['detail']!,
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        child:
                            controller.Detail.value.isEmpty
                                ? const Skeletonizer(
                                  enabled: true,
                                  child: Text(
                                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer vel velit in nisi pulvinar ornare. Integer faucibus mauris nec mauris aliquet, eget molestie tortor auctor. Phasellus sit amet congue purus. Curabitur cursus mauris quis sapien aliquet rhoncus. Donec semper nibh mollis orci posuere pulvinar. Vestibulum suscipit eu massa elementum efficitur",
                                  ),
                                )
                                : _htmlCard(controller.Detail.value),
                      ),
                    );
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _cardBundling(String Judul, String soal, String durasi) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border.all(color: Colors.grey, width: 0.5),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Container(
      padding: EdgeInsets.all(12),
      child: Column(
        children: [
          Text(Judul, style: TextStyle(fontSize: 16)),
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
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Html(
      data: isi,
      style: {
        ".mt-3": Style(margin: Margins.only(top: 12)),
        ".p-4": Style(padding: HtmlPaddings.all(16)),
        ".border": Style(border: Border.all(color: Colors.grey.shade300)),
        ".text-lg": Style(fontSize: FontSize(18)),
        ".font-bold": Style(fontWeight: FontWeight.bold),
        ".text-muted-700": Style(color: Colors.grey.shade700),
      },
    ),
  );
}

void _showSnackBar(
  BuildContext context,
  bool success,
  String successMessage,
  String failureMessage,
) {
  Get.snackbar(
    success ? "Berhasil" : "Gagal",
    success ? successMessage : failureMessage,
    backgroundColor: success ? Colors.teal : Colors.pink,
    colorText: Colors.white,
  );
}
