import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idcpns_mobile/app/Components/widgets/notifCostume.dart';
import 'package:idcpns_mobile/app/Components/widgets/syaratKetentuanDialog.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class AffiliateController extends GetxController {
  final _restClient = RestClient();
  var box = GetStorage();
  RxBool affiliateStatus = false.obs;
  RxMap finaceData = {}.obs;
  RxInt komisiTotal = 0.obs;
  RxInt komisiTersedia = 0.obs;
  RxInt komisiDitarik = 0.obs;
  TextEditingController kodeController = TextEditingController();
  @override
  void onInit() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showSyaratKetentuanDialog();
    });
    kodeController.text = box.read('afiCode') ?? '';

    getCheckAffiliate();
    getFinance();
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

  void simpanKode() async {
    final kode = kodeController.text.trim();

    // Validasi panjang kode
    if (kode.length < 8) {
      notifHelper.show("Kode afiliasi minimal 8 karakter", type: 0);
      return;
    }
    if (kode.length > 12) {
      notifHelper.show("Kode afiliasi maksimal 12 karakter", type: 0);
      return;
    }

    try {
      final url = await baseUrl + apiGetSubmitAfiliansi;
      final payload = {'kode_afiliasi': kode};
      print("xxx $payload");

      final result = await _restClient.postData(url: url, payload: payload);

      if (result["status"] == "success") {
        notifHelper.show("Kode berhasil disimpan", type: 1);
        box.write("afiCode", kode);
      } else if (result["status"] == "error") {
        // Ambil pesan dari messages
        final message =
            result["messages"] ?? "Kode afiliasi tidak bisa dipakai";
        notifHelper.show(message, type: 0);
      } else {
        // Fallback
        notifHelper.show("Gagal menyimpan kode", type: 0);
      }
    } catch (e) {
      print("Error simpan kode: $e");
      notifHelper.show("Terjadi kesalahan, coba lagi", type: 0);
    }
  }

  Future<void> getCheckAffiliate() async {
    try {
      final url = await baseUrl + apiGetCheckAfiliasi;

      final result = await _restClient.getData(url: url);
      print("emailnnyaa ${result.toString()}");
      if (result["status"] == "success") {
        affiliateStatus.value = result["exist"];
        print("sadas ${result["exist"]}");
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }

  Future<void> getFinance() async {
    try {
      final url = await baseUrl + apiGetFinance;

      final result = await _restClient.getData(url: url);
      if (result["status"] == "success") {
        finaceData.value = result['data'];
        komisiTotal.value = finaceData['komisi_total'];
        komisiTersedia.value = finaceData['komisi_tersedia'];
        komisiDitarik.value = finaceData['komisi_ditarik'];
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }
}
