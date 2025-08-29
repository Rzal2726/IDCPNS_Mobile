import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/pretest_controller.dart';

class PretestView extends GetView<PretestController> {
  const PretestView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff3f6f5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        leading: BackButton(),
        title: Text("Pretest"),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: ElevatedButton(
              onPressed: controller.finish,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff0da686),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              ),
              child: Text("Selesai"),
            ),
          ),
        ],
      ),

      // layout: content (scroll) + bottom fixed navigation
      body: SafeArea(
        child: Column(
          children: [
            // Expanded content (scrollable)
            Expanded(
              child: Obx(() {
                final soal = controller.soalList[controller.currentIndex.value];

                return SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  child: Column(
                    children: [
                      // Nomor Soal card with chevrons + small boxes
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 1,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 12,
                          ),
                          child: Row(
                            children: [
                              Text(
                                "Nomor Soal",
                                style: TextStyle(fontWeight: FontWeight.w600),
                              ),
                              Spacer(),
                              // left chevron
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                                onPressed: controller.goPrev,
                                icon: Icon(Icons.chevron_left),
                                color: Colors.grey.shade700,
                              ),

                              // small numbered boxes (wrap to show up to 5)
                              Row(
                                children: List.generate(
                                  controller.soalList.length,
                                  (i) {
                                    final isActive =
                                        controller.currentIndex.value == i;
                                    final isAnswered =
                                        controller.answers[controller
                                            .soalList[i]
                                            .nomor] !=
                                        null;
                                    return GestureDetector(
                                      onTap: () => controller.jumpTo(i),
                                      child: Container(
                                        margin: EdgeInsets.symmetric(
                                          horizontal: 6,
                                        ),
                                        width: 34,
                                        height: 34,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color:
                                              isActive
                                                  ? Colors.white
                                                  : Colors.white,
                                          border: Border.all(
                                            color:
                                                isActive
                                                    ? Color(0xff0da686)
                                                    : Colors.grey.shade300,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          boxShadow:
                                              isActive
                                                  ? [
                                                    BoxShadow(
                                                      color: Colors.black12,
                                                      blurRadius: 2,
                                                      offset: Offset(0, 1),
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
                                                        ? Color(0xff0da686)
                                                        : Colors.black87,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            // answered dot at top-right
                                            if (isAnswered)
                                              Positioned(
                                                right: 2,
                                                top: 2,
                                                child: Container(
                                                  width: 8,
                                                  height: 8,
                                                  decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    shape: BoxShape.circle,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              // right chevron
                              IconButton(
                                visualDensity: VisualDensity.compact,
                                padding: EdgeInsets.zero,
                                onPressed: controller.goNext,
                                icon: Icon(Icons.chevron_right),
                                color: Colors.grey.shade700,
                              ),

                              const SizedBox(width: 8),
                              // small icon like list
                              Icon(
                                Icons.format_list_bulleted,
                                color: Colors.grey,
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 14),

                      // Soal card
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // title row: Soal No + bookmark & flag
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          soal.judul,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // bookmark icon
                                  IconButton(
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
                                        color: Colors.amber,
                                      ),
                                    ),
                                  ),
                                  // flag icon
                                  IconButton(
                                    onPressed:
                                        () => controller.toggleFlag(soal.nomor),
                                    icon: Obx(
                                      () => Icon(
                                        Icons.flag,
                                        color:
                                            controller.flagged.contains(
                                                  soal.nomor,
                                                )
                                                ? Colors.redAccent
                                                : Colors.grey,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: 8),
                              Text(
                                soal.pertanyaan,
                                style: TextStyle(height: 1.4),
                              ),
                              SizedBox(height: 16),

                              // options as cards with Radio
                              Column(
                                children: List.generate(soal.opsi.length, (i) {
                                  final currentAnswer =
                                      controller.answers[soal.nomor];
                                  final isSelected =
                                      currentAnswer != null &&
                                      currentAnswer == i;
                                  return Obx(() {
                                    return Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        border: Border.all(
                                          color:
                                              isSelected
                                                  ? Color(0xff0da686)
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
                                          style: TextStyle(fontSize: 14),
                                        ),
                                      ),
                                    );
                                  });
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 24),
                    ],
                  ),
                );
              }),
            ),

            // Bottom fixed navigation (always visible)
            Obx(() {
              final disablePrev = controller.currentIndex.value == 0;
              final disableNext =
                  controller.currentIndex.value ==
                  controller.soalList.length - 1;
              return Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border(top: BorderSide(color: Colors.grey.shade300)),
                ),
                child: Row(
                  children: [
                    // Sebelumnya
                    ElevatedButton(
                      onPressed: disablePrev ? null : controller.goPrev,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            disablePrev ? Colors.grey.shade200 : Colors.white,
                        foregroundColor:
                            disablePrev ? Colors.grey : Colors.black,
                        side: BorderSide(color: Colors.grey.shade300),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                        elevation: 0,
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.chevron_left, size: 18),
                          SizedBox(width: 4),
                          Text("Sebelumnya"),
                        ],
                      ),
                    ),

                    Spacer(),

                    // Timer
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Text(
                        controller.formatTime(
                          controller.remainingSeconds.value,
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    Spacer(),

                    // Selanjutnya
                    ElevatedButton(
                      onPressed: disableNext ? null : controller.goNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            disableNext
                                ? Colors.grey.shade400
                                : Color(0xff0da686),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      child: Row(
                        children: [
                          Text("Selanjutnya"),
                          SizedBox(width: 6),
                          Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}
