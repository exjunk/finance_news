// lib/presentation/widgets/stock_chip.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';

class StockChip extends StatelessWidget {
  final String symbol;
  final double? changePercent;

  const StockChip({super.key, required this.symbol, this.changePercent});

  @override
  Widget build(BuildContext context) {
    final isPositive = (changePercent ?? 0) >= 0;
    final color = changePercent == null
        ? AppColors.textSecondaryDark
        : isPositive
            ? AppColors.bull
            : AppColors.bear;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3), width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            symbol,
            style: GoogleFonts.jetBrainsMono(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          if (changePercent != null) ...[
            const SizedBox(width: 4),
            Text(
              '${isPositive ? '+' : ''}${changePercent!.toStringAsFixed(1)}%',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
