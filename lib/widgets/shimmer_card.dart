import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../config/theme.dart';

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Shimmer.fromColors(
        baseColor: const Color(0xFFEDE0E0),
        highlightColor: AppColors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 180,
              decoration: const BoxDecoration(
                color: AppColors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(12)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      height: 18, width: 200, color: AppColors.white),
                  const SizedBox(height: 8),
                  Container(
                      height: 12, width: 140, color: AppColors.white),
                  const SizedBox(height: 12),
                  Container(
                      height: 12, width: 100, color: AppColors.white),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
