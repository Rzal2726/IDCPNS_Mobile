import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:intl/intl.dart';

class DetailWebinarController extends GetxController {
  //TODO: Implement DetailWebinarController

  final count = 0.obs;
  final restClient = RestClient();
  late String uuid;
  RxBool loading = false.obs;
  RxMap<String, dynamic> dataWebinar = <String, dynamic>{}.obs;
  RxList<String> tanggal = <String>[].obs;
  @override
  void onInit() {
    super.onInit();
    initWebinar();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> initWebinar() async {
    loading.value = true;
    uuid = await Get.arguments;
    await getWebinarDetail();
    tanggal.value = getDateTime(dataWebinar['tanggal']);
    loading.value = false;
  }

  Future<void> getWebinarDetail() async {
    final response = await restClient.getData(
      url: baseUrl + apiGetWebinarDetail + uuid,
    );
    Map<String, dynamic> data = Map<String, dynamic>.from(response['data']);
    dataWebinar.assignAll(data);
  }

  List<String> getDateTime(String date) {
    final fullDate = date.split(" ");
    final newDate = fullDate[0];
    final newTime = fullDate[1];

    final formatter = DateFormat("d MMMM y");
    final timeFormatter = DateFormat("HH:MM");
    final formattedDate = formatter.format(DateTime.parse(newDate));
    final formattedTime = timeFormatter.format(
      DateTime.parse("$newDate $newTime"),
    );
    return [formattedDate.toString(), formattedTime.toString()];
  }
}
