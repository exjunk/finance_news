// lib/presentation/screens/home/watchlist/watchlist_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../../../domain/entities/article.dart';
import '../../../../injection_container.dart';
import '../../../providers/news_provider.dart';
import '../../../widgets/sentiment_badge.dart';
import '../../../widgets/error_view.dart';
import '../../../widgets/shimmer_card.dart';

class WatchlistScreen extends ConsumerStatefulWidget {
  const WatchlistScreen({super.key});

  @override
  ConsumerState<WatchlistScreen> createState() => _WatchlistScreenState();
}

class _WatchlistScreenState extends ConsumerState<WatchlistScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final watchlistAsync = ref.watch(watchlistStreamProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, watchlistAsync),
            _buildSearchBar(),
            Expanded(
              child: watchlistAsync.when(
                loading: () => _buildSkeleton(),
                error: (e, _) =>
                    ErrorView(message: e.toString()),
                data: (articles) {
                  final filtered = _searchQuery.isEmpty
                      ? articles
                      : articles
                          .where((a) => a.title
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase()))
                          .toList();

                  if (filtered.isEmpty) {
                    return const EmptyStateView(
                      title: 'No Saved Articles',
                      message:
                          'Swipe right on any news card to save it here.',
                      icon: Icons.bookmark_outline,
                    );
                  }
                  return _buildList(filtered);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AsyncValue<List<Article>> async) {
    final count = async.value?.length ?? 0;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          const Icon(Icons.bookmark, color: AppColors.primary, size: 24),
          const SizedBox(width: 10),
          Text(
            count > 0 ? '💾 $count Saved Stories' : 'Saved Stories',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextField(
        onChanged: (v) => setState(() => _searchQuery = v),
        decoration: const InputDecoration(
          hintText: 'Search saved articles...',
          prefixIcon: Icon(Icons.search, size: 20),
        ),
      ),
    );
  }

  Widget _buildSkeleton() {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (_, __) => const ShimmerListTile(),
    );
  }

  Widget _buildList(List<Article> articles) {
    // Group by date
    final Map<String, List<Article>> grouped = {};
    for (final a in articles) {
      final key = TimeFormatter.formatDate(a.publishedAt);
      grouped.putIfAbsent(key, () => []).add(a);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: grouped.length,
      itemBuilder: (context, i) {
        final date = grouped.keys.elementAt(i);
        final group = grouped[date]!;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(date,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700)),
            ),
            ...group.map((a) => _buildArticleTile(context, a)),
          ],
        );
      },
    );
  }

  Widget _buildArticleTile(BuildContext context, Article article) {
    return Dismissible(
      key: ValueKey(article.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.bear,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) async {
        final repo = ref.read(newsRepositoryProvider);
        await repo.unsaveArticle(article.id);
      },
      child: InkWell(
        onTap: () => context.push('/article', extra: article),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    article.source,
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: AppColors.primary),
                  ),
                  const Text(' • ',
                      style: TextStyle(color: AppColors.textSecondaryDark)),
                  Text(
                    TimeFormatter.timeAgo(article.publishedAt),
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const Spacer(),
                  SentimentBadge(
                      sentiment: article.sentiment, compact: true),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                article.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
