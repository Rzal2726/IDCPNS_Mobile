import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:showcaseview/showcaseview.dart';

import '../controllers/pretest_tour_controller.dart';

class PretestTourView extends StatefulWidget {
  const PretestTourView({super.key});
  @override
  State<PretestTourView> createState() => _PretestTourViewState();
}

class _PretestTourViewState extends State<PretestTourView> {
  final PretestTourController controller = Get.find<PretestTourController>();

  @override
  void initState() {
    super.initState();
    // start showcase once after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.startShowcase(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    // IMPORTANT: pass a WidgetBuilder (function), not a Builder widget
    return ShowCaseWidget(
      builder:
          (context) => Scaffold(
            backgroundColor: const Color(0xfff3f6f5),
            appBar: AppBar(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 0,
              leading: const BackButton(),
              title: const Text("Pretest - Showcase Review"),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  // Expanded content (scrollable)
                  Expanded(
                    child: Obx(() {
                      final soal =
                          controller.soalList[controller.currentIndex.value];

                      return SingleChildScrollView(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // 1) Tandai soal (bookmark) & 2) Laporkan soal (report)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Showcase(
                                  key: controller.kBookmark,
                                  description:
                                      'Tandai soal agar bisa di-review kembali.',
                                  child: IconButton(
                                    onPressed:
                                        () => controller.toggleBookmark(
                                          soal.nomor,
                                        ),
                                    icon: Obx(
                                      () => Icon(
                                        controller.bookmarked.contains(
                                              soal.nomor,
                                            )
                                            ? Icons.bookmark
                                            : Icons.bookmark_border,
                                      ),
                                    ),
                                    tooltip: 'Tandai soal',
                                  ),
                                ),
                                Showcase(
                                  key: controller.kFlag,
                                  description:
                                      'Laporkan soal jika ada kesalahan atau masalah.',
                                  child: IconButton(
                                    onPressed:
                                        () => controller.report(soal.nomor),
                                    icon: const Icon(Icons.report),
                                    tooltip: 'Laporkan soal',
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 8),

                            // 3) Field tempat soal (judul + isi)
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Showcase(
                                  key: controller.kSoalField,
                                  description:
                                      'Area soal: judul dan pertanyaan. Baca sebelum memilih jawaban.',
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        soal.judul,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        soal.pertanyaan,
                                        style: const TextStyle(height: 1.4),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 14),

                            // 4) Opsi pilihan ganda
                            Showcase(
                              key: controller.kOptions,
                              description:
                                  'Pilih jawaban yang paling tepat dari opsi berikut.',
                              child: Column(
                                children: List.generate(soal.opsi.length, (i) {
                                  final currentAnswer =
                                      controller.answers[soal.nomor];
                                  final isSelected =
                                      currentAnswer != null &&
                                      currentAnswer == i;
                                  return Obx(() {
                                    return Container(
                                      margin: const EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color:
                                              isSelected
                                                  ? const Color(0xff0da686)
                                                  : Colors.grey.shade300,
                                        ),
                                      ),
                                      child: RadioListTile<int>(
                                        dense: true,
                                        value: i,
                                        groupValue:
                                            controller.answers[soal.nomor],
                                        onChanged: (val) {
                                          controller.selectAnswer(
                                            soal.nomor,
                                            i,
                                          );
                                        },
                                        title: Text(
                                          soal.opsi[i],
                                          style: const TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    );
                                  });
                                }),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // 5) Tombol Selesai (full width) -> gunakan key kFinish
                            Showcase(
                              key: controller.kFinish,
                              description:
                                  'Tekan untuk menyelesaikan dan menyimpan jawaban.',
                              child: ElevatedButton(
                                onPressed: controller.finish,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xff0da686),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 14,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  "Selesai",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),

                            // 6) Pagination: nomor soal (wrap) with chevrons -> showcase
                            Showcase(
                              key: controller.kPagination,
                              description:
                                  'Pilih nomor soal atau gunakan chevron untuk navigasi.',
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 1,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  child: Row(
                                    children: [
                                      IconButton(
                                        visualDensity: VisualDensity.compact,
                                        padding: EdgeInsets.zero,
                                        onPressed: controller.goPrev,
                                        icon: const Icon(Icons.chevron_left),
                                        color: Colors.grey.shade700,
                                      ),
                                      Expanded(
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: List.generate(controller.soalList.length, (
                                              i,
                                            ) {
                                              final isActive =
                                                  controller
                                                      .currentIndex
                                                      .value ==
                                                  i;
                                              final isAnswered =
                                                  controller.answers[controller
                                                      .soalList[i]
                                                      .nomor] !=
                                                  null;
                                              return GestureDetector(
                                                onTap:
                                                    () => controller.jumpTo(i),
                                                child: Container(
                                                  margin:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 6,
                                                      ),
                                                  width: 36,
                                                  height: 36,
                                                  alignment: Alignment.center,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border.all(
                                                      color:
                                                          isActive
                                                              ? const Color(
                                                                0xff0da686,
                                                              )
                                                              : Colors
                                                                  .grey
                                                                  .shade300,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          6,
                                                        ),
                                                    boxShadow:
                                                        isActive
                                                            ? const [
                                                              BoxShadow(
                                                                color:
                                                                    Colors
                                                                        .black12,
                                                                blurRadius: 2,
                                                                offset: Offset(
                                                                  0,
                                                                  1,
                                                                ),
                                                              ),
                                                            ]
                                                            : null,
                                                  ),
                                                  child: Stack(
                                                    alignment: Alignment.center,
                                                    children: [
                                                      Text(
                                                        "${controller.soalList[i].nomor}",
                                                        style: TextStyle(
                                                          color:
                                                              isActive
                                                                  ? const Color(
                                                                    0xff0da686,
                                                                  )
                                                                  : Colors
                                                                      .black87,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      if (isAnswered)
                                                        const Positioned(
                                                          right: 4,
                                                          top: 4,
                                                          child: SizedBox(
                                                            width: 8,
                                                            height: 8,
                                                            child: DecoratedBox(
                                                              decoration:
                                                                  BoxDecoration(
                                                                    color:
                                                                        Colors
                                                                            .green,
                                                                    shape:
                                                                        BoxShape
                                                                            .circle,
                                                                  ),
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            }),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        visualDensity: VisualDensity.compact,
                                        padding: EdgeInsets.zero,
                                        onPressed: controller.goNext,
                                        icon: const Icon(Icons.chevron_right),
                                        color: Colors.grey.shade700,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 12),
                          ],
                        ),
                      );
                    }),
                  ),

                  // 7) Bottom fixed navigation: tombol sebelumnya -> durasi -> tombol next
                  Obx(() {
                    final disablePrev = controller.currentIndex.value == 0;
                    final disableNext =
                        controller.currentIndex.value ==
                        controller.soalList.length - 1;
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          top: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Row(
                        children: [
                          // Sebelumnya
                          Showcase(
                            key: controller.kPrev,
                            description: 'Kembali ke soal sebelumnya.',
                            child: ElevatedButton(
                              onPressed: disablePrev ? null : controller.goPrev,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    disablePrev
                                        ? Colors.grey.shade200
                                        : Colors.white,
                                foregroundColor:
                                    disablePrev ? Colors.grey : Colors.black,
                                side: BorderSide(color: Colors.grey.shade300),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 12,
                                ),
                                elevation: 0,
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.chevron_left, size: 18),
                                  SizedBox(width: 4),
                                  Text("Sebelumnya"),
                                ],
                              ),
                            ),
                          ),

                          const Spacer(),

                          // Durasi / timer
                          Showcase(
                            key: controller.kTimer,
                            description: 'Sisa waktu pengerjaan pretest.',
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              child: Obx(() {
                                return Text(
                                  controller.formatTime(
                                    controller.remainingSeconds.value,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                );
                              }),
                            ),
                          ),

                          const Spacer(),

                          // Selanjutnya
                          Showcase(
                            key: controller.kNext,
                            description: 'Maju ke soal selanjutnya.',
                            child: ElevatedButton(
                              onPressed: disableNext ? null : controller.goNext,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    disableNext
                                        ? Colors.grey.shade400
                                        : const Color(0xff0da686),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                              ),
                              child: Row(
                                children: const [
                                  Text("Selanjutnya"),
                                  SizedBox(width: 6),
                                  Icon(Icons.chevron_right),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
    );
  }
}
