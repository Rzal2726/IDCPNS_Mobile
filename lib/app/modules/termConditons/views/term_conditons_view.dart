import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/modules/notification/views/notification_view.dart';
import 'package:idcpns_mobile/styles/app_style.dart';

import '../controllers/term_conditons_controller.dart';

class TermConditonsView extends GetView<TermConditonsController> {
  const TermConditonsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 100, // kasih ruang supaya teks muat
        leading: TextButton.icon(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back, color: Colors.lightBlue),
          label: Text("Kembali", style: TextStyle(color: Colors.lightBlue)),
          style: TextButton.styleFrom(
            padding: EdgeInsets.only(left: 8), // biar rapih di kiri
          ),
        ),
        automaticallyImplyLeading: false, // hilangkan default back button
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          // kalau konten HTML panjang
          child: Obx(() {
            return Padding(
              padding: AppStyle.contentPadding,
              child: Html(data: controller.htmlContent.value),
            );
          }),
        ),
      ),
    );
  }
}
