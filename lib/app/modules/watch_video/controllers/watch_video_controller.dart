import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class WatchVideoController extends GetxController {
  //TODO: Implement WatchVideoController

  final restClient = RestClient();
  late Map<String, dynamic> prevData;

  List<Map<String, dynamic>> listVideo = <Map<String, dynamic>>[].obs;
  Map<String, dynamic> dataDetail = <String, dynamic>{}.obs;
  Map<String, dynamic> loading = <String, dynamic>{}.obs;

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

  void test() {
    print("object");
  }

  Future<void> initVideoSeries() async {
    prevData = await Get.arguments;
    dataDetail = prevData;
    await fetchVideoData();
    print("Data Detail: ${dataDetail}");
    print("prevData: ${prevData}");
  }

  Future<void> fetchVideoData() async {
    loading['video'] = true;
    final response = await restClient.getData(
      url: baseUrl + apiListVideoSeriesParents + prevData['uuid'],
    );
    List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      response['data'],
    );
    if (response['status'] == "success") {
      listVideo.assignAll(data);
      print(data);
    } else {
      Get.snackbar("Error", "Failed to fetch data");
    }
    loading['video'] = false;
  }
}
