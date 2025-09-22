import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:intl/intl.dart';

class DetailEventController extends GetxController {
  //TODO: Implement DetailEventController

  final count = 0.obs;
  final restClient = RestClient();
  late String uuid;
  RxMap<String, dynamic> dataEvent = <String, dynamic>{}.obs;
  RxString selectedPaket = "".obs;
  RxString selectedOption = "Detail".obs;
  RxList<String> option = ['Detail', 'FAQ'].obs;

  RxBool loading = true.obs;
  @override
  void onInit() {
    super.onInit();
    initEvent();
    checkMaintenance();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> initEvent() async {
    loading.value = true;
    uuid = await Get.arguments;
    await getEvent();
    loading.value = false;
  }

  Future<void> getEvent() async {
    final response = await restClient.getData(
      url: baseUrl + apiGetDetailTryoutEvent + uuid,
    );
    Map<String, dynamic> data = Map<String, dynamic>.from(response['data']);
    dataEvent.assignAll(data);
  }

  String formatCurrency(dynamic number) {
    var customFormatter = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp.',
      decimalDigits: 0,
    );
    var formattedValue = customFormatter.format(int.parse(number));
    return formattedValue.toString();
  }

  Future<void> checkMaintenance() async {
    final response = await restClient.getData(
      url: baseUrl + apiCheckMaintenance,
    );
    if (response['is_maintenance']) {
      Get.offAllNamed("/maintenance");
    }
  }
}
