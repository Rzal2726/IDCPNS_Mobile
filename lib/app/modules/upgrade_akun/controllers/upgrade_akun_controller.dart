import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class UpgradeAkunController extends GetxController {
  //TODO: Implement UpgradeAkunController

  final count = 0.obs;
  final restClient = RestClient();
  RxMap<String, dynamic> detailAkun = <String, dynamic>{}.obs;
  RxList<Map<String, dynamic>> listDurasi = <Map<String, dynamic>>[].obs;
  RxList<Map<String, dynamic>> listBonus = <Map<String, dynamic>>[].obs;
  RxString selectedBonusUuid = "".obs;
  RxString selectedDurasi = "".obs;
  @override
  void onInit() {
    super.onInit();
    initUpgrade();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> initUpgrade() async {
    await fetchDetailUpgrade();
    await fetchListBonus();
    await fetchListDurasi();
  }

  Future<void> fetchDetailUpgrade() async {
    final response = await restClient.getData(
      url: baseUrl + apiDetailUpgradeAkun,
    );
    Map<String, dynamic> data = Map<String, dynamic>.from(response['data']);
    detailAkun.assignAll(data);
  }

  Future<void> fetchListDurasi() async {
    final response = await restClient.getData(url: baseUrl + apiDurasiUpgrade);
    List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      response['data'],
    );
    listDurasi.assignAll(data);
  }

  Future<void> fetchListBonus() async {
    final response = await restClient.getData(url: baseUrl + apiBonusUpgrade);
    List<Map<String, dynamic>> data = List<Map<String, dynamic>>.from(
      response['data'],
    );
    listBonus.assignAll(data);
  }

  void upgradeSekarang() {
    Get.toNamed(
      '/payment-upgrade-akun',
      arguments: {
        "bonus_uuid": selectedBonusUuid.value,
        "durasi_uuid": selectedDurasi.value,
      },
    );
  }
}
