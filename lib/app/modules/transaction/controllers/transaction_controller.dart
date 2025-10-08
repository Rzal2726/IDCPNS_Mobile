import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:idcpns_mobile/app/Components/widgets/notifCostume.dart';
import 'package:idcpns_mobile/app/constant/api_url.dart';
import 'package:idcpns_mobile/app/providers/rest_client.dart';

class TransactionController extends GetxController {
  final _restClient = RestClient();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  RxMap transactions = {}.obs;
  RxInt totalPage = 0.obs;
  final option = ["Semua", "Sukses", "Menunggu Pembayaran", "Gagal"];
  final selectedOption = "Semua".obs;
  RxInt currentPage = 1.obs;
  RxInt totalPages = 0.obs;
  RxBool isloading = true.obs;
  RxString status = "".obs;
  final count = 0.obs;
  @override
  void onInit() {
    refresh();
    super.onInit();
    // Dummy data
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    searchController.removeListener(_onSearchChanged);
    searchController.dispose();
    super.onClose();
  }

  void goToPage(int page) {
    if (page >= 1 && page <= totalPage.value) {
      currentPage.value = page;
      getTransaction(page: currentPage.value, status: status.value);
      // panggil API fetch data di sini jika perlu
    }
  }

  void nextPage() {
    if (currentPage.value < totalPage.value) {
      currentPage.value++;
      getTransaction(page: currentPage.value, status: status.value);
      // panggil API fetch data di sini
    }
  }

  void prevPage() {
    if (currentPage.value > 1) {
      currentPage.value--;
      getTransaction(page: currentPage.value, status: status.value);
      // panggil API fetch data di sini
    }
  }

  void getDate() {
    getTransaction(
      page: currentPage.value,
      date: startDateController.text,
      status: status.value,
    );
  }

  void _onSearchChanged() {
    final query = searchController.text;
    // Optional: pakai debounce supaya API tidak kebanyakan dipanggil
    getTransaction(
      page: 1, // reset ke page 1 kalau search
      search: query,
      date: startDateController.text,
      status: status.value,
    );
  }

  Future<void> getTransaction({
    int? page,
    String? search,
    String? status,
    String? date,
  }) async {
    isloading.value = true;
    print("xvv ${isloading.toString()}");
    final url = await baseUrl + apiGetTransaction;
    var payload = {
      "perpage": 10,
      "page": page ?? 0,
      "tanggal_mulai": dateFormat(date ?? ""),
      "search": search ?? "",
      "status": status ?? "",
    };
    print("xxx${payload.toString()}");
    final result = await _restClient.postData(url: url, payload: payload);

    if (result["status"] == "success") {
      var data = result['data'];
      transactions.value = data;
      totalPage.value = data['last_page'];
      isloading.value = false;
      print("xvv ${isloading.toString()}");
    }
  }

  Future<void> refresh() async {
    isloading.value = true; // 🔹 aktifkan loading state
    selectedOption.value = "Semua"; // 🔹 ini harus pakai '='
    status.value = "";
    searchController.clear();
    startDateController.clear();
    endDateController.clear();

    // Atur tanggal default (misal hari ini)
    final today = DateTime.now();
    endDateController.text =
        "${today.day.toString().padLeft(2, '0')}/"
        "${today.month.toString().padLeft(2, '0')}/"
        "${today.year}";

    currentPage.value = 1;

    await getTransaction(search: "", page: 1, date: "", status: "");

    isloading.value = false;
  }

  Future<void> deleteTransaction({required String id}) async {
    try {
      final url = await baseUrl + apiCencelPayment + "/" + id;
      final result = await _restClient.postData(url: url);
      if (result["status"] == "success") {
        notifHelper.show("Transaksi berhasil dibatalkan", type: 1);
        getTransaction();
      }
    } catch (e) {
      print("Error: $e");
    }
  }
}

String dateFormat(String date) {
  if (date.isEmpty) return "";
  final parts = date.split('/');
  if (parts.length != 3)
    return date; // kembalikan apa adanya kalau format salah
  final day = parts[0].padLeft(2, '0');
  final month = parts[1].padLeft(2, '0');
  final year = parts[2];
  return "$year-$month-$day";
}
