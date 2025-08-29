import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';
import 'package:idcpns_mobile/styles/app_style.dart';

import '../controllers/bimbel_controller.dart';

class BimbelView extends GetView<BimbelController> {
  const BimbelView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(64),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
          title: Image.asset(
            'assets/logo.png', // ganti dengan logo proyekmu
            height: 40,
          ),
          actions: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                IconButton(
                  icon: Icon(Icons.notifications_none, color: Colors.teal),
                  onPressed: () {},
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1),
                    ),
                    child: Text(
                      '9+',
                      style: TextStyle(color: Colors.white, fontSize: 10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: AppStyle.sreenPaddingHome,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bimbel Saya card (outline teal + light fill)
              InkWell(
                onTap: () {
                  Get.offNamed(Routes.MY_BIMBEL);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    border: Border.all(color: Colors.teal.shade200, width: 1.6),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.teal.shade100),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 2,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Icon(Icons.school, color: Colors.teal),
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Bimbel Saya',
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

              SizedBox(height: 20),

              // Header Paket Bimbel
              Text(
                'Paket Bimbel',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4),
              Text(
                'Belajar lebih intensif bersama mentor ahli di bidangnya.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              SizedBox(height: 12),

              // Search row
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: controller.searchPaket,
                      decoration: InputDecoration(
                        hintText: 'Apa yang ingin Anda cari',
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.teal, width: 2),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                    ),
                    child: Text('Cari'),
                  ),
                ],
              ),

              SizedBox(height: 10),

              // Filter (right)
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {},
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Filter', style: TextStyle(color: Colors.teal)),
                      Icon(Icons.keyboard_arrow_down, color: Colors.teal),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 8),

              // List paket (mirip style gambar)
              Obx(() {
                if (controller.paketList.isEmpty) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: Text(
                        'Belum ada paket tersedia',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: controller.paketList.length,
                  itemBuilder: (context, index) {
                    final paket = controller.paketList[index];
                    // sesuaikan keys ('image','title','hargaFull','hargaDiskon','kategori') dengan datamu
                    return _cardPaketBimbel(
                      image: paket['image'] ?? '',
                      title: paket['title'] ?? '',
                      hargaFull: paket['hargaFull'] ?? '',
                      hargaDiskon: paket['hargaDiskon'] ?? '',
                      kategori: paket['kategori'] ?? '',
                      onTap: () {
                        controller.selectedUuid.value = paket['uuid'] ?? '';
                        Get.toNamed(Routes.DETAIL_BIMBEL); // sesuaikan rute
                      },
                    );
                  },
                );
              }),

              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // ----- helper widget: paket card -----
  Widget _cardPaketBimbel({
    required String image,
    required String title,
    required String hargaFull,
    required String hargaDiskon,
    required String kategori,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
        child: SizedBox(
          height: 120,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // left image box (rounded + white card look)
              Container(
                margin: EdgeInsets.all(10),
                width: 92,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child:
                    (image != ''
                        ? ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(image, fit: BoxFit.cover),
                        )
                        : Center(child: Icon(Icons.image, color: Colors.grey))),
              ),

              SizedBox(width: 8),

              // right details
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // title & (optional subtitle)
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      // harga row
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(
                            child: Text(
                              hargaFull,
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                decoration: TextDecoration.lineThrough,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 6),
                          Text(
                            hargaDiskon,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),

                      // bottom row: chip + rating (mirip screenshot)
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.teal,
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
                          Icon(Icons.circle, size: 8, color: Colors.grey),
                          SizedBox(width: 8),
                          Icon(
                            Icons.star,
                            color: Colors.orangeAccent,
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text("5", style: TextStyle(fontSize: 12)),
                        ],
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
}
