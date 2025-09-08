import 'dart:async';
import 'dart:ffi';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/data/rest_client_provider.dart';
import 'package:idcpns_mobile/app/modules/tryout/controllers/tryout_controller.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class DetailTryoutController extends GetxController {
  //TODO: Implement DetailTryoutController

  final count = 0.obs;
  late final localStorage;

  late String uuid;
  final restClient = RestClient();
  RxMap<dynamic, dynamic> detailData = {}.obs;
  RxList<String> option = ['Detail', 'Bundling', 'FAQ'].obs;
  RxMap<String, dynamic> wishList = <String, dynamic>{}.obs;
  RxList<dynamic> bundling = <dynamic>[].obs;
  RxMap<String, bool> isLoading =
      <String, bool>{
        "image": false,
        "wishlist": false,
        "detail": false,
        "bundling": false,
        "FAQ": false,
      }.obs;
  RxList<Map<String, dynamic>> bundlingList = <Map<String, dynamic>>[].obs;
  RxString FAQ = ''''''.obs;
  RxString Detail = ''''''.obs;
  RxBool isOnWishlist = false.obs;
  RxString selectedOption = "Detail".obs;
  RxString selectedUUid = "".obs;
  @override
  void onInit() async {
    super.onInit();
    await initData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> initData() async {
    localStorage = await SharedPreferences.getInstance();
    uuid = await Get.arguments;
    await getDetailTryout(); // tunggu sampai selesai
    await checkWishList();
    selectedUUid.value = uuid;
  }

  Future<bool> addToWishList() async {
    try {
      final client = Get.put(RestClientProvider());
      isLoading['wishlist'] = true;
      final payload = {
        "tryout_formasi_id": detailData['id'],
        "menu_category_id": detailData['menu_category_id'],
      };

      final response = await restClient.postData(
        url: baseUrl + apiAddWishList,
        payload: payload,
      );
      checkWishList();

      return true;
    } catch (e) {
      print("Exception: $e");
      return false;
    } finally {
      isLoading['wishlist'] = false;
    }
  }

  Future<bool> removeFromWishList() async {
    try {
      final client = Get.put(RestClientProvider());
      isLoading['wishlist'] = true;
      final payload = {"uuid": wishList['uuid']};
      final response = await restClient.postData(
        url: baseUrl + apiDeleteWishList,
        payload: payload,
      );

      isOnWishlist.value = false;
      isLoading['wishlist'] = false;
      return true;
    } catch (e) {
      print("Exception: $e");
      return false;
    } finally {
      isLoading['wishlist'] = false;
    }
  }

  Future<void> checkWishList() async {
    final client = Get.find<RestClientProvider>();
    restClient.getData(url: baseUrl + apiCheckWishList + uuid);
    final response = await restClient.getData(
      url: baseUrl + apiCheckWishList + uuid,
    );

    final data = response;
    isOnWishlist.value = data['data'] == null ? false : true;
    wishList.value = response['data'] ?? {};
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

  Future<void> getDetailTryout() async {
    try {
      final client = Get.find<RestClientProvider>();
      restClient.getData(url: baseUrl + apiGetDetailTryoutPaket + uuid);
      final response = await restClient.getData(
        url: baseUrl + apiGetDetailTryoutPaket + uuid,
      );

      final Map<dynamic, dynamic> paket = Map<dynamic, dynamic>.from(
        response['data'],
      );
      isLoading['image'] = true;
      isLoading['detail'] = true;
      detailData.assignAll(paket);
      FAQ.value = (paket['faq_mobile'] ?? "").toString();
      Detail.value = (paket['deskripsi_mobile'] ?? "").toString();
      bundling.value = paket['tryouts'];
    } catch (e) {
    } finally {
      isLoading['image'] = false;
      isLoading['detail'] = false;
    }
  }
}
