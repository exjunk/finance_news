// lib/data/datasources/remote/newsdata_datasource.dart
import '../../../core/constants/api_constants.dart';
import '../../../core/constants/api_keys.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/network/dio_client.dart';
import '../../models/article_model.dart';

class NewsDataDatasource {
  final DioClient _client;

  const NewsDataDatasource(this._client);

  Future<List<ArticleModel>> fetchNews({String? apiKey}) async {
    final key = apiKey ?? ApiKeys.newsData;
    if (key == 'YOUR_NEWSDATA_KEY' || key.isEmpty) {
      return [];
    }

    try {
      final resp = await _client.get(
        ApiConstants.newsDataLatest,
        queryParameters: {
          'apikey': key,
          'country': 'in',
          'category': 'business',
          'language': 'en',
        },
      );

      final data = resp.data as Map<String, dynamic>;
      if (data['status'] == 'error') {
        final code = data['results']?['code'] as String?;
        if (code == 'RateLimitExceeded') {
          throw const ApiRateLimitException(source: 'NewsData.io');
        }
        throw ServerException(
          message: data['results']?['message'] as String? ?? 'NewsData error',
        );
      }

      final articles = (data['results'] as List<dynamic>?) ?? [];
      return articles
          .map((item) =>
              ArticleModel.fromNewsData(item as Map<String, dynamic>))
          .toList();
    } on ApiRateLimitException {
      rethrow;
    } on NoInternetException {
      rethrow;
    } catch (e) {
      throw ParseException(message: e.toString());
    }
  }
}
