import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../controllers/tryout_controller.dart';

class TryoutView extends GetView<TryoutController> {
  TryoutView({Key? key}) : super(key: key);

  final controller = Get.put(TryoutController());

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    const String noDataSvg = '''
    <svg width="184" height="152" viewBox="0 0 184 152" xmlns="http://www.w3.org/2000/svg"><title>No data</title><g fill="none" fill-rule="evenodd"><g transform="translate(24 31.67)"><ellipse fill-opacity=".8" fill="#F5F5F7" cx="67.797" cy="106.89" rx="67.797" ry="12.668"></ellipse><path d="M122.034 69.674L98.109 40.229c-1.148-1.386-2.826-2.225-4.593-2.225h-51.44c-1.766 0-3.444.839-4.592 2.225L13.56 69.674v15.383h108.475V69.674z" fill="#AEB8C2"></path><path d="M101.537 86.214L80.63 61.102c-1.001-1.207-2.507-1.867-4.048-1.867H31.724c-1.54 0-3.047.66-4.048 1.867L6.769 86.214v13.792h94.768V86.214z" fill="url(#linearGradient-1)" transform="translate(13.56)"></path><path d="M33.83 0h67.933a4 4 0 0 1 4 4v93.344a4 4 0 0 1-4 4H33.83a4 4 0 0 1-4-4V4a4 4 0 0 1 4-4z" fill="#F5F5F7"></path><path d="M42.678 9.953h50.237a2 2 0 0 1 2 2V36.91a2 2 0 0 1-2 2H42.678a2 2 0 0 1-2-2V11.953a2 2 0 0 1 2-2zM42.94 49.767h49.713a2.262 2.262 0 1 1 0 4.524H42.94a2.262 2.262 0 0 1 0-4.524zM42.94 61.53h49.713a2.262 2.262 0 1 1 0 4.525H42.94a2.262 2.262 0 0 1 0-4.525zM121.813 105.032c-.775 3.071-3.497 5.36-6.735 5.36H20.515c-3.238 0-5.96-2.29-6.734-5.36a7.309 7.309 0 0 1-.222-1.79V69.675h26.318c2.907 0 5.25 2.448 5.25 5.42v.04c0 2.971 2.37 5.37 5.277 5.37h34.785c2.907 0 5.277-2.421 5.277-5.393V75.1c0-2.972 2.343-5.426 5.25-5.426h26.318v33.569c0 .617-.077 1.216-.221 1.789z" fill="#DCE0E6"></path></g><path d="M149.121 33.292l-6.83 2.65a1 1 0 0 1-1.317-1.23l1.937-6.207c-2.589-2.944-4.109-6.534-4.109-10.408C138.802 8.102 148.92 0 161.402 0 173.881 0 184 8.102 184 18.097c0 9.995-10.118 18.097-22.599 18.097-4.528 0-8.744-1.066-12.28-2.902z" fill="#DCE0E6"></path><g transform="translate(149.65 15.383)" fill="#FFF"><ellipse cx="20.654" cy="3.167" rx="2.849" ry="2.815"></ellipse><path d="M5.698 5.63H0L2.898.704zM9.259.704h4.985V5.63H9.259z"></path></g></g></svg>
    ''';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        title: Image.network(
          "https://idcpns.com/app/assets/logo-f74defa6.png",
          width: 64,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.notifications_outlined,
              color: Colors.greenAccent.shade100,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          // 🚀 Hapus Expanded
          children: [
            // Tryout Saya box
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.greenAccent.shade100,
                  width: 1.5,
                ),
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Color.fromRGBO(238, 255, 250, 1),
              ),
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              margin: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SvgPicture.network(
                        "https://idcpns.com/app/assets/elearning-118a04aa.svg",
                        width: 32,
                        height: 32,
                      ),
                      SizedBox(width: 16),
                      Text(
                        "Tryout Saya",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.greenAccent.shade100,
                  ),
                ],
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
                  padding: EdgeInsets.symmetric(horizontal: 32),
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
                        decoration: InputDecoration(
                          labelStyle: TextStyle(color: Colors.grey),
                          labelText: "Cari",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.greenAccent.shade100,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.greenAccent.shade100,
                              width: 2.0,
                            ),
                            borderRadius: BorderRadius.circular(12),
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
                        context: context,
                        builder: (ctx) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return Container(
                                color: Colors.white,
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize:
                                      MainAxisSize
                                          .min, // biar bottomsheet menyesuaikan isi
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                            ? Colors.green
                                                            : Colors.grey[700],
                                                    fontWeight:
                                                        isSelected
                                                            ? FontWeight.bold
                                                            : FontWeight.normal,
                                                  ),
                                                ),
                                                selected: isSelected,
                                                selectedColor: Colors.green
                                                    .withOpacity(0.1),
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    color:
                                                        isSelected
                                                            ? Colors.green
                                                            : Colors
                                                                .grey
                                                                .shade400,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
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
                                    Center(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.green, // warna tombol
                                          foregroundColor:
                                              Colors.white, // warna teks/icon
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 12,
                                          ),
                                        ),
                                        onPressed: () {
                                          // Navigator.pop(
                                          //   context,
                                          //   selectedOption,
                                          // );
                                          // kirim balik pilihan
                                        },
                                        child: const Text("Cari"),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                    child: Row(
                      children: [
                        Text("Filter", style: TextStyle(color: Colors.green)),
                        Icon(Icons.keyboard_arrow_down, color: Colors.green),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),
            Obx(() {
              return controller.eventTryout.isNotEmpty
                  ? SizedBox(
                    height: 220,
                    child: PageView.builder(
                      controller: PageController(viewportFraction: 0.85),
                      itemCount: controller.eventTryout.length,
                      itemBuilder: (ctx, index) {
                        final event = controller.eventTryout[index];
                        return _eventTryoutGratis(
                          "Sedang Berlangsung",
                          event["judul"],
                          "${event["startDate"]} - ${event["endDate"]}",
                          event["periode"],
                        );
                      },
                    ),
                  )
                  : Column(
                    children: [
                      SvgPicture.string(noDataSvg),
                      const SizedBox(height: 16),
                      const Text(
                        "Belum Ada Event Berlangsung",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  );
            }),

            SizedBox(height: 32),

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
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
                              decoration: InputDecoration(
                                labelStyle: TextStyle(color: Colors.grey),
                                labelText: "Cari",
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 10,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.greenAccent.shade100,
                                    width: 1.5,
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.greenAccent.shade100,
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
                              backgroundColor: Colors.green, // warna tombol
                              foregroundColor: Colors.white, // warna teks/icon
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 12,
                              ),
                            ),
                            onPressed: () {},
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
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                        builder: (ctx) {
                          return StatefulBuilder(
                            builder: (context, setState) {
                              return Container(
                                color: Colors.white,
                                padding: EdgeInsets.all(16),
                                child: Column(
                                  mainAxisSize:
                                      MainAxisSize
                                          .min, // biar bottomsheet menyesuaikan isi
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                                            ? Colors.green
                                                            : Colors.grey[700],
                                                    fontWeight:
                                                        isSelected
                                                            ? FontWeight.bold
                                                            : FontWeight.normal,
                                                  ),
                                                ),
                                                selected: isSelected,
                                                selectedColor: Colors.green
                                                    .withOpacity(0.1),
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  side: BorderSide(
                                                    color:
                                                        isSelected
                                                            ? Colors.green
                                                            : Colors
                                                                .grey
                                                                .shade400,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(6),
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
                                    Center(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.green, // warna tombol
                                          foregroundColor:
                                              Colors.white, // warna teks/icon
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 24,
                                            vertical: 12,
                                          ),
                                        ),
                                        onPressed: () {
                                          // Navigator.pop(
                                          //   context,
                                          //   selectedOption,
                                          // );
                                          // kirim balik pilihan
                                        },
                                        child: const Text("Cari"),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                    child: Row(
                      children: [
                        Text("Filter", style: TextStyle(color: Colors.green)),
                        Icon(Icons.keyboard_arrow_down, color: Colors.green),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16),
            Obx(() {
              return controller.paketTryout.isNotEmpty
                  ? ListView.builder(
                    shrinkWrap: true, // ⬅ biar ukurannya ikut isi
                    physics:
                        NeverScrollableScrollPhysics(), // ⬅ biar ga bentrok scroll
                    itemCount: controller.paketTryout.length,
                    itemBuilder: (context, index) {
                      final data = controller.paketTryout[index];
                      return _cardPaketTryout(
                        data['image'],
                        data['title'],
                        data['harga-full'],
                        data['harga-diskon'],
                        data['kategori'],
                      );
                    },
                  )
                  : Column(
                    children: [
                      SvgPicture.string(noDataSvg),
                      SizedBox(height: 16),
                      Text(
                        "Belum Ada Tryout Tersedia",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  );
            }),

            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

Widget _cardPaketTryout(
  String image,
  String title,
  String hargaFull,
  String hargaDiskon,
  String kategori,
) {
  return Card(
    color: Colors.white,
    margin: EdgeInsets.all(32),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    elevation: 4,
    child: Container(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian kiri: gambar
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(8),
              bottomLeft: Radius.circular(8),
            ),
            child: Image.network(
              image, // ganti dengan gambar kamu
              width: 100,
              height: 120,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),

          // Bagian kanan: teks
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  hargaFull,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  hargaDiskon,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // Label CPNS
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.green,
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
                      SizedBox(width: 8),
                      Icon(Icons.circle, size: 12),
                      SizedBox(width: 8),
                      Icon(Icons.star, color: Colors.orangeAccent),
                      Text("5"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _eventTryoutGratis(
  String status,
  String judul,
  String tanggal,
  String periode,
) {
  return Container(
    margin: EdgeInsets.all(32),
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Color.fromARGB(255, 242, 255, 251),
      border: Border.all(
        color: Colors.transparent, // bisa atur warna border
        width: 2,
      ),
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.amber, // pindahkan color ke sini
            border: Border.all(
              color: Colors.transparent, // bisa atur warna border
              width: 2,
            ),
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          padding: EdgeInsets.all(2),
          child: Text(status, style: TextStyle(color: Colors.white)),
        ),
        SizedBox(height: 8),
        Text(judul, style: TextStyle(fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text(tanggal),
        Row(children: [Text("Periode :"), Text(" ${periode}")]),
      ],
    ),
  );
}
