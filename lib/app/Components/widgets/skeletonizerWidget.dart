import 'package:flutter/material.dart';
import 'package:idcpns_mobile/app/Components/widgets/emptyDataWidget.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonListWidget<T> extends StatefulWidget {
  final Iterable<T> data; // fleksibel: bisa List atau RxList
  final Widget Function(T item) itemBuilder;
  final String emptyMessage;
  final String? emptySvgAsset;
  final int skeletonCount;
  final Duration skeletonDuration;
  final Axis scrollDirection;
  final bool shrinkWrap;
  final ScrollPhysics physics;

  const SkeletonListWidget({
    Key? key,
    required this.data,
    required this.itemBuilder,
    this.emptyMessage = "Data tidak tersedia",
    this.emptySvgAsset,
    this.skeletonCount = 3,
    this.skeletonDuration = const Duration(seconds: 5),
    this.scrollDirection = Axis.vertical,
    this.shrinkWrap = true,
    this.physics = const NeverScrollableScrollPhysics(),
  }) : super(key: key);

  @override
  _SkeletonListWidgetState<T> createState() => _SkeletonListWidgetState<T>();
}

class _SkeletonListWidgetState<T> extends State<SkeletonListWidget<T>> {
  bool showSkeleton = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(widget.skeletonDuration, () {
      if (mounted) {
        setState(() {
          showSkeleton = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.data.toList(); // fleksibel: RxList / List

    if (items.isNotEmpty) {
      // tampilkan data
      return ListView.builder(
        shrinkWrap: widget.shrinkWrap,
        physics: widget.physics,
        scrollDirection: widget.scrollDirection,
        itemCount: items.length,
        itemBuilder: (context, index) {
          return widget.itemBuilder(items[index]);
        },
      );
    } else {
      // Skeleton atau EmptyStateWidget
      return showSkeleton
          ? Skeletonizer(
            child: ListView.builder(
              shrinkWrap: widget.shrinkWrap,
              physics: widget.physics,
              scrollDirection: widget.scrollDirection,
              itemCount: widget.skeletonCount,
              itemBuilder:
                  (context, index) => Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade300,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 20,
                          width: 80,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 7),
                        Container(
                          height: 16,
                          width: 120,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 7),
                        Container(
                          height: 14,
                          width: 160,
                          color: Colors.grey.shade300,
                        ),
                      ],
                    ),
                  ),
            ),
          )
          : EmptyStateWidget(message: widget.emptyMessage);
    }
  }
}
