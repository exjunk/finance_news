// lib/presentation/providers/news_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/article.dart';
import '../../injection_container.dart';

// ── Selected filter category ───────────────────────────────────────

final selectedCategoryProvider = StateProvider<String>((ref) => 'All');

// ── News feed ─────────────────────────────────────────────────────

final newsFeedProvider = FutureProvider.autoDispose
    .family<List<Article>, String>((ref, category) async {
  final useCase = ref.watch(getNewsFeedProvider);
  return useCase.call(category: category == 'All' ? null : category);
});

// ── Current feed (based on selected category) ─────────────────────

final currentNewsFeedProvider =
    FutureProvider.autoDispose<List<Article>>((ref) async {
  final category = ref.watch(selectedCategoryProvider);
  return ref.watch(newsFeedProvider(category).future);
});

// ── Swipe deck state (remaining cards in current session) ─────────

class SwipeDeckNotifier extends StateNotifier<List<Article>> {
  SwipeDeckNotifier() : super([]);

  void setArticles(List<Article> articles) => state = articles;

  void removeTop() {
    if (state.isNotEmpty) state = state.sublist(1);
  }

  void prepend(Article article) => state = [article, ...state];

  bool get isEmpty => state.isEmpty;
}

final swipeDeckProvider =
    StateNotifierProvider<SwipeDeckNotifier, List<Article>>(
        (_) => SwipeDeckNotifier());

// ── Watchlist stream ──────────────────────────────────────────────

final watchlistStreamProvider = StreamProvider.autoDispose<List<Article>>(
  (ref) => ref.watch(getSavedArticlesProvider).watch(),
);

// ── Search ─────────────────────────────────────────────────────────

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchResultsProvider =
    FutureProvider.autoDispose.family<List<Article>, String>(
  (ref, query) async {
    if (query.isEmpty) return [];
    return ref.watch(searchArticlesProvider).call(query);
  },
);
