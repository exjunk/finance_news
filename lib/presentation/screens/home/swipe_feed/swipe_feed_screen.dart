// lib/presentation/screens/home/swipe_feed/swipe_feed_screen.dart
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:in_app_review/in_app_review.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../domain/entities/article.dart';
import '../../../../injection_container.dart';
import '../../../providers/news_provider.dart';
import '../../../providers/preferences_provider.dart';
import '../../../widgets/market_ticker_bar.dart';
import '../../../widgets/shimmer_card.dart';
import '../../../widgets/error_view.dart';
import 'news_card.dart';

class SwipeFeedScreen extends ConsumerStatefulWidget {
  const SwipeFeedScreen({super.key});

  @override
  ConsumerState<SwipeFeedScreen> createState() => _SwipeFeedScreenState();
}

class _SwipeFeedScreenState extends ConsumerState<SwipeFeedScreen> {
  final _swiperController = AppinioSwiperController();
  final bool _isOffline = false;
  List<Article> _articles = [];
  int _currentIndex = 0;

  double _dragDx = 0;
  double _dragDy = 0;

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  void _onSwipe(int previousIndex, int targetIndex, SwiperActivity activity) async {
    final direction = activity.direction;
    if (previousIndex >= _articles.length) return;
    final article = _articles[previousIndex];
    final newsRepo = ref.read(newsRepositoryProvider);
    final prefsNotifier = ref.read(preferencesProvider.notifier);

    switch (direction) {
      case AxisDirection.right:
        HapticFeedback.mediumImpact();
        await newsRepo.saveArticle(article.id);
        _showSavedSnackBar();
        break;
      case AxisDirection.left:
        HapticFeedback.lightImpact();
        await newsRepo.dismissArticle(article.id);
        _showUndoSnackBar(article);
        break;
      case AxisDirection.up:
        HapticFeedback.selectionClick();
        await newsRepo.markAsRead(article.id);
        if (mounted) context.push('/article', extra: article);
        break;
      default:
        break;
    }

    // Track cards swiped and potentially prompt for review
    await prefsNotifier.incrementCardsSwiped();
    final prefs = ref.read(preferencesProvider).value;
    if (prefs != null &&
        prefs.cardsSwiped == AppConstants.appRatingCardThreshold) {
      _requestAppReview();
    }

    setState(() => _currentIndex = targetIndex);
  }

  void _showSavedSnackBar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(children: [
          Icon(Icons.bookmark, color: AppColors.bull, size: 16),
          SizedBox(width: 8),
          Text('Saved to watchlist'),
        ]),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showUndoSnackBar(Article article) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Article dismissed'),
        duration:
            const Duration(seconds: AppConstants.undoDismissSeconds),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () async {
            // Restore article by marking as not dismissed (save then unsave workaround)
            // In a real app you'd have a restoreArticle method
          },
        ),
      ),
    );
  }

  Future<void> _requestAppReview() async {
    try {
      final inAppReview = InAppReview.instance;
      if (await inAppReview.isAvailable()) {
        await inAppReview.requestReview();
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    final category = ref.watch(selectedCategoryProvider);
    final feedAsync = ref.watch(newsFeedProvider(category));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Live market ticker
            const MarketTickerBar(),

            // Offline banner
            if (_isOffline) const OfflineBanner(),

            // Category filter chips
            _buildFilterChips(),

            // Swipe deck
            Expanded(
              child: feedAsync.when(
                loading: () => _buildLoadingCards(),
                error: (e, _) => ErrorView(
                  message: e.toString(),
                  onRetry: () => ref.invalidate(newsFeedProvider(category)),
                ),
                data: (articles) {
                  _articles = articles.where((a) => !a.isDismissed).toList();
                  if (_articles.isEmpty) return _buildEmptyState();
                  return _buildSwipeDeck(_articles);
                },
              ),
            ),

            // Action buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final selected = ref.watch(selectedCategoryProvider);
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        itemCount: AppConstants.filterCategories.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final cat = AppConstants.filterCategories[i];
          final isSelected = cat == selected;
          return FilterChip(
            label: Text(cat),
            selected: isSelected,
            onSelected: (_) {
              ref.read(selectedCategoryProvider.notifier).state = cat;
            },
            selectedColor: AppColors.primary.withOpacity(0.2),
            checkmarkColor: AppColors.primary,
            labelStyle: TextStyle(
              color: isSelected
                  ? AppColors.primary
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              fontWeight:
                  isSelected ? FontWeight.w700 : FontWeight.w500,
              fontSize: 12,
            ),
          );
        },
      ),
    );
  }

  Widget _buildLoadingCards() {
    return Stack(
      alignment: Alignment.center,
      children: [
        _scaledCard(
          index: 2,
          child: const ShimmerCard(),
        ),
        _scaledCard(
          index: 1,
          child: const ShimmerCard(),
        ),
        _scaledCard(
          index: 0,
          child: const ShimmerCard(),
        ),
      ],
    );
  }

  Widget _scaledCard({required int index, required Widget child}) {
    final scales = [1.0, 0.95, 0.90];
    final offsets = [0.0, -8.0, -16.0];
    final opacities = [1.0, 0.8, 0.5];
    final size = MediaQuery.of(context).size;
    return Transform.translate(
      offset: Offset(0, offsets[index]),
      child: Transform.scale(
        scale: scales[index],
        child: Opacity(
          opacity: opacities[index],
          child: SizedBox(
            width: size.width * AppConstants.cardWidthFactor,
            height: size.height * AppConstants.cardHeightFactor,
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeDeck(List<Article> articles) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _dragDx = details.delta.dx;
          _dragDy = details.delta.dy;
        });
      },
      onPanEnd: (_) => setState(() {
        _dragDx = 0;
        _dragDy = 0;
      }),
      child: AppinioSwiper(
        controller: _swiperController,
        swipeOptions: const SwipeOptions.all(),
        onSwipeEnd: _onSwipe,
        onEnd: () => setState(() {}),
        cardCount: articles.length,
        cardBuilder: (context, index) {
          return NewsCard(
            article: articles[index],
            swipeDx: index == _currentIndex ? _dragDx * 5 : 0,
            swipeDy: index == _currentIndex ? _dragDy * 5 : 0,
          );
        },
        backgroundCardOffset: const Offset(0, 8),
        backgroundCardScale: 0.05,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.celebration, size: 72, color: AppColors.primary),
          const SizedBox(height: 16),
          Text(
            "You're all caught up!",
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            'Pull to refresh for more stories',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              final cat = ref.read(selectedCategoryProvider);
              ref.invalidate(newsFeedProvider(cat));
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Refresh'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.backgroundDark,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _ActionButton(
            icon: Icons.close,
            color: AppColors.bear,
            onTap: () {
              HapticFeedback.lightImpact();
              _swiperController.swipeLeft();
            },
            tooltip: 'Skip',
          ),
          _ActionButton(
            icon: Icons.arrow_upward,
            color: AppColors.readOverlay,
            size: 42,
            onTap: () {
              HapticFeedback.selectionClick();
              _swiperController.swipeUp();
            },
            tooltip: 'Read',
          ),
          _ActionButton(
            icon: Icons.bookmark,
            color: AppColors.bull,
            onTap: () {
              HapticFeedback.mediumImpact();
              _swiperController.swipeRight();
            },
            tooltip: 'Save',
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final String tooltip;
  final double size;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.onTap,
    required this.tooltip,
    this.size = 36,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          width: size * 1.6,
          height: size * 1.6,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            shape: BoxShape.circle,
            border: Border.all(color: color.withOpacity(0.4), width: 1.5),
          ),
          child: Icon(icon, color: color, size: size * 0.75),
        ),
      ),
    );
  }
}
