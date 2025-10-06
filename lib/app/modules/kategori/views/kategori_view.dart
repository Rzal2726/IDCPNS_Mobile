import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/searchWithButton.dart';
import 'package:idcpns_mobile/app/modules/notification/views/notification_view.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:idcpns_mobile/app/Components/widgets/wdigetTryoutEventCard.dart';
import '../controllers/kategori_controller.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';
import 'package:idcpns_mobile/styles/app_style.dart';

class KategoriView extends GetView<KategoriController> {
  const KategoriView({super.key});
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    const String noDataSvg = '''
    <svg width="184" height="152" viewBox="0 0 184 152" xmlns="http://www.w3.org/2000/svg"><title>No data</title><g fill="none" fill-rule="evenodd"><g transform="translate(24 31.67)"><ellipse fill-opacity=".8" fill="#F5F5F7" cx="67.797" cy="106.89" rx="67.797" ry="12.668"></ellipse><path d="M122.034 69.674L98.109 40.229c-1.148-1.386-2.826-2.225-4.593-2.225h-51.44c-1.766 0-3.444.839-4.592 2.225L13.56 69.674v15.383h108.475V69.674z" fill="#AEB8C2"></path><path d="M101.537 86.214L80.63 61.102c-1.001-1.207-2.507-1.867-4.048-1.867H31.724c-1.54 0-3.047.66-4.048 1.867L6.769 86.214v13.792h94.768V86.214z" fill="url(#linearGradient-1)" transform="translate(13.56)"></path><path d="M33.83 0h67.933a4 4 0 0 1 4 4v93.344a4 4 0 0 1-4 4H33.83a4 4 0 0 1-4-4V4a4 4 0 0 1 4-4z" fill="#F5F5F7"></path><path d="M42.678 9.953h50.237a2 2 0 0 1 2 2V36.91a2 2 0 0 1-2 2H42.678a2 2 0 0 1-2-2V11.953a2 2 0 0 1 2-2zM42.94 49.767h49.713a2.262 2.262 0 1 1 0 4.524H42.94a2.262 2.262 0 0 1 0-4.524zM42.94 61.53h49.713a2.262 2.262 0 1 1 0 4.525H42.94a2.262 2.262 0 0 1 0-4.525zM121.813 105.032c-.775 3.071-3.497 5.36-6.735 5.36H20.515c-3.238 0-5.96-2.29-6.734-5.36a7.309 7.309 0 0 1-.222-1.79V69.675h26.318c2.907 0 5.25 2.448 5.25 5.42v.04c0 2.971 2.37 5.37 5.277 5.37h34.785c2.907 0 5.277-2.421 5.277-5.393V75.1c0-2.972 2.343-5.426 5.25-5.426h26.318v33.569c0 .617-.077 1.216-.221 1.789z" fill="#DCE0E6"></path></g><path d="M149.121 33.292l-6.83 2.65a1 1 0 0 1-1.317-1.23l1.937-6.207c-2.589-2.944-4.109-6.534-4.109-10.408C138.802 8.102 148.92 0 161.402 0 173.881 0 184 8.102 184 18.097c0 9.995-10.118 18.097-22.599 18.097-4.528 0-8.744-1.066-12.28-2.902z" fill="#DCE0E6"></path><g transform="translate(149.65 15.383)" fill="#FFF"><ellipse cx="20.654" cy="3.167" rx="2.849" ry="2.815"></ellipse><path d="M5.698 5.63H0L2.898.704zM9.259.704h4.985V5.63H9.259z"></path></g></g></svg>
    ''';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: secondaryAppBar("Zona ${controller.categoryData['menu']}"),
      body: SafeArea(
        child: RefreshIndicator(
          backgroundColor: Colors.white,
          onRefresh: () => controller.initKategori(),
          child: SingleChildScrollView(
            padding: AppStyle.sreenPaddingHome,
            child: Column(
              // 🚀 Hapus Expanded
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () =>
                      controller.categoryList.isEmpty
                          ? Skeletonizer(
                            child: Image.asset(
                              "assets/zona_cpns.png",
                              fit: BoxFit.cover,
                            ),
                          )
                          : controller.categoryImage[controller
                              .categoryData['menu']]!,
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
                    : Column(
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
                          controller: controller.eventTextController,
                          onChanged:
                              (value) =>
                                  controller.showEventTryout(name: value),
                          decoration: InputDecoration(
                            labelStyle: TextStyle(color: Colors.grey),
                            labelText: "Cari",
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
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
                            suffixIcon: Icon(Icons.search, color: Colors.black),
                          ),
                        ),
                      ],
                    ),

                SizedBox(height: 16),

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
                    return Center(
                      child: Column(
                        children: [
                          SvgPicture.string(noDataSvg),
                          const SizedBox(height: 16),
                          const Text(
                            "Belum Ada Event Berlangsung",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        for (var data in controller.eventTryout)
                          Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: SizedBox(
                              width: 300, // biar card rapi & konsisten
                              child: GestureDetector(
                                onTap: () {
                                  Get.toNamed(
                                    "/detail-event",
                                    arguments: data['uuid'],
                                  );
                                },
                                child: buildTryoutCard(
                                  status: data['label_text'],
                                  title: data['name'],
                                  dateRange: data['range_date_string'],
                                  period: data['periode_text'],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }),

                SizedBox(height: 36),

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
                    : Column(
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

                        SearchRowButton(
                          controller: controller.paketTextController,
                          onSearch: () {
                            controller.fetchPaketTryout(
                              page: 1,

                              search: controller.paketTextController.text,
                              menuCategory: controller.categoryId.toString(),
                            );
                          },
                          hintText: 'Apa yang ingin Anda cari?',
                        ),
                      ],
                    ),

                SizedBox(height: 16),

                Obx(() {
                  if (controller.loading['paket'] == true) {
                    return Skeletonizer(
                      child: Column(
                        children: [
                          Center(
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
                          Center(
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
                          Center(
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
                          Center(
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
                          Center(
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
                        ],
                      ),
                    );
                  }
                  if (controller.paketTryout.isEmpty) {
                    return Center(
                      child: Column(
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
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.paketTryout.length,
                    itemBuilder: (context, index) {
                      final data = controller.paketTryout[index];
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
                        controller.categoryData['menu'],
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

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final screenWidth = MediaQuery.of(context).size.width;
                      final isSmallScreen = screenWidth < 600;
                      final fontSize = isSmallScreen ? 12.0 : 14.0;
                      final padding = isSmallScreen ? 6.0 : 9.0;

                      return Container(
                        height: 50,
                        width: double.infinity,
                        child: Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextButton.icon(
                                  onPressed:
                                      current > 1
                                          ? () => controller.fetchPaketTryout(
                                            page: 1,
                                            search:
                                                controller
                                                    .paketTextController
                                                    .text,
                                          )
                                          : null,
                                  label: Icon(
                                    Icons.first_page,
                                    size: isSmallScreen ? 14 : 16,
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed:
                                      current > 1
                                          ? () => controller.fetchPaketTryout(
                                            page: current - 1,
                                            search:
                                                controller
                                                    .paketTextController
                                                    .text,
                                          )
                                          : null,
                                  label: Icon(
                                    Icons.arrow_back_ios,
                                    size: isSmallScreen ? 14 : 16,
                                  ),
                                ),

                                Wrap(
                                  spacing: 4,
                                  runSpacing: 4,
                                  children:
                                      pages.map((page) {
                                        final isActive = page == current;
                                        return GestureDetector(
                                          onTap:
                                              () => controller.fetchPaketTryout(
                                                page: page,
                                                search:
                                                    controller
                                                        .paketTextController
                                                        .text,
                                              ),
                                          child: AnimatedContainer(
                                            duration: Duration(
                                              milliseconds: 200,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: padding,
                                              vertical: 8,
                                            ),

                                            decoration: BoxDecoration(
                                              color:
                                                  isActive
                                                      ? Colors.teal.shade100
                                                      : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
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
                                                    isActive
                                                        ? Colors.teal
                                                        : Colors.black,
                                                fontSize: fontSize,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                ),

                                TextButton.icon(
                                  onPressed:
                                      current < total
                                          ? () => controller.fetchPaketTryout(
                                            page: current + 1,
                                            search:
                                                controller
                                                    .paketTextController
                                                    .text,
                                          )
                                          : null,
                                  label: Icon(
                                    Icons.arrow_forward_ios,
                                    size: isSmallScreen ? 14 : 16,
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed:
                                      current < total
                                          ? () => controller.fetchPaketTryout(
                                            page: controller.totalPage.value,
                                            search:
                                                controller
                                                    .paketTextController
                                                    .text,
                                          )
                                          : null,
                                  label: Icon(
                                    Icons.last_page,
                                    size: isSmallScreen ? 14 : 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),

                SizedBox(height: 32),

                // Bimbel section
                screenWidth > 800
                    ? Row(
                      children: [
                        Expanded(
                          child: Text(
                            "Paket Bimbel",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    )
                    : Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Paket Bimbel",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Belajar lebih intensif bersama mentor ahli di bidangnya.",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          SizedBox(height: 12),

                          // Search bar
                          SearchRowButton(
                            controller: controller.bimbelTextController,
                            onSearch: () {
                              controller.fetchBimbel(
                                page: 1,

                                search: controller.bimbelTextController.text,
                                menuCategory: controller.categoryId.toString(),
                              );
                            },
                            hintText: 'Apa yang ingin Anda cari?',
                          ),
                        ],
                      ),
                    ),

                SizedBox(height: 16),

                //Bimbel
                Obx(() {
                  if (controller.loading['bimbel'] == true) {
                    return Skeletonizer(
                      child: Column(
                        children: [
                          Center(
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
                          Center(
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
                          Center(
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
                          Center(
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
                          Center(
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
                        ],
                      ),
                    );
                  }
                  if (controller.bimbelList.isEmpty) {
                    return Center(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 200,
                            child: SvgPicture.string(noDataSvg),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            "Belum Ada Bimbel Tersedia",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.bimbelList.length,
                    itemBuilder: (context, index) {
                      final data = controller.bimbelList[index];
                      final option = controller.categoryId;
                      return _cardPaketBimbel(
                        image: data['gambar'] ?? '',
                        title: data['name'] ?? '',
                        hargaTertinggi:
                            data['price_list']?['harga_tertinggi'] ?? 0,
                        hargaFixTertinggi:
                            data['price_list']?['harga_fix_tertinggi'] ?? 0,
                        hargaTerendah: data['price_list']?['harga_terendah'],
                        hargaFixTerendah:
                            data['price_list']?['harga_fix_terendah'] ?? 0,
                        kategori: controller.categoryData['menu'],
                        color: controller.currentCategoryColor,
                        onTap: () {
                          Get.toNamed(
                            "/detail-bimbel",
                            arguments: data['uuid'],
                          ); // sesuaikan rute
                        },
                      );
                    },
                  );
                }),

                Obx(() {
                  final current = controller.currentBimbelPage.value;
                  final total = controller.totalBimbelPage.value;

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

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final screenWidth = MediaQuery.of(context).size.width;
                      final isSmallScreen = screenWidth < 600;
                      final fontSize = isSmallScreen ? 12.0 : 14.0;
                      final padding = isSmallScreen ? 6.0 : 9.0;

                      return Container(
                        height: 50,
                        width: double.infinity,
                        child: Center(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextButton.icon(
                                  onPressed:
                                      current > 1
                                          ? () => controller.fetchBimbel(
                                            page: 1,
                                            search:
                                                controller
                                                    .bimbelTextController
                                                    .text,
                                          )
                                          : null,
                                  label: Icon(
                                    Icons.first_page,
                                    size: isSmallScreen ? 14 : 16,
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed:
                                      current > 1
                                          ? () => controller.fetchBimbel(
                                            page: current - 1,
                                            search:
                                                controller
                                                    .bimbelTextController
                                                    .text,
                                          )
                                          : null,
                                  label: Icon(
                                    Icons.arrow_back_ios,
                                    size: isSmallScreen ? 14 : 16,
                                  ),
                                ),

                                Wrap(
                                  spacing: 4,
                                  runSpacing: 4,
                                  children:
                                      pages.map((page) {
                                        final isActive = page == current;
                                        return GestureDetector(
                                          onTap:
                                              () => controller.fetchBimbel(
                                                page: page,
                                                search:
                                                    controller
                                                        .bimbelTextController
                                                        .text,
                                                menuCategory:
                                                    controller.categoryId
                                                        .toString(),
                                              ),
                                          child: AnimatedContainer(
                                            duration: Duration(
                                              milliseconds: 200,
                                            ),
                                            padding: EdgeInsets.symmetric(
                                              horizontal: padding,
                                              vertical: 8,
                                            ),

                                            decoration: BoxDecoration(
                                              color:
                                                  isActive
                                                      ? Colors.teal.shade100
                                                      : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
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
                                                    isActive
                                                        ? Colors.teal
                                                        : Colors.black,
                                                fontSize: fontSize,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                ),

                                TextButton.icon(
                                  onPressed:
                                      current < total
                                          ? () => controller.fetchBimbel(
                                            page: current + 1,
                                            search:
                                                controller
                                                    .bimbelTextController
                                                    .text,
                                          )
                                          : null,
                                  label: Icon(
                                    Icons.arrow_forward_ios,
                                    size: isSmallScreen ? 14 : 16,
                                  ),
                                ),
                                TextButton.icon(
                                  onPressed:
                                      current < total
                                          ? () => controller.fetchBimbel(
                                            page:
                                                controller
                                                    .totalBimbelPage
                                                    .value,
                                            search:
                                                controller
                                                    .bimbelTextController
                                                    .text,
                                          )
                                          : null,
                                  label: Icon(
                                    Icons.last_page,
                                    size: isSmallScreen ? 14 : 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
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
        height: 140,
        margin: EdgeInsets.symmetric(vertical: 16),
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
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 10),
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
                    SizedBox(height: 3),
                    Align(
                      alignment: Alignment.centerRight, // Bikin rata kanan
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(8),
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
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardPaketBimbel({
    required String image,
    required String title,
    required int hargaTertinggi,
    required int hargaFixTertinggi,
    required int hargaTerendah,
    required int hargaFixTerendah,
    required String kategori,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 140, // FIXED HEIGHT
        margin: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 120,
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                ),
                child: Image.network(image, fit: BoxFit.cover),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      softWrap: true,
                    ),

                    SizedBox(height: 10),
                    Text(
                      "${controller.formatCurrency(hargaTerendah.toString())} - ${controller.formatCurrency(hargaTertinggi.toString())}",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),

                    Text(
                      "${controller.formatCurrency(hargaFixTerendah.toString())} - ${controller.formatCurrency(hargaFixTertinggi.toString())}",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 3),
                    Align(
                      alignment: Alignment.centerRight, // Bikin rata kanan
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.teal,
                          borderRadius: BorderRadius.circular(8),
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
                    ),
                  ],
                ),
              ),
            ),
          ],
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
        Get.toNamed("/detail-event", arguments: uuid);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16),
        child: Card(
          elevation: 0,
          color: Color.fromARGB(255, 231, 246, 243),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Color.fromARGB(255, 183, 228, 219),
              width: 1,
            ),
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
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(16),
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
                        "Periode: ",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        "$periode",
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.teal,
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
