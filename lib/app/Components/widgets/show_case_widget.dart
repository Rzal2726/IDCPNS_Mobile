import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class ShowCaseView extends StatelessWidget {
  const ShowCaseView({
    Key? key,
    required this.globalKey,
    required this.description,
    required this.child,
    this.onTargetClick, // tambahkan ini
  }) : super(key: key);

  final GlobalKey globalKey;
  final String description;
  final Widget child;
  final VoidCallback? onTargetClick; // callback opsional

  @override
  Widget build(BuildContext context) {
    return Showcase(
      key: globalKey,
      description: description,
      onTargetClick: onTargetClick, // teruskan callback
      child: child,
    );
  }
}
