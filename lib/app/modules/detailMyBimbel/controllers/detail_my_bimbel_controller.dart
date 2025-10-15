import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idcpns_mobile/app/Components/widgets/notifCostume.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:idcpns_mobile/app/routes/app_pages.dart';

class DetailMyBimbelController extends GetxController {
  final _restClient = RestClient();
  final box = GetStorage();
  var uuid = Get.arguments;
  var paketName = "Bimbel SKD CPNS 2024 Batch 12".obs;
  var paketType = "Reguler".obs;
  var masaAktif = 178.obs; // hari aktif
  RxBool platinumZone = false.obs;
  RxMap bimbelData = {}.obs;
  RxMap bimbelBuyData = {}.obs;
  RxMap rankBimbel = {}.obs;
  RxInt userRank = 0.obs;
  RxInt hargaFix = 0.obs;
  RxList jadwalKelas = [].obs;
  RxList jadwalKelasIsRunning = [].obs;
  RxString selectedPaket = "".obs;
  RxString levelName = "".obs;
  RxList otherBimbelData = [].obs;
  RxMap paymentData = {}.obs;

  final count = 0.obs;
  @override
  void onInit() {
    refresh();
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

  void pilihPaket(String paket) {
    selectedPaket.value = paket;
    print("xxx${paket.toString()}");
  }

  Future<void> refresh() async {
    getPaymentData();
    getData();

    levelName.value = box.read('levelName') ?? "";
    checkMaintenance();
  }

  Future<void> getOtherBimbel({required int parentId}) async {
    final url = baseUrl + apiGetBimbelOther;
    print("xxx ${url.toString()}");

    final result = await _restClient.getData(url: url);

    if (result["status"] == "success") {
      final List allBimbel = result["data"] ?? [];

      // filter kecuali yang id == parentId.value
      otherBimbelData.value =
          allBimbel.where((bimbel) => bimbel['id'] != parentId).toList();
    } else {
      notifHelper.show(result['message'] ?? "Terjadi kesalahan", type: 0);
    }
  }

  Future<void> getPaymentData() async {
    try {
      final url = await baseUrl + apiGetPaymentList;

      final result = await _restClient.getData(url: url);
      print("emailnnyaa ${result.toString()}");
      if (result["status"] == "success") {
        paymentData.value = result;
      }
    } catch (e) {
      print("Errorxx: $e");
    }
  }

  Future<void> getDataChangePaket() async {
    final url = baseUrl + apiGetDetailBimbelNoevent + "/" + selectedPaket.value;
    final result = await _restClient.getData(url: url);

    // cek status dulu, kalau success lanjut
    if (result["status"] == "success") {
      // paketBimbelData.value = result;
      await getOtherBimbel(parentId: result['data']['id']);

      Get.toNamed(
        Routes.PAYMENT_DETAIL,
        arguments: [hargaFix.value, result, paymentData, otherBimbelData],
      );
    } else {
      // kalau status bukan success, tampilkan pesan server
      print("Fetch failed: ${result['message']}");
      // bisa juga kasih notif ke user
      notifHelper.show(result['message'] ?? "Terjadi kesalahan", type: 0);
    }
  }

  Future<void> getData() async {
    try {
      final url =
          await baseUrl + apiGetDetailBimbelSaya + "/" + uuid.toString();

      final result = await _restClient.getData(url: url);
      if (result["status"] == "success") {
        bimbelData.value = result['data'];
        getDetailBimbel(id: result['data']['bimbel']['bimbel_parent']['uuid']);
        jadwalKelas.value =
            (result['data']['bimbel']['events'] as List)
                .where((e) => e['is_running'] == false)
                .toList();
        jadwalKelasIsRunning.value =
            (result['data']['bimbel']['events'] as List)
                .where((e) => e['is_running'] == true)
                .toList();
        platinumZone.value = result['data']['ispremium'] == 1;

        getJadwalBimbel(id: bimbelData['user_id']);
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }

  Future<void> getDetailBimbel({required String id}) async {
    try {
      final url = baseUrl + apiGetDetailBimbel + "/" + id;

      final result = await _restClient.getData(url: url);
      print("asdas ${result.toString()}");

      if (result["status"] == "success") {
        var data = result['data'];
        bimbelBuyData.value = data;

        // ambil id pertama dari list result['data']['bimbel']
        if (data['bimbel'] is List && (data['bimbel'] as List).isNotEmpty) {
          // filter data sesuai kondisi
          final filtered =
              (data['bimbel'] as List).where((item) {
                return (item['is_showing'] ?? false) &&
                    (item['is_purchase'] == false);
              }).toList();

          if (filtered.isNotEmpty) {
            // ambil data terakhir dari list awal yang sudah di-filter
            final lastItem = filtered.first;
            final index = data['bimbel'].indexOf(lastItem);
            selectedPaket.value = lastItem['uuid'];
            hargaFix.value = hitungHargaTampil(
              lastItem,
              index,
              data['bimbel'],
            ); // ✅
            print("xxx3 ${selectedPaket.toString()}");
          }
        } else {
          selectedPaket.value = ""; // fallback, misal 0 berarti belum dipilih
        }
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }

  Future<void> getJadwalBimbel({required int id}) async {
    try {
      final url = baseUrl + apiGetRankingBimbel + "/" + uuid;
      final result = await _restClient.postData(url: url);

      if (result["status"] == "success") {
        var data = result['data'];
        rankBimbel.value = data;

        // ambil list rank
        final listRank = data['data'] as List;

        // cari user_id yang sama dengan id yang dipassing
        final found = listRank.firstWhere(
          (item) => item['user_id'] == id,
          orElse: () => null,
        );

        if (found != null) {
          userRank.value = found['rank'];
        }
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }

  Future<void> checkMaintenance() async {
    final response = await _restClient.getData(
      url: baseUrl + apiCheckMaintenance,
    );
    if (response['is_maintenance']) {
      Get.offAllNamed("/maintenance");
    }
  }

  int hitungHargaTampil(Map<String, dynamic> subData, int index, List bimbel) {
    final firstPurchasedIndex = bimbel.indexWhere(
      (e) => e['is_purchase'] == true,
    );

    if (firstPurchasedIndex != -1 && index > firstPurchasedIndex) {
      return subData['harga_fix'] - bimbel[firstPurchasedIndex]['harga_fix'];
    } else {
      return subData['harga_fix'];
    }
  }
}
