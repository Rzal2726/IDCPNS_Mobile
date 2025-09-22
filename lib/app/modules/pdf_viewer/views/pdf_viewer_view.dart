import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart' as syncfusion;

import '../controllers/pdf_viewer_controller.dart';

class PdfViewerView extends GetView<PdfViewerController> {
  const PdfViewerView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('E-Book', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        elevation: 1,
      ),
      body: SafeArea(
        child: Obx(
          () =>
              controller.url.value == ''
                  ? Skeletonizer(child: Text("data"))
                  : syncfusion.SfPdfViewer.network(
                    pageLayoutMode: syncfusion.PdfPageLayoutMode.single,
                    scrollDirection: syncfusion.PdfScrollDirection.horizontal,
                    controller.url.value,
                    enableTextSelection: false,
                    canShowScrollStatus: true, // status saat scroll
                    canShowTextSelectionMenu: false,
                    onDocumentLoadFailed: (details) {
                      Get.back();
                    },
                  ),
        ),
      ),
    );
  }
}
