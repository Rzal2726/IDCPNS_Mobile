import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/Components/widgets/notifCostume.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardController extends GetxController {
  final _restClient = RestClient();
  RxList kategoriData = [].obs;
  RxMap recomenData = {}.obs;
  RxList bannerData = [].obs;
  RxList bimbelRemainder = [].obs;
  RxList tryoutEventData = [].obs;
  RxMap tryoutRecomHomeData = {}.obs;
  RxInt menuCategoryId = 0.obs;
  RxInt bimbelParentId = 0.obs;
  RxInt tryoutFormasiId = 0.obs;
  RxInt upgradeId = 0.obs;
  RxList tryoutEventFilterData = [].obs;
  final TextEditingController tryoutSearch = TextEditingController();
  RxString selectedEventKategori = "Semua".obs;
  final options = <Map<String, dynamic>>[].obs;
  RxInt selectedKategoriId = 0.obs; // RxnInt karena bisa null
  final count = 0.obs;
  @override
  void onInit() {
    initScreen();
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

  Future<void> initScreen() async {
    await getUser();
    await getBanner();
    await getKategori();
    await getRecomendation();
    await getBimbelRemainder();
    await getTryoutEvent();
    getRecomenTryout();
  }

  void filterTryout({String? query, int? categoryId}) {
    final search = query?.toLowerCase() ?? '';

    if (query != null && query.isNotEmpty) {
      // Filter berdasarkan query saja
      final filtered =
          tryoutEventData.where((event) {
            return event['name'].toString().toLowerCase().contains(search);
          }).toList();

      tryoutEventFilterData.value = filtered;
    } else if (categoryId != null && categoryId != 0) {
      // Filter berdasarkan categoryId saja
      final filtered =
          tryoutEventData.where((event) {
            return event['menu_category_id'].toString() ==
                categoryId.toString();
          }).toList();

      tryoutEventFilterData.value = filtered;
      print("xx  ${categoryId.toString()} dan ${filtered.toString()}");
    } else {
      // Kalau tidak ada filter, tampilkan semua
      tryoutEventFilterData.value = List.from(tryoutEventData);
    }
  }

  Future<void> getKategori() async {
    try {
      final url = await baseUrl + apiGetKategori;

      final result = await _restClient.getData(url: url);
      if (result["status"] == "success") {
        var listData = result['data'];
        final data =
            (result['data'] as List)
                .map((e) => {"id": e['id'], "menu": e['menu']})
                .toList();
        kategoriData.value = listData;
        options.assignAll([
          {"id": 0, "menu": "Semua"},
          ...data,
        ]);
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }

  Future<void> getBanner() async {
    try {
      final url = await baseUrl + apiGetBannerHighlight;

      final result = await _restClient.getData(url: url);
      if (result["status"] == "success") {
        var data = result['data'];
        print(data);
        bannerData.value = data;
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }

  Future<void> getUser() async {
    try {
      final url = await baseUrl + apiGetUser;

      final result = await _restClient.getData(url: url);
      if (result["status"] == "success") {
        var data = result['data'];
        menuCategoryId.value = data['menu_category_id'];
        print("saa ${data['menu_category_id']}");
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }

  Future<Map?> getDetailBimbel({
    required String uuid,
    required String eventUuid,
  }) async {
    try {
      final url = baseUrl + apiGetDetailBimbelSaya + "/" + uuid;

      final result = await _restClient.getData(url: url);

      if (result["status"] == "success") {
        final data = result['data'];
        final events = data['bimbel']?['events'] as List?;

        if (events != null) {
          print("eventx");
          final event = events.firstWhere(
            (e) => e['uuid'] == eventUuid,
            orElse: () => {},
          );

          if (event.isNotEmpty) {
            print("event: ${event.toString()}");
            return Map.from(event);
          }
        }
      }
    } catch (e) {
      print("Error getDetailBimbel: $e");
    }

    return null;
  }

  Future<void> getTryoutEvent() async {
    try {
      final url = await baseUrl + apiGetTryoutEvent;

      final result = await _restClient.getData(url: url);
      if (result["status"] == "success") {
        var data = result['data'];
        tryoutEventData.value = data;
        tryoutEventFilterData.value = data;
      }
    } catch (e) {
      print("Error tryout event: $e");
    }
  }

  Future<void> getRecomenTryout() async {
    try {
      final url = await baseUrl + apiGetRekomendasiTryoutHome;

      final result = await _restClient.getData(url: url);
      if (result["status"] == "success") {
        var data = result['data'];
        tryoutRecomHomeData.value = data;
      }
    } catch (e) {
      print("Error tryout event: $e");
    }
  }

  Future<void> getRecomendation() async {
    try {
      final url = await baseUrl + apiGetRekomendasi;

      final result = await _restClient.getData(url: url);
      if (result["status"] == "success") {
        var data = result['data'];
        recomenData.value = data;
        print("asdad ${data}");
      }
    } catch (e) {
      print("Error polling email verification: $e");
    }
  }

  Future<void> launchHelp() async {
    final url = Uri.parse("https://panduan.idcpns.com/");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      notifHelper.show("Tidak dapat membuka URL.", type: 0);
    }
  }

  Future<void> launchWhatsApp() async {
    final Uri phoneNumber = Uri.parse("https://wa.me/6281377277248");

    if (await canLaunchUrl(phoneNumber)) {
      await launchUrl(phoneNumber, mode: LaunchMode.externalApplication);
    } else {
      notifHelper.show("Tidak dapat membuka WhatsApp.", type: 0);
    }
  }

  Future<void> getBimbelRemainder() async {
    try {
      final url = await baseUrl + apiBimbelReminder;

      final result = await _restClient.getData(url: url);
      if (result["status"] == "success") {
        var data = result['data'];
        bimbelRemainder.value = data;
      }
    } catch (e) {}
  }
}
