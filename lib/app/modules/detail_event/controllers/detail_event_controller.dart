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
  RxMap<String, dynamic> userData = <String, dynamic>{}.obs;
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
    await getUserData();
    loading.value = false;
  }

  Future<void> getEvent() async {
    final response = await restClient.getData(
      url: baseUrl + apiGetDetailTryoutEvent + uuid,
    );
    Map<String, dynamic> data = Map<String, dynamic>.from(response['data']);
    dataEvent.assignAll(data);
  }

  Future<void> getUserData() async {
    final response = await restClient.getData(url: baseUrl + apiGetUser);
    Map<String, dynamic> data = Map<String, dynamic>.from(response['data']);
    userData.assignAll(data);
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

  String formatDate(String start, String end) {
    String rawDate = start;
    DateTime dateTime = DateTime.parse(rawDate);
    String rawDateend = end;
    DateTime dateTimeend = DateTime.parse(rawDateend);

    String formattedDate = DateFormat("dd MMMM yyyy").format(dateTime);
    String formattedDateend = DateFormat("dd MMMM yyyy").format(dateTimeend);

    return "$formattedDate - $formattedDateend";
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
