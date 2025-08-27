import 'dart:async';

import 'package:get/get.dart';
import 'package:idcpns_mobile/app/modules/tryout/controllers/tryout_controller.dart';

class DetailTryoutController extends GetxController {
  //TODO: Implement DetailTryoutController

  final count = 0.obs;
  final prevController = Get.find<TryoutController>();

  RxMap<dynamic, dynamic> detailData = {}.obs;
  RxList<String> option = ['Detail', 'Bundling', 'FAQ'].obs;
  RxBool isLoading = false.obs;
  RxList<Map<String, dynamic>> bundlingList =
      <Map<String, dynamic>>[
        {"judul": "Bundling 1", "soal": "110", "durasi": "230"},
        {"judul": "Bundling 2", "soal": "110", "durasi": "230"},
        {"judul": "Bundling 3", "soal": "110", "durasi": "230"},
      ].obs;
  RxString FAQ =
      '''
<div className="mt-8">
  <div className="mt-3 border border-muted-200 rounded-lg p-4">
    <h1 className="font-bold text-lg">
      Berapa jumlah tryout yang saya dapat pada paket bundling ini?
    </h1>
    <p className="text-muted-700 mt-2">
      Kamu akan mendapatkan total 10 tryout dalam paket ini yang mana artinya Kamu akan menghemat banyak biaya dibanding membeli tryout satuan.
    </p>
  </div>
'''.obs;
  RxString Detail =
      '''<h2 class="font-bold text-lg mt-5 mb-3">Lebih hemat beli tryout paket bundling.</h2>
<p class="text-sm">
  Siap bersaing bersama ribuan peserta seleksi CPNS lainnya! Ayo persiapkan diri kamu untuk seleksi CPNS selanjutnya dari sekarang dengan mengikuti Paket Tryout SKD CPNS dari IDCPNS ini.
</p>

<p class="text-sm pt-3">
  Tryout ini dirancang untuk membantu kamu mempersiapkan seleksi CPNS yang akan datang. Dengan kisi-kisi soal terupdate berdasarkan FR tahun-tahun sebelumnya, membuat kamu belajar lebih mudah. Dengan membeli paket tryout ini maka kamu akan mendapatkan :
</p>

<ul class="py-3 ml-3 list-disc list-inside">
  <li>10 Tryout SKD CPNS</li>
  <li>Masing-masing tryout terdiri dari 110 soal dengan waktu pengerjaan 100 menit</li>
  <li>Materi dan Penilaian yang selalu disesuaikan dengan ketentuan KEMENPAN-RB terbaru</li>
  <li>Dan masih banyak lagi</li>
</ul>

<p class="font-bold text-sm mt-10 mb-10">
  Yuk tunggu apalagi? Segera #CuriStart dan mulai langkah persiapanmu lebih awal dibanding peserta lainnya.
</p>'''.obs;
  RxBool isOnWishlist = false.obs;
  RxString selectedOption = "Detail".obs;
  @override
  void onInit() {
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

  void addToWishList() async {
    try {
      isLoading.value = true;
      isOnWishlist.value = true;
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  void removeFromWishList() async {
    try {
      isLoading.value = true;
      isOnWishlist.value = false;
    } catch (e) {
    } finally {
      isLoading.value = false;
    }
  }

  void checkWishList() async {}

  void getDetailTryout() async {}
}
