import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final int starCount;
  final double rating;
  final Color color;
  final double size;

  const StarRating(
      {super.key,
      required this.starCount,
      required this.rating,
      required this.color,
      required this.size});

  Widget buildStar(BuildContext context, int index) {
    Icon icon;

    if (index >= rating) {
      icon = Icon(
        Icons.star_border,
        color: Theme.of(context).colorScheme.primary,
        size: size,
      );
    } else if (index > rating - 1 && index < rating) {
      icon = Icon(
        Icons.star_half,
        color: color,
        size: size,
      );
    } else {
      icon = Icon(
        Icons.star,
        color: color,
        size: size,
      );
    }
    return icon;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(starCount, (index) => buildStar(context, index)),
    );
  }
}
