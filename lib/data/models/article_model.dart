// lib/data/models/article_model.dart
import 'dart:convert';
import 'package:crypto/crypto.dart';
import '../../core/utils/sentiment_analyzer.dart';
import '../../core/utils/ticker_extractor.dart';
import '../../domain/entities/article.dart';

class ArticleModel extends Article {
  const ArticleModel({
    required super.id,
    required super.title,
    super.description,
    required super.url,
    super.imageUrl,
    required super.source,
    required super.category,
    required super.sentiment,
    super.relatedTickers = const [],
    required super.publishedAt,
    required super.fetchedAt,
    super.isRead = false,
    super.isSaved = false,
    super.isDismissed = false,
  });

  static String _generateId(String url) {
    final bytes = utf8.encode(url);
    return md5.convert(bytes).toString();
  }

  /// From GNews API response
  factory ArticleModel.fromGNews(Map<String, dynamic> json) {
    final url = json['url'] as String? ?? '';
    final title = json['title'] as String? ?? '';
    final description = json['description'] as String?;
    final tickers = TickerExtractor.extract(title, description: description);
    final sentiment =
        SentimentAnalyzer.analyze(title, description: description);

    return ArticleModel(
      id: _generateId(url),
      title: title,
      description: description,
      url: url,
      imageUrl: json['image'] as String?,
      source: (json['source'] as Map<String, dynamic>?)?['name'] as String? ??
          'GNews',
      category: _mapCategory(json['topic'] as String?),
      sentiment: sentiment,
      relatedTickers: tickers.map((t) => t.symbol).toList(),
      publishedAt: _parseDate(json['publishedAt'] as String?),
      fetchedAt: DateTime.now(),
    );
  }

  /// From NewsData.io response
  factory ArticleModel.fromNewsData(Map<String, dynamic> json) {
    final url = json['link'] as String? ?? '';
    final title = json['title'] as String? ?? '';
    final description = json['description'] as String?;
    final tickers = TickerExtractor.extract(title, description: description);
    final sentiment =
        SentimentAnalyzer.analyze(title, description: description);

    final rawCategories = json['category'] as List<dynamic>?;
    final category = rawCategories != null && rawCategories.isNotEmpty
        ? _mapCategory(rawCategories.first as String)
        : 'Business';

    return ArticleModel(
      id: _generateId(url),
      title: title,
      description: description,
      url: url,
      imageUrl: json['image_url'] as String?,
      source: json['source_id'] as String? ?? 'NewsData',
      category: category,
      sentiment: sentiment,
      relatedTickers: tickers.map((t) => t.symbol).toList(),
      publishedAt: _parseDate(json['pubDate'] as String?),
      fetchedAt: DateTime.now(),
    );
  }

  /// From RSS feed item
  factory ArticleModel.fromRss({
    required String title,
    required String url,
    String? description,
    String? imageUrl,
    required String source,
    DateTime? pubDate,
  }) {
    final cleanDesc = _stripHtml(description);
    final tickers = TickerExtractor.extract(title, description: cleanDesc);
    final sentiment =
        SentimentAnalyzer.analyze(title, description: cleanDesc);

    return ArticleModel(
      id: _generateId(url),
      title: _stripHtml(title),
      description: cleanDesc,
      url: url,
      imageUrl: imageUrl,
      source: source,
      category: _inferCategoryFromSource(source),
      sentiment: sentiment,
      relatedTickers: tickers.map((t) => t.symbol).toList(),
      publishedAt: pubDate ?? DateTime.now(),
      fetchedAt: DateTime.now(),
    );
  }

  /// From Drift database row
  factory ArticleModel.fromDb({
    required int id,
    required String articleId,
    required String title,
    String? description,
    required String url,
    String? imageUrl,
    required String source,
    required String category,
    required String sentiment,
    String? relatedTickersJson,
    required int publishedAt,
    required int fetchedAt,
    required bool isRead,
    required bool isSaved,
    required bool isDismissed,
  }) {
    List<String> tickers = [];
    if (relatedTickersJson != null && relatedTickersJson.isNotEmpty) {
      try {
        tickers = (jsonDecode(relatedTickersJson) as List)
            .map((e) => e as String)
            .toList();
      } catch (_) {}
    }

    return ArticleModel(
      id: articleId,
      title: title,
      description: description,
      url: url,
      imageUrl: imageUrl,
      source: source,
      category: category,
      sentiment: _parseSentiment(sentiment),
      relatedTickers: tickers,
      publishedAt:
          DateTime.fromMillisecondsSinceEpoch(publishedAt * 1000),
      fetchedAt:
          DateTime.fromMillisecondsSinceEpoch(fetchedAt * 1000),
      isRead: isRead,
      isSaved: isSaved,
      isDismissed: isDismissed,
    );
  }

  Map<String, dynamic> toDbMap() {
    return {
      'articleId': id,
      'title': title,
      'description': description,
      'url': url,
      'imageUrl': imageUrl,
      'source': source,
      'category': category,
      'sentiment': sentiment.name,
      'relatedTickers': jsonEncode(relatedTickers),
      'publishedAt': publishedAt.millisecondsSinceEpoch ~/ 1000,
      'fetchedAt': fetchedAt.millisecondsSinceEpoch ~/ 1000,
      'isRead': isRead,
      'isSaved': isSaved,
      'isDismissed': isDismissed,
    };
  }

  static DateTime _parseDate(String? dateStr) {
    if (dateStr == null) return DateTime.now();
    try {
      return DateTime.parse(dateStr).toLocal();
    } catch (_) {
      return DateTime.now();
    }
  }

  static Sentiment _parseSentiment(String s) {
    switch (s) {
      case 'bull':
        return Sentiment.bull;
      case 'bear':
        return Sentiment.bear;
      default:
        return Sentiment.neutral;
    }
  }

  static String _mapCategory(String? raw) {
    if (raw == null) return 'Business';
    final lower = raw.toLowerCase();
    if (lower.contains('ipo')) return 'IPO';
    if (lower.contains('result') || lower.contains('earning')) return 'Results';
    if (lower.contains('crypto') || lower.contains('bitcoin')) return 'Crypto';
    if (lower.contains('policy') || lower.contains('rbi') || lower.contains('fed')) {
      return 'Policy';
    }
    if (lower.contains('macro') || lower.contains('gdp') || lower.contains('inflation')) {
      return 'Macro';
    }
    if (lower.contains('nse') || lower.contains('bse')) return 'NSE';
    return 'Business';
  }

  static String _inferCategoryFromSource(String source) {
    final lower = source.toLowerCase();
    if (lower.contains('nse') || lower.contains('bse')) return 'NSE';
    return 'Business';
  }

  static String _stripHtml(String? html) {
    if (html == null) return '';
    return html
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&nbsp;', ' ')
        .trim();
  }
}
