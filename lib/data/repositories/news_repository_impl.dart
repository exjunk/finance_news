// lib/data/repositories/news_repository_impl.dart
import '../../domain/entities/article.dart';
import '../../domain/repositories/news_repository.dart';
import '../../core/errors/exceptions.dart';
import '../../core/utils/connectivity_checker.dart';
import '../datasources/local/local_datasource.dart';
import '../datasources/remote/gnews_datasource.dart';
import '../datasources/remote/newsdata_datasource.dart';
import '../datasources/remote/rss_datasource.dart';
import '../models/article_model.dart';

/// Hardcoded fallback articles for when all APIs fail
final List<ArticleModel> _fallbackArticles = [
  ArticleModel.fromRss(
    title: 'Nifty 50 scales fresh highs as banking stocks surge',
    url: 'https://example.com/nifty-highs',
    description:
        'The benchmark Nifty 50 index climbed to record highs today, driven by strong gains in banking and financial stocks.',
    source: 'ET Markets',
    pubDate: DateTime.now().subtract(const Duration(hours: 2)),
  ),
  ArticleModel.fromRss(
    title: 'RBI holds repo rate steady; signals cautious growth outlook',
    url: 'https://example.com/rbi-rate',
    description:
        'The Reserve Bank of India kept the benchmark repo rate unchanged at 6.5%, citing concerns around inflation.',
    source: 'Business Standard',
    pubDate: DateTime.now().subtract(const Duration(hours: 4)),
  ),
  ArticleModel.fromRss(
    title: 'IPO Watch: New LIC subsidiary targets Rs 5,000 Cr fundraise',
    url: 'https://example.com/ipo-lic',
    description:
        'A wholly-owned subsidiary of LIC is planning a public offering to raise up to Rs 5,000 crore.',
    source: 'Livemint',
    pubDate: DateTime.now().subtract(const Duration(hours: 6)),
  ),
  ArticleModel.fromRss(
    title: 'IT stocks fall as US recession fears weigh on Infosys, TCS',
    url: 'https://example.com/it-fall',
    description:
        'Shares of major Indian IT companies declined sharply on concerns about reduced spending by US clients amid recession fears.',
    source: 'Moneycontrol',
    pubDate: DateTime.now().subtract(const Duration(hours: 8)),
  ),
  ArticleModel.fromRss(
    title: 'Sensex gains 400 pts on strong FII inflows; pharma leads',
    url: 'https://example.com/sensex-gains',
    description:
        'Foreign institutional investors pumped in Rs 3,500 crore into Indian equities today, pushing the Sensex up 400 points.',
    source: 'ET Markets',
    pubDate: DateTime.now().subtract(const Duration(hours: 10)),
  ),
];

class NewsRepositoryImpl implements NewsRepository {
  final GNewsDatasource _gNews;
  final NewsDataDatasource _newsData;
  final RssDatasource _rss;
  final LocalDatasource _local;

  const NewsRepositoryImpl({
    required GNewsDatasource gNews,
    required NewsDataDatasource newsData,
    required RssDatasource rss,
    required LocalDatasource local,
  })  : _gNews = gNews,
        _newsData = newsData,
        _rss = rss,
        _local = local;

  @override
  Future<List<Article>> getNewsFeed({String? category}) async {
    final isOnline = await ConnectivityChecker.isConnected();
    if (!isOnline) {
      return getCachedArticles();
    }

    // Source rotation: GNews → NewsData → RSS → cached → fallback
    List<Article> articles = [];

    try {
      final results = await _gNews.fetchNews();
      articles.addAll(results);
    } on ApiRateLimitException catch (_) {
      // GNews rate limited, move on
    } catch (_) {}

    if (articles.length < 5) {
      try {
        final results = await _newsData.fetchNews();
        articles.addAll(results);
      } on ApiRateLimitException catch (_) {
      } catch (_) {}
    }

    if (articles.length < 5) {
      try {
        final rssResults = await _rss.fetchAllFeeds();
        articles.addAll(rssResults);
      } catch (_) {}
    }

    // Deduplicate
    final seen = <String>{};
    articles = articles.where((a) => seen.add(a.id)).toList();
    articles.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));

    if (articles.isEmpty) {
      // Try cache
      final cached = await _local.getCachedArticles();
      if (cached.isNotEmpty) return cached;
      // Fall back to hardcoded articles
      return _fallbackArticles;
    }

    // Cache the fetched articles
    await _local.cacheArticles(articles);

    // Filter by category if requested
    if (category != null && category != 'All') {
      return articles
          .where((a) => a.category.toLowerCase() == category.toLowerCase())
          .toList();
    }
    return articles;
  }

  @override
  Future<List<Article>> getCachedArticles() async {
    final cached = await _local.getCachedArticles();
    if (cached.isNotEmpty) return cached;
    return _fallbackArticles;
  }

  @override
  Future<List<Article>> getSavedArticles() =>
      _local.getCachedSavedArticles();

  @override
  Stream<List<Article>> watchSavedArticles() =>
      _local.watchSavedArticles();

  @override
  Future<void> saveArticle(String articleId) =>
      _local.markArticleSaved(articleId, saved: true);

  @override
  Future<void> unsaveArticle(String articleId) =>
      _local.markArticleSaved(articleId, saved: false);

  @override
  Future<void> dismissArticle(String articleId) =>
      _local.markArticleDismissed(articleId);

  @override
  Future<void> markAsRead(String articleId) =>
      _local.markArticleRead(articleId);

  @override
  Future<List<Article>> searchArticles(String query) =>
      _local.searchCachedArticles(query);

  @override
  Future<void> clearCache() => _local.clearAllArticles();
}
