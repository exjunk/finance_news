// lib/data/datasources/remote/gnews_datasource.dart
import '../../../core/constants/api_constants.dart';
import '../../../core/constants/api_keys.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/network/dio_client.dart';
import '../../models/article_model.dart';

class GNewsDatasource {
  final DioClient _client;

  const GNewsDatasource(this._client);

  static const List<String> _queries = [
    'india stock market',
    'NSE BSE Nifty Sensex',
    'Indian economy finance',
    'IPO India',
  ];

  Future<List<ArticleModel>> fetchNews({
    String? category,
    String? apiKey,
  }) async {
    final key = apiKey ?? ApiKeys.gnews;
    if (key == 'YOUR_GNEWS_TOKEN' || key.isEmpty) {
      return []; // No key configured, skip this source
    }

    final results = <ArticleModel>[];
    final seen = <String>{};

    for (final q in _queries) {
      try {
        final resp = await _client.get(
          ApiConstants.gnewsSearch,
          queryParameters: {
            'q': q,
            'lang': 'en',
            'country': 'in',
            'max': '10',
            'token': key,
          },
        );

        final data = resp.data as Map<String, dynamic>;
        if (data['errors'] != null) {
          throw ApiRateLimitException(source: 'GNews');
        }
        final articles = (data['articles'] as List<dynamic>?) ?? [];
        for (final item in articles) {
          final model = ArticleModel.fromGNews(item as Map<String, dynamic>);
          if (seen.add(model.id)) results.add(model);
        }
      } on ApiRateLimitException {
        rethrow;
      } catch (e) {
        // Skip failed query, continue with next
      }
    }
    return results;
  }
}
