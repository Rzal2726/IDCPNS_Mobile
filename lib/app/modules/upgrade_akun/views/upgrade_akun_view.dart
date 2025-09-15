import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/modules/notification/views/notification_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/upgrade_akun_controller.dart';

class UpgradeAkunView extends GetView<UpgradeAkunController> {
  const UpgradeAkunView({super.key});
  @override
  Widget build(BuildContext context) {
    String? selectedValue;

    final List<Map<String, dynamic>> features = [
      {"name": "50+ Video Series", "platinum": true, "basic": false},
      {"name": "20+ Materi Ebook", "platinum": true, "basic": false},
      {"name": "Ratusan Soal", "platinum": true, "basic": false},
    ];

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
            backgroundColor: Colors.white,
            elevation: 0,
            scrolledUnderElevation: 0,
            title: Text("Upgrade Akun"),
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.notifications_rounded, color: Colors.teal),
                    onPressed: () {
                      Get.to(NotificationView());
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
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Jenis Paket",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Obx(
                        () =>
                            controller.listDurasi.isEmpty
                                ? Skeletonizer(
                                  child: RadioListTile<String>(
                                    value: "",
                                    groupValue: selectedValue,
                                    onChanged: (value) {
                                      selectedValue = value;
                                    },
                                    contentPadding: EdgeInsets.zero,
                                    title: Text("lorem ipsum"),
                                    subtitle: Row(
                                      children: [
                                        Text(
                                          "Rp.${(10000).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => "${m[1]}.")}",
                                          style: const TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough,
                                            color: Colors.grey,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          "Rp.${(10000).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => "${m[1]}.")}",
                                          style: const TextStyle(
                                            color: Colors.teal,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                : SizedBox(
                                  width: double.infinity,
                                  height: 180,
                                  child: ListView.builder(
                                    padding: const EdgeInsets.all(16),
                                    shrinkWrap:
                                        true, // Penting jika di dalam Column atau SingleChildScrollView
                                    physics:
                                        const NeverScrollableScrollPhysics(), // Agar scroll tetap pakai parent
                                    itemCount: controller.listDurasi.length,
                                    itemBuilder: (context, index) {
                                      final item = controller.listDurasi[index];

                                      return Obx(
                                        () => RadioListTile<String>(
                                          value: item["uuid"].toString(),
                                          groupValue:
                                              controller.selectedDurasi.value,
                                          onChanged: (value) {
                                            controller.selectedDurasi.value =
                                                value ?? "";
                                          },
                                          contentPadding: EdgeInsets.zero,
                                          title: Text(item["name"] ?? ""),
                                          subtitle: Row(
                                            children: [
                                              // Harga asli dicoret
                                              Text(
                                                "Rp.${item["harga"].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => "${m[1]}.")}",
                                                style: const TextStyle(
                                                  decoration:
                                                      TextDecoration
                                                          .lineThrough,
                                                  color: Colors.grey,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              // Harga fix
                                              Text(
                                                "Rp.${item["harga_fix"].toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => "${m[1]}.")}",
                                                style: const TextStyle(
                                                  color: Colors.teal,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                      ),

                      Obx(
                        () =>
                            controller.listBonus.isEmpty
                                ? CircularProgressIndicator()
                                : SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.teal, // warna tombol
                                      foregroundColor:
                                          Colors.white, // warna teks/icon
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 12,
                                      ),
                                    ),
                                    onPressed:
                                        () => showModalBottomSheet(
                                          context: context,
                                          backgroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                              top: Radius.circular(16),
                                            ),
                                          ),
                                          builder: (context) {
                                            return SafeArea(
                                              child: SingleChildScrollView(
                                                child: Container(
                                                  padding: const EdgeInsets.all(
                                                    16,
                                                  ),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: const [
                                                              Text(
                                                                "Bonus",
                                                                style: TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                              Text(
                                                                "Silahkan Pilih Bonus",
                                                              ),
                                                            ],
                                                          ),
                                                          IconButton(
                                                            onPressed:
                                                                () =>
                                                                    Navigator.pop(
                                                                      context,
                                                                    ),
                                                            icon: Icon(
                                                              Icons.close,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Column(
                                                        children:
                                                            controller.listBonus.map((
                                                              element,
                                                            ) {
                                                              return _bonusCard(
                                                                badgeText:
                                                                    element['menu_category']?['menu'] ??
                                                                    "CPNS",
                                                                badgeColor:
                                                                    Colors.teal,
                                                                title:
                                                                    element['formasi'] ??
                                                                    "Bonus CPNS",
                                                                uuid:
                                                                    element['uuid']
                                                                        .toString(),
                                                              );
                                                            }).toList(),
                                                      ),
                                                      SizedBox(
                                                        width: double.infinity,
                                                        child: ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                            backgroundColor:
                                                                Colors
                                                                    .teal, // warna tombol
                                                            foregroundColor:
                                                                Colors
                                                                    .white, // warna teks/icon
                                                            shape: RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    8,
                                                                  ),
                                                            ),
                                                            padding:
                                                                const EdgeInsets.symmetric(
                                                                  horizontal:
                                                                      12,
                                                                  vertical: 12,
                                                                ),
                                                          ),
                                                          onPressed: () {
                                                            Navigator.pop(
                                                              context,
                                                            );
                                                            controller
                                                                .upgradeSekarang();
                                                          },
                                                          child: Text(
                                                            "Lanjutkan Pembayaran",
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                    child: Text("Upgrade Sekarang"),
                                  ),
                                ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                  ),
                ),
                SizedBox(height: 32),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      const Expanded(
                        flex: 2,
                        child: Text(
                          "Fitur",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.teal.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              "Platinum",
                              style: TextStyle(
                                color: Colors.teal,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Center(
                            child: Text(
                              "Basic",
                              style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Daftar fitur
                ...features.map((feature) {
                  return Container(
                    margin: EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            // Nama fitur
                            Expanded(
                              flex: 2,
                              child: Text(
                                feature["name"],
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                            // Platinum
                            Expanded(
                              child: Center(
                                child: Icon(
                                  feature["platinum"]
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  color:
                                      feature["platinum"]
                                          ? Colors.teal
                                          : Colors.red,
                                ),
                              ),
                            ),
                            // Basic
                            Expanded(
                              child: Center(
                                child: Icon(
                                  feature["basic"]
                                      ? Icons.check_circle
                                      : Icons.cancel,
                                  color:
                                      feature["basic"]
                                          ? Colors.teal
                                          : Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(thickness: 0.5, color: Colors.grey),
                      ],
                    ),
                  );
                }).toList(),
                SizedBox(height: 16),
                Html(
                  data: """
              <div class="flex flex-col justify-start mt-10">
              <p>
                Segera upgrade jenis akun Anda menjadi Platinum dan dapatkan
                berbagai macam fitur unggulan yang dapat meningkatkan persiapan
                kamu lebih optimal lagi.
              </p>
              <p class="font-bold mt-8"><b>Video Series</b></p>
              <p>
                Fitur ini menyediakan video-video pembelajaran serta video tips
                dan trik berkualitas tinggi yang dapat Anda tonton dimana saja dan
                kapan saja. Sehingga dapat menyesuaikan dengan jenis aktifitas
                Anda sehari-hari. Video Series ini telah disusun sedemikian rupa
                sehingga dapat sesuai dengan kebutuhan Anda dalam melakukan
                persiapan untuk seleksi CPNS, BUMN, Kedinasan, PPPK dan yang
                lainnya.
              </p>
              <p class="font-bold mt-8"><b>E-book</b></p>
              <p>
                Butuh materi pembelajaran yang dapat di print? Gunakan fitur
                E-book ini karena didalamnya telah disediakan rangkuman-rangkuman
                materi yang telah disesuaikan dengan kisi-kisi yang telah
                ditentukan sehingga Anda dapat belajar lebih efektif lagi.
              </p>
              <p class="font-bold mt-8"><b>Tryout Harian</b></p>
              <p>
                Kurang lengkap rasanya belajar tanpa latihan soal. Dengan fitur
                ini, Anda dapat mengerjakan soal-soal berkualitas tinggi setiap
                hari bersama peserta lainnya. Tersedia juga fitur pembahasan dan
                ada fitur ranking seluruh peserta juga loh.
              </p>
              <p class="font-bold mt-8"><b>Webinar</b></p>
              <p>
                Dapatkan akses khusus ke semua event webinar yang ada di IDCPNS
                tanpa melakukan persyaratan apapun.
              </p>
              <p class="mt-8">
                Fitur Platinum ini memberikan gratis update apabila ada konten
                baru, sehingga Anda tidak perlu melakukan pembayaran lagi apabila
                ada konten-konten baru di Platinum Zone.
              </p>
              <p class="mt-8">
                Tunggu apalagi? Kalahkan semua pesaing Anda dan taklukan
                seleksi-seleksi yang akan&nbsp;Anda&nbsp;hadapi.
              </p>
            </div>""",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _bonusCard({
    required String badgeText,
    required Color badgeColor,
    required String title,
    required String uuid,
  }) {
    return InkWell(
      onTap: () {
        controller.selectedBonusUuid.value = uuid;
      },
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: Colors.grey, width: 0.5),
        ),
        child: Container(
          padding: EdgeInsets.all(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    color: badgeColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    child: Container(
                      padding: EdgeInsets.all(4),
                      child: Text(
                        badgeText,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Text(title),
                ],
              ),
              Obx(
                () => Icon(
                  controller.selectedBonusUuid.value == uuid
                      ? Icons.circle
                      : Icons.circle_outlined,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
