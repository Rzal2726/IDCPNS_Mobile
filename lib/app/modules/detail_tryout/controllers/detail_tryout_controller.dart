import 'dart:async';
import 'dart:ffi';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/data/rest_client_provider.dart';
import 'package:idcpns_mobile/app/modules/tryout/controllers/tryout_controller.dart';
import 'package:intl/intl.dart';

class DetailTryoutController extends GetxController {
  //TODO: Implement DetailTryoutController

  final count = 0.obs;
  final prevController = Get.find<TryoutController>();

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
    await getDetailTryout(); // tunggu sampai selesai
    await checkWishList();
    selectedUUid.value = prevController.selectedUuid.value;
  }

  Future<bool> addToWishList() async {
    try {
      final client = Get.put(RestClientProvider());
      isLoading['wishlist'] = true;
      final response = await client.post(
        headers: {
          "Authorization":
              "Bearer 18|V9PnP29RzhtFCKwwbb1NLFUliZ9YLK9PiFDCa5Ir9f6c4eb3",
        },
        "/account/user/wishlist/add",
        {
          "tryout_formasi_id": detailData['id'],
          "menu_category_id": detailData['menu_category_id'],
        },
      );

      if (response.statusCode == 200) {
        print(response.body);
        isLoading['wishlist'] = true;
        return true;
      } else {
        print("❌ Error: ${response.statusCode}");
        print("❌ Error: ${response.statusText}");

        return false;
      }
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
      final response = await client.post(
        "/account/user/wishlist/delete",
        {"uuid": wishList['uuid']},
        headers: {
          "Authorization":
              "Bearer 18|V9PnP29RzhtFCKwwbb1NLFUliZ9YLK9PiFDCa5Ir9f6c4eb3",
        },
      );

      if (response.statusCode == 200) {
        print(response.body);
        print(wishList);
        wishList;
        print(prevController.selectedUuid.value);
        isOnWishlist.value = false;
        isLoading['wishlist'] = false;
        return true;
      } else {
        print("❌ Error: ${response.statusCode}");
        print("❌ Error: ${response.statusText}");
        return false;
      }
    } catch (e) {
      print("Exception: $e");
      return false;
    } finally {
      isLoading['wishlist'] = false;
    }
  }

  Future<void> checkWishList() async {
    final client = Get.find<RestClientProvider>();
    final response = await client.get(
      headers: {
        "Authorization":
            "Bearer 18|V9PnP29RzhtFCKwwbb1NLFUliZ9YLK9PiFDCa5Ir9f6c4eb3",
      },
      '/account/user/wishlist/${prevController.selectedUuid.value}',
    );

    if (response.statusCode == 200) {
      final data = response.body;
      isOnWishlist.value = data['data'] == null ? false : true;
      wishList.value = response.body['data'];
      print(data['data']);
    } else {
      print('Error: ${response.statusText}');
    }
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
      final response = await client.get(
        headers: {
          "Authorization":
              "Bearer 18|V9PnP29RzhtFCKwwbb1NLFUliZ9YLK9PiFDCa5Ir9f6c4eb3",
        },
        '/tryout/formasi/${prevController.selectedUuid.value}',
      );

      if (response.statusCode == 200) {
        final Map<dynamic, dynamic> paket = Map<dynamic, dynamic>.from(
          response.body['data'],
        );
        isLoading['image'] = true;
        isLoading['detail'] = true;
        detailData.assignAll(paket);
        FAQ.value = (paket['faq_mobile'] ?? "").toString();
        Detail.value = (paket['deskripsi_mobile'] ?? "").toString();
        bundling.value = paket['tryouts'];
      } else {
        print('Error: ${response.statusText}');
      }
    } catch (e) {
    } finally {
      isLoading['image'] = false;
      isLoading['detail'] = false;
    }
  }
}
