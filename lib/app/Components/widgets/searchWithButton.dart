import 'package:flutter/material.dart';

class SearchRowButton extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;
  final String hintText;

  const SearchRowButton({
    super.key,
    required this.controller,
    required this.onSearch,
    this.hintText = 'apa yang Anda cari',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, child) {
              return TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: const TextStyle(fontSize: 15, color: Colors.grey),
                  suffixIcon:
                      value.text.isEmpty
                          ? const Icon(Icons.search, color: Colors.black87)
                          : GestureDetector(
                            onTap: () {
                              controller.clear(); // reset textfield
                              onSearch(); // langsung panggil search/update data
                            },
                            child: const Icon(
                              Icons.close,
                              color: Colors.black87,
                            ),
                          ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.teal),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Colors.teal, width: 2),
                  ),
                ),
                onSubmitted: (_) => onSearch(),
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: onSearch,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          ),
          child: const Text(
            'Cari',
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
        ),
      ],
    );
  }
}
