import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class VideoSeriesController extends GetxController {
  //TODO: Implement VideoSeriesController

  final count = 0.obs;
  final restClient = RestClient();
  List<Map<String, dynamic>> listVideo = <Map<String, dynamic>>[].obs;
  RxInt currentPage = 0.obs;
  RxInt totalPage = 1.obs;
  @override
  void onInit() {
    super.onInit();
    initVideoSeries();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> initVideoSeries() async {
    await fetchVideoData();
  }

  Future<void> fetchVideoData() async {
    final response = await restClient.postData(
      url: baseUrl + apiListVideoSeries,
    );
    List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      response['data']['data'],
    );
    if (response['status'] == "success") {
      listVideo.assignAll(data);
      print(data);
    } else {
      Get.snackbar("Error", "Failed to fetch data");
    }
  }
}
