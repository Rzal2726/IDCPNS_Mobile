import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class PretestResultController extends GetxController {
  final restClient = RestClient();

  // arguments
  var uuid = Get.arguments['uuid'];
  var bimbelUuid = Get.arguments['bimbelUuid'];

  // state
  RxMap nilaiData = {}.obs;
  RxMap bimbelSaya = {}.obs;

  @override
  void onInit() {
    initHasil();
    super.onInit();
  }

  Future<void> initHasil() async {
    print("xxx ${uuid} dan ${bimbelUuid}");
    await getDetailBimbel();
    await getNilai();
  }

  Future<void> getNilai() async {
    try {
      final url = baseUrl + apiPretestResult + "/$bimbelUuid";
      final response = await restClient.getData(url: url);

      if (response["status"] == "success") {
        nilaiData.value = response['data'];
      } else {
        print("Gagal mengambil nilai: ${response['message']}");
      }
    } catch (e) {
      print("Error getNilai: $e");
    }
  }

  Future<void> getDetailBimbel() async {
    try {
      final url = baseUrl + apiGetDetailBimbelSaya + "/$uuid";
      final response = await restClient.getData(url: url);

      if (response["status"] == "success") {
        bimbelSaya.value = response['data'];
      } else {
        print("Gagal mengambil detail bimbel: ${response['message']}");
      }
    } catch (e) {
      print("Error getDetailBimbel: $e");
    }
  }
}
