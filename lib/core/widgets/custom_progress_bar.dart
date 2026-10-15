import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

// Günlük tamamlama oranını ve istatistik yüzdelerini gösteren custom progress bar bileşeni.
class CustomProgressBar extends StatelessWidget {
  final double progress;
  final double height;

  const CustomProgressBar({
    super.key,
    required this.progress,
    this.height = 10,
  });

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);

    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: clampedProgress,
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(height / 2),
          ),
        ),
      ),
    );
  }
}
