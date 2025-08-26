import 'package:get/get.dart';

class TransactionController extends GetxController {
  RxList<Transaction> transactions = <Transaction>[].obs;
  RxString selectedFilter = "Semua".obs;
  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
    // Dummy data
    transactions.addAll([
      Transaction(
        id: "INV/20250822/TO/31973/415328",
        name: "Paket Tryout SKD CPNS",
        date: "2025-08-22 11:22:55",
        amount: 200546,
        status: "Gagal",
      ),
      Transaction(
        id: "INV/20250822/TO/31973/719190",
        name: "Paket Tryout SKD CPNS",
        date: "2025-08-22 11:22:21",
        amount: 202313,
        status: "Gagal",
      ),
      Transaction(
        id: "INV/20250822/TO/31973/650816",
        name: "Paket Tryout SKD CPNS",
        date: "2025-08-22 11:21:55",
        amount: 203440,
        status: "Gagal",
      ),
      Transaction(
        id: "INV/20250821/TO/31973/748386",
        name: "Paket Tryout SKD CPNS",
        date: "2025-08-21 10:12:42",
        amount: 200546,
        status: "Gagal",
      ),
    ]);
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  List<Transaction> get filteredTransactions {
    if (selectedFilter.value == "Semua") {
      return transactions;
    }
    return transactions.where((t) => t.status == selectedFilter.value).toList();
  }
}

class Transaction {
  final String id;
  final String name;
  final String date;
  final double amount;
  final String status; // "Gagal", "Sukses", "Menunggu"

  Transaction({
    required this.id,
    required this.name,
    required this.date,
    required this.amount,
    required this.status,
  });
}
