import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final String svgAsset;
  final double svgHeight;
  final double svgWidth;

  const EmptyStateWidget({
    Key? key,
    required this.message,
    this.svgAsset = "assets/learningEmpty.svg",
    this.svgHeight = 150,
    this.svgWidth = 150,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgPicture.asset(svgAsset, height: svgHeight, width: svgWidth),
        SizedBox(height: 20),
        Center(
          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 18),
          ),
        ),
      ],
    );
  }
}
