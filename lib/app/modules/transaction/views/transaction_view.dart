import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idcpns_mobile/app/modules/transaction/controllers/transaction_controller.dart';

class TransactionView extends GetView<TransactionController> {
  const TransactionView({super.key});

  // ==== warna2 yang mirip di UI ====
  Color get _primary =>
      const Color(0xFF16A75C); // hijau indikator/tab & border search
  Color get _bg => const Color(0xFFF6F6F6); // background layar
  Color get _danger => const Color(0xFFE84855); // label Gagal
  Color get _softText => const Color(0xFF8F8F8F);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: _bg,
        appBar: _buildAppBar(context),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ===== TAB BAR =====
            Material(
              color: Colors.white,
              child: TabBar(
                labelColor: _primary,
                unselectedLabelColor: Colors.black87,
                indicatorColor: _primary,
                indicatorWeight: 3,
                labelStyle: const TextStyle(fontWeight: FontWeight.w600),
                tabs: const [
                  Tab(text: 'Semua'),
                  Tab(text: 'Sukses'),
                  Tab(text: 'Menunggu Pembayaran'),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // ===== SEARCH =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _SearchField(
                borderColor: _primary,
                hint: 'Cari',
                onChanged: (q) {
                  // opsional: sambungkan ke controller kalau kamu punya search
                  // controller.searchQuery.value = q;
                  controller
                      .update(); // biar Obx/GetBuilder yang kamu pakai ngerender ulang
                },
              ),
            ),
            const SizedBox(height: 12),

            // ===== HEADER RIWAYAT + FILTER =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  const Text(
                    'Riwayat Transaksi',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                  ),
                  const Spacer(),
                  InkWell(
                    borderRadius: BorderRadius.circular(8),
                    onTap: () {
                      // buka bottom sheet filter kalau ada
                    },
                    child: Row(
                      children: const [
                        Text(
                          'Filter',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_drop_down, size: 18),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // ===== LIST PER TAB =====
            Expanded(
              child: TabBarView(
                children: [
                  _buildList(status: null), // Semua
                  _buildList(status: 'Sukses'), // Sukses
                  _buildList(status: 'Menunggu'), // Menunggu Pembayaran
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===================== WIDGETS =====================

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      titleSpacing: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 18),
        onPressed: () => Get.back(),
      ),
      title: const Text(
        'Transaksi',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.notifications_rounded,
                  color: Colors.teal,
                ),
              ),
              // badge "9+"
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEF4444),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    '9+',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildList({String? status}) {
    return GetBuilder<TransactionController>(
      builder: (_) {
        // ambil data dari controller
        final all = controller.transactions; // RxList di controller
        // filter status (kalau null = semua)
        final data =
            all.where((t) {
              if (status == null) return true;
              if (status == 'Menunggu') {
                // samakan sendiri dengan field status di model-mu (e.g. "Menunggu Pembayaran")
                return t.status.toLowerCase().contains('menunggu');
              }
              return t.status == status;
            }).toList();

        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          itemCount: data.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (context, i) {
            final trx = data[i];
            return _TransactionCard(
              id: trx.id,
              name: trx.name,
              dateTimePrice:
                  '${trx.date} - Rp.${trx.amount.toStringAsFixed(0)}',
              statusText: trx.status, // "Gagal" / "Sukses" / "Menunggu"
              statusColor:
                  trx.status == 'Sukses'
                      ? _primary
                      : (trx.status.toLowerCase().contains('menunggu')
                          ? const Color(0xFFF59E0B)
                          : _danger),
              softTextColor: _softText,
              trailingIcon: Icons.chevron_right_rounded,
              primary: _primary,
            );
          },
        );
      },
    );
  }
}

/// Search field mirip screenshot (ikon di kanan dalam kotak kecil)
class _SearchField extends StatelessWidget {
  final Color borderColor;
  final String hint;
  final ValueChanged<String>? onChanged;

  const _SearchField({
    required this.borderColor,
    required this.hint,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(10);
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: borderColor, width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: borderColor, width: 1.6),
        ),
        // ikon di kanan dalam capsule kecil
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            width: 38,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: const Color(0xFFEDEDED),
            ),
            child: const Icon(
              Icons.search_rounded,
              size: 22,
              color: Colors.black87,
            ),
          ),
        ),
        suffixIconConstraints: const BoxConstraints(
          minWidth: 0,
          minHeight: 0,
        ), // rapat ke kanan
      ),
    );
  }
}

/// Kartu transaksi menyerupai yang di screenshot
class _TransactionCard extends StatelessWidget {
  final String id;
  final String name;
  final String dateTimePrice;
  final String statusText;
  final Color statusColor;
  final Color softTextColor;
  final IconData trailingIcon;
  final Color primary;

  const _TransactionCard({
    required this.id,
    required this.name,
    required this.dateTimePrice,
    required this.statusText,
    required this.statusColor,
    required this.softTextColor,
    required this.trailingIcon,
    required this.primary,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 12, 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // konten kiri
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // badge status di kiri atas
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      statusText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  // invoice id
                  Text(
                    id,
                    style: TextStyle(
                      color: softTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // nama paket
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  // tanggal + harga
                  Text(
                    dateTimePrice,
                    style: TextStyle(
                      color: softTextColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // tombol bulat hijau di kanan
            CircleAvatar(
              radius: 18,
              backgroundColor: primary,
              child: Icon(trailingIcon, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
