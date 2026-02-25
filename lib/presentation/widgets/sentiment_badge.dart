// lib/presentation/widgets/sentiment_badge.dart
import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/sentiment_analyzer.dart';

class SentimentBadge extends StatelessWidget {
  final Sentiment sentiment;
  final bool compact;

  const SentimentBadge({
    super.key,
    required this.sentiment,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final (color, label, emoji) = _data();

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 3 : 5,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: TextStyle(fontSize: compact ? 10 : 12)),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: compact ? 10 : 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  (Color, String, String) _data() {
    switch (sentiment) {
      case Sentiment.bull:
        return (AppColors.bull, 'BULLISH', '🟢');
      case Sentiment.bear:
        return (AppColors.bear, 'BEARISH', '🔴');
      case Sentiment.neutral:
        return (AppColors.neutral, 'NEUTRAL', '🟡');
    }
  }
}
