import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonLoading extends StatelessWidget {
  final double height;
  final double width;
  final double radius;
  final EdgeInsets margin;

  const SkeletonLoading(
      {super.key,
      required this.height,
      required this.width,
      required this.radius,
      required this.margin});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: Colors.grey.shade300,
      child: Container(
        width: width,
        height: height,
        margin: margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: Colors.grey.shade400,
        ),
      ),
    );
  }
}
