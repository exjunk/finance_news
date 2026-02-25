// lib/data/datasources/local/local_datasource.dart
import 'dart:convert';
import 'package:drift/drift.dart';
import '../../../domain/entities/article.dart';
import '../../../domain/entities/stock_quote.dart';
import '../../../core/utils/sentiment_analyzer.dart';
import '../../models/article_model.dart';
import '../../models/stock_model.dart';
import 'database.dart' as db;

class LocalDatasource {
  final db.AppDatabase _database;

  const LocalDatasource(this._database);

  // ── Articles ──────────────────────────────────────────────────────

  Future<void> cacheArticles(List<Article> articles) async {
    final companions = articles
        .map(
          (a) => db.ArticlesCompanion(
            articleId: Value(a.id),
            title: Value(a.title),
            description: Value(a.description),
            url: Value(a.url),
            imageUrl: Value(a.imageUrl),
            source: Value(a.source),
            category: Value(a.category),
            sentiment: Value(a.sentiment.name),
            relatedTickers: Value(jsonEncode(a.relatedTickers)),
            publishedAt:
                Value(a.publishedAt.millisecondsSinceEpoch ~/ 1000),
            fetchedAt:
                Value(a.fetchedAt.millisecondsSinceEpoch ~/ 1000),
            isRead: Value(a.isRead),
            isSaved: Value(a.isSaved),
            isDismissed: Value(a.isDismissed),
          ),
        )
        .toList();
    await _database.articlesDao.upsertArticles(companions);
  }

  Future<List<Article>> getCachedArticles() async {
    final rows = await _database.articlesDao.getAllArticles();
    return rows.map(_rowToArticle).toList();
  }

  Stream<List<Article>> watchCachedArticles() {
    return _database.articlesDao
        .watchAllArticles()
        .map((rows) => rows.map(_rowToArticle).toList());
  }

  Future<List<Article>> getCachedSavedArticles() async {
    final rows = await _database.articlesDao.getSavedArticles();
    return rows.map(_rowToArticle).toList();
  }

  Stream<List<Article>> watchSavedArticles() {
    return _database.articlesDao
        .watchSavedArticles()
        .map((rows) => rows.map(_rowToArticle).toList());
  }

  Future<void> markArticleRead(String articleId) =>
      _database.articlesDao.markAsRead(articleId);

  Future<void> markArticleSaved(String articleId, {required bool saved}) =>
      _database.articlesDao.markAsSaved(articleId, saved: saved);

  Future<void> markArticleDismissed(String articleId) =>
      _database.articlesDao.markAsDismissed(articleId);

  Future<void> deleteArticle(String articleId) =>
      _database.articlesDao.deleteArticle(articleId);

  Future<void> clearAllArticles() =>
      _database.articlesDao.clearAllArticles();

  Future<List<Article>> searchCachedArticles(String query) async {
    final rows = await _database.articlesDao.searchArticles(query);
    return rows.map(_rowToArticle).toList();
  }

  // ── Market snapshots ──────────────────────────────────────────────

  Future<void> cacheStockQuotes(List<StockQuote> quotes) async {
    final companions = quotes
        .map(
          (q) => db.MarketSnapshotsCompanion(
            symbol: Value(q.symbol),
            name: Value(q.name),
            price: Value(q.price),
            change: Value(q.change),
            changePercent: Value(q.changePercent),
            snapshotAt:
                Value(q.updatedAt.millisecondsSinceEpoch ~/ 1000),
          ),
        )
        .toList();
    await _database.marketDao.upsertSnapshots(companions);
  }

  Future<List<StockQuote>> getCachedSnapshots() async {
    final rows = await _database.marketDao.getAllSnapshots();
    return rows.map(_rowToStockQuote).toList();
  }

  // ── Read history ──────────────────────────────────────────────────

  Future<void> addToReadHistory(String articleId) =>
      _database.articlesDao.addToReadHistory(articleId);

  Future<bool> isRead(String articleId) =>
      _database.articlesDao.isInReadHistory(articleId);

  Future<void> clearReadHistory() =>
      _database.articlesDao.clearReadHistory();

  // ── Helpers ───────────────────────────────────────────────────────

  Article _rowToArticle(db.Article row) {
    List<String> tickers = [];
    if (row.relatedTickers != null && row.relatedTickers!.isNotEmpty) {
      try {
        tickers =
            (jsonDecode(row.relatedTickers!) as List).cast<String>();
      } catch (_) {}
    }
    return ArticleModel(
      id: row.articleId,
      title: row.title,
      description: row.description,
      url: row.url,
      imageUrl: row.imageUrl,
      source: row.source,
      category: row.category,
      sentiment: _parseSentiment(row.sentiment),
      relatedTickers: tickers,
      publishedAt:
          DateTime.fromMillisecondsSinceEpoch(row.publishedAt * 1000),
      fetchedAt:
          DateTime.fromMillisecondsSinceEpoch(row.fetchedAt * 1000),
      isRead: row.isRead,
      isSaved: row.isSaved,
      isDismissed: row.isDismissed,
    );
  }

  StockQuote _rowToStockQuote(db.MarketSnapshot row) {
    return StockModel(
      symbol: row.symbol,
      name: row.name,
      price: row.price,
      change: row.change,
      changePercent: row.changePercent,
      updatedAt: DateTime.fromMillisecondsSinceEpoch(row.snapshotAt * 1000),
    );
  }

  Sentiment _parseSentiment(String s) {
    switch (s) {
      case 'bull':
        return Sentiment.bull;
      case 'bear':
        return Sentiment.bear;
      default:
        return Sentiment.neutral;
    }
  }
}
