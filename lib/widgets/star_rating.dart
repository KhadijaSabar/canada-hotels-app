import 'package:flutter/material.dart';
import '../config/theme.dart';

class StarRating extends StatelessWidget {
  final int stars;
  final double size;

  const StarRating({super.key, required this.stars, this.size = 16});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < stars ? Icons.star : Icons.star_border,
          size: size,
          color: index < stars
              ? const Color(0xFFFFBB00)
              : AppColors.divider,
        );
      }),
    );
  }
}
