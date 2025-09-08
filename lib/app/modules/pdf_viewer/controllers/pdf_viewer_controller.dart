import 'package:get/get.dart';

class PdfViewerController extends GetxController {
  final url = ''.obs; // RxString

  @override
  void onInit() {
    super.onInit();
    url.value = Get.arguments ?? ''; // isi dari argument GetX
  }
}
