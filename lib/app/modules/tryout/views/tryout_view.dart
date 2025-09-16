import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/modules/notification/views/notification_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../controllers/tryout_controller.dart';

class TryoutView extends GetView<TryoutController> {
  TryoutView({Key? key}) : super(key: key);

  final controller = Get.put(TryoutController());
  final eventTextController = TextEditingController();
  final paketTextController = TextEditingController();

  VoidCallback goToDetail(BuildContext context) {
    return () {
      controller.showDetailTryout(context);
    };
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    const String noDataSvg = '''
    <svg width="184" height="152" viewBox="0 0 184 152" xmlns="http://www.w3.org/2000/svg"><title>No data</title><g fill="none" fill-rule="evenodd"><g transform="translate(24 31.67)"><ellipse fill-opacity=".8" fill="#F5F5F7" cx="67.797" cy="106.89" rx="67.797" ry="12.668"></ellipse><path d="M122.034 69.674L98.109 40.229c-1.148-1.386-2.826-2.225-4.593-2.225h-51.44c-1.766 0-3.444.839-4.592 2.225L13.56 69.674v15.383h108.475V69.674z" fill="#AEB8C2"></path><path d="M101.537 86.214L80.63 61.102c-1.001-1.207-2.507-1.867-4.048-1.867H31.724c-1.54 0-3.047.66-4.048 1.867L6.769 86.214v13.792h94.768V86.214z" fill="url(#linearGradient-1)" transform="translate(13.56)"></path><path d="M33.83 0h67.933a4 4 0 0 1 4 4v93.344a4 4 0 0 1-4 4H33.83a4 4 0 0 1-4-4V4a4 4 0 0 1 4-4z" fill="#F5F5F7"></path><path d="M42.678 9.953h50.237a2 2 0 0 1 2 2V36.91a2 2 0 0 1-2 2H42.678a2 2 0 0 1-2-2V11.953a2 2 0 0 1 2-2zM42.94 49.767h49.713a2.262 2.262 0 1 1 0 4.524H42.94a2.262 2.262 0 0 1 0-4.524zM42.94 61.53h49.713a2.262 2.262 0 1 1 0 4.525H42.94a2.262 2.262 0 0 1 0-4.525zM121.813 105.032c-.775 3.071-3.497 5.36-6.735 5.36H20.515c-3.238 0-5.96-2.29-6.734-5.36a7.309 7.309 0 0 1-.222-1.79V69.675h26.318c2.907 0 5.25 2.448 5.25 5.42v.04c0 2.971 2.37 5.37 5.277 5.37h34.785c2.907 0 5.277-2.421 5.277-5.393V75.1c0-2.972 2.343-5.426 5.25-5.426h26.318v33.569c0 .617-.077 1.216-.221 1.789z" fill="#DCE0E6"></path></g><path d="M149.121 33.292l-6.83 2.65a1 1 0 0 1-1.317-1.23l1.937-6.207c-2.589-2.944-4.109-6.534-4.109-10.408C138.802 8.102 148.92 0 161.402 0 173.881 0 184 8.102 184 18.097c0 9.995-10.118 18.097-22.599 18.097-4.528 0-8.744-1.066-12.28-2.902z" fill="#DCE0E6"></path><g transform="translate(149.65 15.383)" fill="#FFF"><ellipse cx="20.654" cy="3.167" rx="2.849" ry="2.815"></ellipse><path d="M5.698 5.63H0L2.898.704zM9.259.704h4.985V5.63H9.259z"></path></g></g></svg>
    ''';
    return Scaffold(
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
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 1,
            scrolledUnderElevation: 0,
            title: Image.asset(
              'assets/logo.png', // Dummy logo
              height: 55,
            ),
            actions: [
              Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.notifications_none, color: Colors.teal),
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: RefreshIndicator(
          backgroundColor: Colors.white,
          onRefresh: () => controller.initTryout(),
          child: SingleChildScrollView(
            child: Column(
              // 🚀 Hapus Expanded
              children: [
                SizedBox(height: 16),
                // Tryout Saya box
                InkWell(
                  onTap: () {
                    Get.offNamed("/tryout-saya");
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade50,
                      border: Border.all(color: Colors.teal, width: 1.6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,

                              child: Center(
                                child: SvgPicture.asset(
                                  "assets/computerIcon.svg",
                                ),
                              ),
                            ),
                            SizedBox(width: 13),
                            Text(
                              'Tryout Saya',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.teal,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 32),

                // Event Tryout Gratis
                screenWidth > 800
                    ? Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Event Tryout Gratis",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                "Ikuti tryout akbar gratis bersama ribuan peserta lainnya.",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )
                    : Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Event Tryout Gratis",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "Ikuti tryout akbar gratis bersama ribuan peserta lainnya.",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          SizedBox(height: 8),
                          TextField(
                            controller: eventTextController,
                            onChanged:
                                (value) => controller.showEventTryout(
                                  name: value,
                                  category:
                                      controller.selectedEventKategori.value,
                                ),
                            decoration: InputDecoration(
                              labelStyle: TextStyle(color: Colors.grey),
                              labelText: "Cari",
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 1.5,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.teal,
                                  width: 2.0,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                SizedBox(height: 16),

                // filter button
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            useSafeArea: false,
                            context: context,
                            builder: (ctx) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return SafeArea(
                                    child: Container(
                                      color: Colors.white,
                                      padding: EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisSize:
                                            MainAxisSize
                                                .min, // biar bottomsheet menyesuaikan isi
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Jenis Tryout",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8),

                                          Obx(
                                            () => Wrap(
                                              spacing: 8,
                                              children:
                                                  controller.options.value.map((
                                                    option,
                                                  ) {
                                                    final isSelected =
                                                        controller
                                                            .selectedEventKategori
                                                            .value ==
                                                        option;
                                                    return ChoiceChip(
                                                      label: Text(
                                                        option,
                                                        style: TextStyle(
                                                          color:
                                                              isSelected
                                                                  ? Colors.teal
                                                                  : Colors
                                                                      .grey[700],
                                                          fontWeight:
                                                              isSelected
                                                                  ? FontWeight
                                                                      .bold
                                                                  : FontWeight
                                                                      .normal,
                                                        ),
                                                      ),
                                                      selected: isSelected,
                                                      selectedColor: Colors.teal
                                                          .withOpacity(0.1),
                                                      backgroundColor:
                                                          Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                        side: BorderSide(
                                                          color:
                                                              isSelected
                                                                  ? Colors.teal
                                                                  : Colors
                                                                      .grey
                                                                      .shade400,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              6,
                                                            ),
                                                      ),
                                                      onSelected: (value) {
                                                        controller
                                                            .selectedEventKategori
                                                            .value = option;
                                                      },
                                                    );
                                                  }).toList(),
                                            ),
                                          ),

                                          const SizedBox(height: 12),
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.teal, // warna tombol
                                                foregroundColor:
                                                    Colors
                                                        .white, // warna teks/icon
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 24,
                                                      vertical: 12,
                                                    ),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                controller.showEventTryout(
                                                  name:
                                                      eventTextController.text,
                                                  category:
                                                      controller
                                                          .selectedEventKategori
                                                          .value,
                                                );
                                              },
                                              child: const Text("Cari"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                        child: Row(
                          children: [
                            Text(
                              "Filter",
                              style: TextStyle(color: Colors.teal),
                            ),
                            Icon(Icons.keyboard_arrow_down, color: Colors.teal),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Obx(() {
                  if (controller.loading['event'] == true) {
                    return Skeletonizer(
                      child: _eventTryoutGratis(
                        "",
                        "Lorem Ipsum Odor",
                        "Lorem Ipsum Odor",
                        "Lorem Ipsum Odor",
                        "Lorem Ipsum Odor",
                      ),
                    );
                  }

                  if (controller.eventTryout.isEmpty) {
                    return Column(
                      children: [
                        SvgPicture.string(noDataSvg),
                        const SizedBox(height: 16),
                        const Text(
                          "Belum Ada Event Berlangsung",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    );
                  }

                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      height: 180,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.eventTryout.length,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ), // jarak kiri-kanan
                        itemBuilder: (ctx, index) {
                          final event = controller.eventTryout[index];

                          return SizedBox(
                            width:
                                MediaQuery.of(ctx).size.width *
                                0.85, // fill 85% lebar layar
                            child: _eventTryoutGratis(
                              event["uuid"].toString(),
                              event["label_text"].toString(),
                              event['name'].toString(),
                              controller.formatTanggalRange(
                                "${event["startdate"].toString().substring(0, 10)} - ${event["enddate"].toString().substring(0, 10)}",
                              ),
                              event["periode_text"].toString(),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }),

                SizedBox(height: 16),

                Obx(() {
                  if (controller.paketTryoutRecommendation.isEmpty) {
                    return const SizedBox();
                  }

                  return Container(
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    decoration: BoxDecoration(
                      border: Border.all(width: 0, color: Colors.transparent),
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color.fromARGB(
                            130,
                            0,
                            150,
                            135,
                          ), // warna cerah di atas
                          Colors.teal, // warna gelap di bawah
                        ],
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Judul di atas
                        Center(
                          child: Row(
                            spacing: 16,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(width: 1),
                              const Text(
                                "Rekomendasi Khusus Buat Kamu",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Icon(Icons.stars_sharp, color: Colors.amber),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),

                        // List horizontal
                        SizedBox(
                          height: 154, // ✅ penting untuk horizontal list
                          child: PageView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount:
                                controller.paketTryoutRecommendation.length,
                            itemBuilder: (context, index) {
                              final data =
                                  controller.paketTryoutRecommendation[index];
                              final option =
                                  controller.options[data['menu_category_id']];

                              return _cardPaketTryoutRekomendasi(
                                data['uuid']?.toString() ?? '',
                                data['gambar']?.toString() ?? '',
                                data['formasi']?.toString() ?? '',
                                controller.formatCurrency(
                                  data['harga']?.toString() ?? '0',
                                ),
                                controller.formatCurrency(
                                  data['harga_fix']?.toString() ?? '0',
                                ),
                                option,
                                context,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                SizedBox(height: 8),

                // Paket Tryout section
                screenWidth > 800
                    ? Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Paket Tryout",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    )
                    : Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 16,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Paket Tryout",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Pilih paket tryout sesuai kebutuhanmu.",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          SizedBox(height: 12),

                          // Search bar
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: paketTextController,
                                  decoration: InputDecoration(
                                    labelStyle: TextStyle(color: Colors.grey),
                                    labelText: "Cari",
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 10,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.teal,
                                        width: 1.5,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.teal,
                                        width: 2.0,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 8),

                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal, // warna tombol
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
                                onPressed: () {
                                  controller.fetchPaketTryout(
                                    page: 1,

                                    search: paketTextController.text,
                                    menuCategory:
                                        controller
                                            .optionsId[controller
                                                .selectedPaketKategori
                                                .value]
                                            .toString(),
                                  );
                                },
                                label: Text("Cari"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                // filter button
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            useSafeArea: false,
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(16),
                              ),
                            ),
                            builder: (ctx) {
                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return SafeArea(
                                    child: Container(
                                      color: Colors.white,
                                      padding: EdgeInsets.all(16),
                                      child: Column(
                                        mainAxisSize:
                                            MainAxisSize
                                                .min, // biar bottomsheet menyesuaikan isi
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text(
                                            "Jenis Tryout",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 8),

                                          Obx(
                                            () => Wrap(
                                              spacing: 8,
                                              children:
                                                  controller.options.value.map((
                                                    option,
                                                  ) {
                                                    final isSelected =
                                                        controller
                                                            .selectedPaketKategori
                                                            .value ==
                                                        option;
                                                    return ChoiceChip(
                                                      label: Text(
                                                        option,
                                                        style: TextStyle(
                                                          color:
                                                              isSelected
                                                                  ? Colors.teal
                                                                  : Colors
                                                                      .grey[700],
                                                          fontWeight:
                                                              isSelected
                                                                  ? FontWeight
                                                                      .bold
                                                                  : FontWeight
                                                                      .normal,
                                                        ),
                                                      ),
                                                      selected: isSelected,
                                                      selectedColor: Colors.teal
                                                          .withOpacity(0.1),
                                                      backgroundColor:
                                                          Colors.white,
                                                      shape: RoundedRectangleBorder(
                                                        side: BorderSide(
                                                          color:
                                                              isSelected
                                                                  ? Colors.teal
                                                                  : Colors
                                                                      .grey
                                                                      .shade400,
                                                        ),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              6,
                                                            ),
                                                      ),
                                                      onSelected: (value) {
                                                        controller
                                                            .selectedPaketKategori
                                                            .value = option;
                                                      },
                                                    );
                                                  }).toList(),
                                            ),
                                          ),

                                          const SizedBox(height: 12),
                                          SizedBox(
                                            width: double.infinity,
                                            child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor:
                                                    Colors.teal, // warna tombol
                                                foregroundColor:
                                                    Colors
                                                        .white, // warna teks/icon
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 24,
                                                      vertical: 12,
                                                    ),
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                controller.fetchPaketTryout(
                                                  page: 1,
                                                  search:
                                                      paketTextController.text,
                                                  menuCategory:
                                                      controller
                                                          .optionsId[controller
                                                              .selectedPaketKategori
                                                              .value]
                                                          .toString(),
                                                );
                                              },
                                              child: const Text("Cari"),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          );
                        },
                        child: Row(
                          children: [
                            Text(
                              "Filter",
                              style: TextStyle(color: Colors.teal),
                            ),
                            Icon(Icons.keyboard_arrow_down, color: Colors.teal),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 16),

                Obx(() {
                  if (controller.loading['paket'] == true) {
                    return Skeletonizer(
                      child: Center(
                        child: _cardPaketTryout(
                          "Lorem Ipsum Odor",
                          "assets/logo.png",
                          "Lorem Ipsum Odor",
                          "Lorem Ipsum Odor",
                          "Lorem Ipsum Odor",
                          "Lorem Ipsum Odor",
                          context,
                        ),
                      ),
                    );
                  }
                  if (controller.paketTryout.isEmpty) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 200,
                          child: SvgPicture.string(noDataSvg),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          "Belum Ada Tryout Tersedia",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.paketTryout.length,
                    itemBuilder: (context, index) {
                      final data = controller.paketTryout[index];
                      final option =
                          controller.options[data['menu_category_id']];
                      return _cardPaketTryout(
                        data['uuid'].toString() ?? '',
                        data['gambar'].toString() ?? '',
                        data['formasi'].toString() ?? '',
                        controller.formatCurrency(data['harga'].toString()) ??
                            '',
                        controller.formatCurrency(
                              data['harga_fix'].toString(),
                            ) ??
                            '',
                        option,
                        context,
                      );
                    },
                  );
                }),

                Obx(() {
                  final current = controller.currentPage.value;
                  final total = controller.totalPage.value;

                  if (total == 0) {
                    return const SizedBox.shrink(); // tidak ada halaman
                  }

                  // Tentukan window
                  int start = current - 1;
                  int end = current + 1;

                  // clamp biar tetap di antara 1 dan total
                  start = start < 1 ? 1 : start;
                  end = end > total ? total : end;

                  // Kalau total < 3, pakai semua halaman yg ada
                  if (total <= 3) {
                    start = 1;
                    end = total;
                  } else {
                    // Kalau current di awal → 1,2,3
                    if (current == 1) {
                      start = 1;
                      end = 3;
                    }
                    // Kalau current di akhir → total-2, total-1, total
                    else if (current == total) {
                      start = total - 2;
                      end = total;
                    }
                  }

                  // Generate daftar halaman
                  final pages = List.generate(
                    end - start + 1,
                    (i) => start + i,
                  );

                  return Container(
                    height: 40,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextButton.icon(
                            onPressed:
                                current > 1
                                    ? () => controller.fetchPaketTryout(
                                      page: 1,
                                      search: paketTextController.text,
                                      menuCategory:
                                          controller
                                              .optionsId[controller
                                                  .selectedPaketKategori
                                                  .value]
                                              .toString(),
                                    )
                                    : null,
                            label: const Icon(Icons.first_page, size: 16),
                          ),
                          TextButton.icon(
                            onPressed:
                                current > 1
                                    ? () => controller.fetchPaketTryout(
                                      page: current - 1,
                                      search: paketTextController.text,
                                      menuCategory:
                                          controller
                                              .optionsId[controller
                                                  .selectedPaketKategori
                                                  .value]
                                              .toString(),
                                    )
                                    : null,
                            label: const Icon(Icons.arrow_back_ios, size: 16),
                          ),

                          ...pages.map((page) {
                            final isActive = page == current;
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 2),
                              child: GestureDetector(
                                onTap:
                                    () => controller.fetchPaketTryout(
                                      page: page,
                                      search: paketTextController.text,
                                      menuCategory:
                                          controller
                                              .optionsId[controller
                                                  .selectedPaketKategori
                                                  .value]
                                              .toString(),
                                    ),
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 200),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isActive ? 14 : 10,
                                    vertical: isActive ? 8 : 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        isActive
                                            ? Colors.teal.shade100
                                            : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color:
                                          isActive
                                              ? Colors.teal
                                              : Colors.grey.shade300,
                                      width: isActive ? 2 : 1,
                                    ),
                                  ),
                                  child: Text(
                                    '$page',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          isActive ? Colors.teal : Colors.black,
                                      fontSize:
                                          isActive
                                              ? 16
                                              : 14, // font lebih besar untuk page aktif
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),

                          TextButton.icon(
                            onPressed:
                                current < total
                                    ? () => controller.fetchPaketTryout(
                                      page: current + 1,
                                      search: paketTextController.text,
                                      menuCategory:
                                          controller
                                              .optionsId[controller
                                                  .selectedPaketKategori
                                                  .value]
                                              .toString(),
                                    )
                                    : null,
                            label: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            ),
                          ),
                          TextButton.icon(
                            onPressed:
                                current < total
                                    ? () => controller.fetchPaketTryout(
                                      page: controller.totalPage.value,
                                      search: paketTextController.text,
                                      menuCategory:
                                          controller
                                              .optionsId[controller
                                                  .selectedPaketKategori
                                                  .value]
                                              .toString(),
                                    )
                                    : null,
                            label: const Icon(Icons.last_page, size: 16),
                          ),
                        ],
                      ),
                    ),
                  );
                }),

                SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _cardPaketTryout(
    String uuid,
    String image,
    String title,
    String hargaFull,
    String hargaDiskon,
    String kategori,
    BuildContext context,
  ) {
    return InkWell(
      onTap: () {
        Get.toNamed("/detail-tryout", arguments: uuid);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.transparent, width: 0),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.2),
              offset: const Offset(0, 0), // negatif = shadow muncul di atas
              blurRadius: 6,
              spreadRadius: 2,
            ),
          ],
        ),
        child: SizedBox(
          height: 128,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian kiri: gambar
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
                child: Image.network(
                  image, // ganti dengan gambar kamu
                  width: 140,
                  height: 128,
                  fit: BoxFit.fill,
                  errorBuilder: (
                    BuildContext context,
                    Object exception,
                    StackTrace? stackTrace,
                  ) {
                    return Image.asset("assets/logo.png");
                  },
                ),
              ),
              const SizedBox(width: 12),

              // Bagian kanan: teks
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hargaFull,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              const SizedBox(width: 2),
                              Text(
                                hargaDiskon,
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Label CPNS
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: controller.categoryColor[kategori],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                kategori,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardPaketTryoutRekomendasi(
    String uuid,
    String image,
    String title,
    String hargaFull,
    String hargaDiskon,
    String kategori,
    BuildContext context,
  ) {
    return InkWell(
      onTap: () {
        Get.toNamed("/detail-tryout", arguments: uuid);
      },
      child: Card(
        color: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
        child: SizedBox(
          width: 250,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian kiri: gambar
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
                child: Image.network(
                  image,
                  width: 128,
                  height: 128,
                  fit: BoxFit.fill,
                  errorBuilder: (
                    BuildContext context,
                    Object exception,
                    StackTrace? stackTrace,
                  ) {
                    return Image.asset("assets/logo.png");
                  },
                ),
              ),
              const SizedBox(width: 12),

              // Bagian kanan: teks
              Flexible(
                // ✅ ganti Expanded dengan Flexible
                fit: FlexFit.loose,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            overflow: TextOverflow.ellipsis, // ✅ biar rapi
                            maxLines: 2,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                hargaFull,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 10,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              Text(
                                hargaDiskon,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Label CPNS
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: controller.categoryColor[kategori],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            kategori,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _eventTryoutGratis(
    String uuid,
    String status,
    String judul,
    String tanggal,
    String periode,
  ) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Get.toNamed("/maintenance", arguments: uuid);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: Card(
          elevation: 3,
          shadowColor: Colors.teal.withOpacity(0.2),
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.teal.shade100, width: 1),
          ),
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              spacing: 8,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Badge status
                Container(
                  decoration: BoxDecoration(
                    color: Colors.teal.shade400,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                // Judul Tryout
                Text(
                  judul,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: Colors.black87,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 2,
                ),

                // Tanggal
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 14,
                      color: Colors.black45,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      tanggal,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),

                // Periode
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.black45,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        "Periode: $periode",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
