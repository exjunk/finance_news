// lib/presentation/widgets/shimmer_card.dart
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/theme/app_colors.dart';

class ShimmerCard extends StatelessWidget {
  const ShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor =
        isDark ? AppColors.shimmerBase : AppColors.shimmerBaseLight;
    final highlightColor =
        isDark ? AppColors.shimmerHighlight : AppColors.shimmerHighlightLight;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category pill
              Container(
                height: 24,
                width: 70,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              const Spacer(),
              // Headline lines
              Container(
                height: 20,
                width: double.infinity,
                color: Colors.white,
              ),
              const SizedBox(height: 8),
              Container(
                height: 20,
                width: MediaQuery.of(context).size.width * 0.7,
                color: Colors.white,
              ),
              const SizedBox(height: 20),
              // Source row
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(height: 12, width: 100, color: Colors.white),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ShimmerListTile extends StatelessWidget {
  const ShimmerListTile({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor =
        isDark ? AppColors.shimmerBase : AppColors.shimmerBaseLight;
    final highlightColor =
        isDark ? AppColors.shimmerHighlight : AppColors.shimmerHighlightLight;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(height: 12, width: 80, color: Colors.white),
            const SizedBox(height: 8),
            Container(height: 16, width: double.infinity, color: Colors.white),
            const SizedBox(height: 4),
            Container(
                height: 16,
                width: MediaQuery.of(context).size.width * 0.6,
                color: Colors.white),
          ],
        ),
      ),
    );
  }
}
