import 'package:get/get.dart';

class BimbelRecordController extends GetxController {
  var isLoading = true.obs;
  var rekamanList = Get.arguments;
  RxMap selectedVideo = {}.obs;
  final count = 0.obs;
  @override
  void onInit() {
    print("xcc ${selectedVideo.toString()}");
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void tontonVideo(Map<String, dynamic> video) {
    selectedVideo.value = video; // hanya simpan yang diklik
  }

  void closeVideo() => selectedVideo.value = {};
}
