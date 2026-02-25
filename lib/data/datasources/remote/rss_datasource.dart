// lib/data/datasources/remote/rss_datasource.dart
import 'package:xml/xml.dart';
import 'package:dio/dio.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../models/article_model.dart';

class RssDatasource {
  final Dio _dio;

  RssDatasource(this._dio);

  static const Map<String, String> _feedSourceNames = {
    ApiConstants.etMarketsRss: 'ET Markets',
    ApiConstants.moneyControlRss: 'Moneycontrol',
    ApiConstants.livemintRss: 'Livemint',
    ApiConstants.businessStandardRss: 'Business Standard',
  };

  Future<List<ArticleModel>> fetchAllFeeds() async {
    final futures = ApiConstants.rssFeeds.map(_fetchFeed);
    final results = await Future.wait(futures, eagerError: false);

    final allArticles = results
        .where((r) => r != null)
        .expand((r) => r!)
        .toList();

    // Deduplicate by article id (URL hash)
    final seen = <String>{};
    final deduplicated = allArticles.where((a) => seen.add(a.id)).toList();

    // Filter out articles older than 7 days
    final cutoff = DateTime.now().subtract(const Duration(days: 7));
    final filtered = deduplicated
        .where((a) => a.publishedAt.isAfter(cutoff))
        .toList();

    // Sort by date descending
    filtered.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));

    return filtered;
  }

  Future<List<ArticleModel>?> _fetchFeed(String feedUrl) async {
    try {
      final resp = await _dio.get<String>(
        feedUrl,
        options: Options(
          receiveTimeout: const Duration(seconds: 20),
          headers: {
            'Accept':
                'application/rss+xml, application/xml, text/xml, */*',
            'User-Agent': 'StockSwipe/1.0',
          },
        ),
      );

      if (resp.data == null) return null;
      final sourceName = _feedSourceNames[feedUrl] ?? 'RSS';

      return _parseRss(resp.data!, sourceName);
    } catch (_) {
      return null;
    }
  }

  List<ArticleModel>? _parseRss(String xmlString, String sourceName) {
    try {
      final document = XmlDocument.parse(xmlString);
      final articles = <ArticleModel>[];

      // Standard RSS
      final items = document.findAllElements('item');
      if (items.isNotEmpty) {
        for (final item in items) {
          final title = item.getElement('title')?.innerText.trim();
          final link = item.getElement('link')?.innerText.trim() ??
              item.getElement('guid')?.innerText.trim();
          if (title == null || link == null) continue;

          final description = item.getElement('description')?.innerText.trim();
          final pubDateStr = item.getElement('pubDate')?.innerText.trim();
          final enclosure = item.getElement('enclosure');
          String? imageUrl = enclosure?.getAttribute('url');
          imageUrl ??= _extractImage(description);

          DateTime pubDate = DateTime.now();
          if (pubDateStr != null) {
            try {
              pubDate = _parseRssDate(pubDateStr);
            } catch (_) {}
          }

          articles.add(ArticleModel.fromRss(
            title: title,
            url: link,
            description: description,
            imageUrl: imageUrl,
            source: sourceName,
            pubDate: pubDate,
          ));
        }
        return articles;
      }

      // Atom
      final entries = document.findAllElements('entry');
      for (final entry in entries) {
        final title = entry.getElement('title')?.innerText.trim();
        final links = entry.findElements('link');
        String? link;
        for (final l in links) {
          final rel = l.getAttribute('rel');
          if (rel == null || rel == 'alternate') {
            link = l.getAttribute('href');
            break;
          }
        }
        if (title == null || link == null) continue;

        final summary = entry.getElement('summary')?.innerText.trim();
        final updatedStr = entry.getElement('updated')?.innerText.trim();

        DateTime pubDate = DateTime.now();
        if (updatedStr != null) {
          try {
            pubDate = DateTime.parse(updatedStr);
          } catch (_) {}
        }

        articles.add(ArticleModel.fromRss(
          title: title,
          url: link,
          description: summary,
          source: sourceName,
          pubDate: pubDate,
        ));
      }

      return articles.isNotEmpty ? articles : null;
    } catch (_) {
      return null;
    }
  }

  DateTime _parseRssDate(String dateStr) {
    // Try standard RFC 822 format used in RSS
    // E.g. "Mon, 25 Feb 2024 10:30:00 +0530"
    // Dart's DateTime.parse doesn't handle RFC 822 directly
    // Simple regex extraction
    try {
      return DateTime.parse(dateStr);
    } catch (_) {
      // Strip day-of-week prefix and timezone name suffix
      final cleaned = dateStr
          .replaceFirst(RegExp(r'^[A-Za-z]+,\s*'), '')
          .replaceFirst(RegExp(r'\s+[A-Z]{2,4}$'), '');
      return DateTime.parse(cleaned);
    }
  }

  String? _extractImage(String? html) {
    if (html == null) return null;
    final imgRegex = RegExp(r'<img[^>]+src="([^"]+)"', caseSensitive: false);
    final match = imgRegex.firstMatch(html);
    return match?.group(1);
  }
}
