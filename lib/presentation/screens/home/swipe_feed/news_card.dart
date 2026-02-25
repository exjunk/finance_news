// lib/presentation/screens/home/swipe_feed/news_card.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../../../domain/entities/article.dart';
import '../../../widgets/sentiment_badge.dart';
import '../../../widgets/stock_chip.dart';

class NewsCard extends StatelessWidget {
  final Article article;
  final double swipeDx;
  final double swipeDy;

  const NewsCard({
    super.key,
    required this.article,
    this.swipeDx = 0,
    this.swipeDy = 0,
  });

  @override
  Widget build(BuildContext context) {
    final sourceColor = AppColors.sourceColor(article.source);
    final size = MediaQuery.of(context).size;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: size.width * 0.88,
        height: size.height * 0.72,
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              blurRadius: 32,
              spreadRadius: -8,
              color: Colors.black54,
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image with gradient overlay
            _buildBackground(sourceColor),

            // Swipe overlays
            if (swipeDx > 20)
              _buildOverlay(Icons.bookmark, 'SAVE',
                  AppColors.saveOverlay, Alignment.centerLeft, swipeDx / 100),
            if (swipeDx < -20)
              _buildOverlay(Icons.close, 'SKIP',
                  AppColors.skipOverlay, Alignment.centerRight, -swipeDx / 100),
            if (swipeDy < -20)
              _buildOverlay(Icons.visibility, 'READ',
                  AppColors.readOverlay, Alignment.topCenter, -swipeDy / 100),

            // Content
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: category pill + sentiment badge
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _CategoryPill(label: article.category, color: sourceColor),
                      SentimentBadge(sentiment: article.sentiment),
                    ],
                  ),

                  const Spacer(),

                  // Stock tickers
                  if (article.relatedTickers.isNotEmpty)
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: article.relatedTickers
                          .take(3)
                          .map((t) => StockChip(symbol: t))
                          .toList(),
                    ),

                  const SizedBox(height: 12),

                  // Headline
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Source row
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: sourceColor,
                        child: Text(
                          article.source.isNotEmpty
                              ? article.source[0].toUpperCase()
                              : 'N',
                          style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${article.source} • ${TimeFormatter.timeAgo(article.publishedAt)}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              color: Colors.white54, size: 12),
                          const SizedBox(width: 3),
                          Text(
                            '~${article.readingTimeMinutes} min',
                            style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 11),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBackground(Color sourceColor) {
    if (article.imageUrl != null && article.imageUrl!.isNotEmpty) {
      return Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: article.imageUrl!,
            fit: BoxFit.cover,
            errorWidget: (_, __, ___) => _colorBackground(sourceColor),
          ),
          // Gradient overlay for legibility
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.45),
                  Colors.black.withOpacity(0.88),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),
        ],
      );
    }
    return _colorBackground(sourceColor);
  }

  Widget _colorBackground(Color color) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.25),
            AppColors.surfaceDark,
            AppColors.backgroundDark,
          ],
        ),
      ),
    );
  }

  Widget _buildOverlay(
      IconData icon, String label, Color color, Alignment alignment, double opacity) {
    return Positioned.fill(
      child: Align(
        alignment: alignment,
        child: Opacity(
          opacity: opacity.clamp(0.0, 1.0),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color, width: 2),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, color: Colors.white, size: 28),
                  const SizedBox(height: 4),
                  Text(label,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 16)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryPill extends StatelessWidget {
  final String label;
  final Color color;

  const _CategoryPill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}
