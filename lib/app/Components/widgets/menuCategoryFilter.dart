import 'package:flutter/material.dart';
import 'package:get/get.dart';

final options = <Map<String, dynamic>>[].obs;

/// Fungsi reusable untuk menampilkan bottom sheet pilihan (ChoiceChip)
void showChoiceBottomSheet<T>({
  required BuildContext context,
  required String title,
  required List<Map<String, dynamic>>
  options, // contoh: [{'id': 1, 'menu': 'A'}]
  required Rx<T?> selectedValue,
  required void Function(T?) onSelected,
  required void Function() onSubmit,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (ctx) {
      return StatefulBuilder(
        builder: (context, setState) {
          return SafeArea(
            child: Padding(
              padding: MediaQuery.of(ctx).viewInsets,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),

                    // List pilihan dengan ChoiceChip
                    Obx(
                      () => Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children:
                            options.map((option) {
                              final id = option['id'] as T;
                              final name =
                                  option['menu'] ?? option['name'] ?? '';
                              final isSelected = selectedValue.value == id;

                              return ChoiceChip(
                                label: Text(
                                  name,
                                  style: TextStyle(
                                    color:
                                        isSelected
                                            ? Colors.teal
                                            : Colors.grey[700],
                                    fontWeight:
                                        isSelected
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                  ),
                                ),
                                selected: isSelected,
                                selectedColor: Colors.teal.withOpacity(0.1),
                                backgroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color:
                                        isSelected
                                            ? Colors.teal
                                            : Colors.grey.shade400,
                                  ),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                onSelected: (value) {
                                  selectedValue.value = id;
                                  onSelected(id);
                                },
                              );
                            }).toList(),
                      ),
                    ),
                    SizedBox(height: 16),

                    // Row tombol Submit & Reset
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                              onSubmit();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                            ),
                            child: Text("Cari"),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    },
  );
}
