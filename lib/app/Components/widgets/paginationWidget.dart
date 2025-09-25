import 'package:flutter/material.dart';
import 'package:get/get.dart';

typedef PageChangeCallback = void Function(int page);

class ReusablePagination extends StatelessWidget {
  final RxInt currentPage;
  final RxInt totalPage;
  final PageChangeCallback goToPage;
  final VoidCallback? nextPage;
  final VoidCallback? prevPage;

  const ReusablePagination({
    super.key,
    required this.currentPage,
    required this.totalPage,
    required this.goToPage,
    this.nextPage,
    this.prevPage,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      int current = currentPage.value;
      int total = totalPage.value;

      // kalau totalPage < 2 atau total data < 10 → langsung hide
      if (total <= 1) {
        return const SizedBox.shrink();
      }

      // Generate daftar halaman mirip Pagination A
      List<int> pagesToShow = [];
      if (total <= 3) {
        pagesToShow = List.generate(total, (i) => i + 1);
      } else {
        if (current == 1) {
          pagesToShow = [1, 2, 3];
        } else if (current == total) {
          pagesToShow = [total - 2, total - 1, total];
        } else {
          pagesToShow = [current - 1, current, current + 1];
        }
      }

      return Container(
        height: 40,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: current > 1 ? () => goToPage(1) : null,
                label: const Icon(
                  Icons.first_page,
                  size: 16,
                  color: Colors.teal,
                ),
              ),
              TextButton.icon(
                onPressed: current > 1 ? prevPage : null,
                label: const Icon(
                  Icons.arrow_back_ios,
                  size: 16,
                  color: Colors.teal,
                ),
              ),

              ...pagesToShow.map((page) {
                final isActive = page == current;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  child: GestureDetector(
                    onTap: () => goToPage(page),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: EdgeInsets.symmetric(
                        horizontal: isActive ? 14 : 10,
                        vertical: isActive ? 8 : 6,
                      ),
                      decoration: BoxDecoration(
                        color: isActive ? Colors.teal.shade100 : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isActive ? Colors.teal : Colors.grey.shade300,
                          width: isActive ? 2 : 1,
                        ),
                      ),
                      child: Text(
                        '$page',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isActive ? Colors.teal : Colors.black,
                          fontSize: isActive ? 16 : 14,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),

              TextButton.icon(
                onPressed: current < total ? nextPage : null,
                label: const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.teal,
                ),
              ),
              TextButton.icon(
                onPressed: current < total ? () => goToPage(total) : null,
                label: const Icon(
                  Icons.last_page,
                  size: 16,
                  color: Colors.teal,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
