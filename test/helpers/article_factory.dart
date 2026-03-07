// test/helpers/article_factory.dart
import 'package:finswipe/core/utils/sentiment_analyzer.dart';
import 'package:finswipe/domain/entities/article.dart';

/// Generates fake [Article] instances for tests.
class ArticleFactory {
  ArticleFactory._();

  static Article create({
    String id = 'test-id-1',
    String title = 'Nifty 50 hits all-time high as FIIs turn buyers',
    String? description = 'The benchmark index crossed 22,000 for the first time.',
    String url = 'https://example.com/article',
    String? imageUrl,
    String source = 'ET Markets',
    String category = 'All',
    Sentiment sentiment = Sentiment.bull,
    List<String> relatedTickers = const ['NIFTY', 'SENSEX'],
    bool isRead = false,
    bool isSaved = false,
    bool isDismissed = false,
  }) {
    return Article(
      id: id,
      title: title,
      description: description,
      url: url,
      imageUrl: imageUrl,
      source: source,
      category: category,
      sentiment: sentiment,
      relatedTickers: relatedTickers,
      publishedAt: DateTime(2024, 1, 15, 9, 30),
      fetchedAt: DateTime(2024, 1, 15, 10, 0),
      isRead: isRead,
      isSaved: isSaved,
      isDismissed: isDismissed,
    );
  }

  static List<Article> createList(int count, {Sentiment? sentiment}) {
    return List.generate(
      count,
      (i) => create(
        id: 'test-id-$i',
        title: 'Article headline number $i',
        sentiment: sentiment ?? Sentiment.bull,
      ),
    );
  }
}
