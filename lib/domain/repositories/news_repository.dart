// lib/domain/repositories/news_repository.dart
import '../entities/article.dart';

abstract class NewsRepository {
  /// Fetch fresh news (with source fallback chain)
  Future<List<Article>> getNewsFeed({String? category});

  /// Get saved (watchlisted) articles
  Future<List<Article>> getSavedArticles();

  /// Watch saved articles as a stream
  Stream<List<Article>> watchSavedArticles();

  /// Save an article to watchlist
  Future<void> saveArticle(String articleId);

  /// Remove from watchlist
  Future<void> unsaveArticle(String articleId);

  /// Dismiss article (never show again this session)
  Future<void> dismissArticle(String articleId);

  /// Search through cached articles
  Future<List<Article>> searchArticles(String query);

  /// Mark as read
  Future<void> markAsRead(String articleId);

  /// Get cached articles (for offline mode)
  Future<List<Article>> getCachedArticles();

  /// Clear all cache
  Future<void> clearCache();
}
