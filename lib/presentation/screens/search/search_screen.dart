// lib/presentation/screens/search/search_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/time_formatter.dart';
import '../../../domain/entities/article.dart';
import '../../providers/news_provider.dart';
import '../../widgets/sentiment_badge.dart';
import '../../widgets/shimmer_card.dart';
import '../../widgets/error_view.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  String _query = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final resultsAsync = ref.watch(searchResultsProvider(_query));

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      focusNode: _focusNode,
                      onChanged: (v) => setState(() => _query = v),
                      decoration: const InputDecoration(
                        hintText: 'Search articles, companies, tickers...',
                        prefixIcon: Icon(Icons.search),
                      ),
                      textInputAction: TextInputAction.search,
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('Cancel'),
                  ),
                ],
              ),
            ),

            // Filter chips
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: ['IPO', 'Nifty', 'Results', 'RBI', 'FII']
                      .map((tag) => Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ActionChip(
                              label: Text(tag),
                              onPressed: () {
                                _searchController.text = tag;
                                setState(() => _query = tag);
                              },
                            ),
                          ))
                      .toList(),
                ),
              ),
            ),

            // Results
            Expanded(
              child: _query.isEmpty
                  ? const EmptyStateView(
                      title: 'Search News',
                      message:
                          'Type to search Indian market news, company names, or stock tickers.',
                      icon: Icons.search,
                    )
                  : resultsAsync.when(
                      loading: () => ListView.builder(
                        itemCount: 5,
                        itemBuilder: (_, __) => const ShimmerListTile(),
                      ),
                      error: (e, _) => ErrorView(message: e.toString()),
                      data: (articles) {
                        if (articles.isEmpty) {
                          return EmptyStateView(
                            title: 'No Results',
                            message:
                                'No articles found for "$_query"',
                            icon: Icons.search_off,
                          );
                        }
                        return ListView.builder(
                          itemCount: articles.length,
                          itemBuilder: (_, i) =>
                              _buildResultTile(context, articles[i]),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultTile(BuildContext context, Article article) {
    return InkWell(
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
                Text(article.source,
                    style: Theme.of(context)
                        .textTheme
                        .labelSmall
                        ?.copyWith(color: AppColors.primary)),
                const Text(' • ',
                    style:
                        TextStyle(color: AppColors.textSecondaryDark)),
                Text(TimeFormatter.timeAgo(article.publishedAt),
                    style: Theme.of(context).textTheme.labelSmall),
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
    );
  }
}
