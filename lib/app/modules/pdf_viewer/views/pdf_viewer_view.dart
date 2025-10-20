import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/appBarCotume.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart' as syncfusion;

import '../controllers/pdf_viewer_controller.dart';

class PdfViewerView extends GetView<PdfViewerController> {
  const PdfViewerView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // biar kita yang kontrol back nya
      onPopInvoked: (didPop) {
        if (!didPop) {
          Get.offNamed('/e-book');
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: secondaryAppBar(
          "E-Book",
          onBack: () => Get.offNamed('/e-book'),
        ),
        body: Stack(
          children: [
            SafeArea(
              child: Obx(
                () =>
                    controller.url.value == ''
                        ? Skeletonizer(child: Text("data"))
                        : syncfusion.SfPdfViewer.network(
                          pageLayoutMode: syncfusion.PdfPageLayoutMode.single,
                          scrollDirection:
                              syncfusion.PdfScrollDirection.horizontal,
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

            Obx(
              () =>
                  controller.showSwipeHint.value && controller.url.value != ''
                      ? SwipeHintOverlay(
                        onDismiss: () => controller.showSwipeHint.value = false,
                        animation: controller.slide,
                      )
                      : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  Widget SwipeHintOverlay({
    required bool Function() onDismiss,
    required Animation<double> animation,
  }) {
    return AnimatedOpacity(
      opacity:
          0.999, // keep composited; use 0.999 instead of 1.0 to avoid some GPU quirks
      duration: const Duration(milliseconds: 250),
      child: Stack(
        children: [
          // 50% transparent backdrop
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.5)),
          ),

          // Center hint card (not interactive—gestures pass through)
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.95),
                borderRadius: BorderRadius.circular(16),
              ),
              width: 260,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Geser ke kiri untuk halaman berikutnya',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 56,
                    child: AnimatedBuilder(
                      animation: animation,
                      builder: (_, __) {
                        // Slide an arrow left-right in a 120px lane
                        final dx = (1 - animation.value) * 20; // tweak distance
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            // little lane dots
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                6,
                                (i) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 6,
                                  ),
                                  child: Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: Colors.black26,
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Transform.translate(
                              offset: Offset(dx, 0),
                              child: const Icon(Icons.swipe_left, size: 40),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: Colors.teal.shade300,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: BorderSide(
                            color: Colors.teal.shade300,
                            width: 1.5,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onPressed: onDismiss,
                      child: Text("Mengerti"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
