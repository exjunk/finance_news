// lib/domain/entities/article.dart
import '../../core/utils/sentiment_analyzer.dart';

class Article {
  final String id;
  final String title;
  final String? description;
  final String url;
  final String? imageUrl;
  final String source;
  final String category;
  final Sentiment sentiment;
  final List<String> relatedTickers;
  final DateTime publishedAt;
  final DateTime fetchedAt;
  final bool isRead;
  final bool isSaved;
  final bool isDismissed;

  const Article({
    required this.id,
    required this.title,
    this.description,
    required this.url,
    this.imageUrl,
    required this.source,
    required this.category,
    required this.sentiment,
    this.relatedTickers = const [],
    required this.publishedAt,
    required this.fetchedAt,
    this.isRead = false,
    this.isSaved = false,
    this.isDismissed = false,
  });

  int get readingTimeMinutes {
    final text = '$title ${description ?? ''}';
    const wordsPerMinute = 200;
    final count = text.trim().split(RegExp(r'\s+')).length;
    return (count / wordsPerMinute).ceil().clamp(1, 60);
  }

  Article copyWith({
    String? id,
    String? title,
    String? description,
    String? url,
    String? imageUrl,
    String? source,
    String? category,
    Sentiment? sentiment,
    List<String>? relatedTickers,
    DateTime? publishedAt,
    DateTime? fetchedAt,
    bool? isRead,
    bool? isSaved,
    bool? isDismissed,
  }) {
    return Article(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
      imageUrl: imageUrl ?? this.imageUrl,
      source: source ?? this.source,
      category: category ?? this.category,
      sentiment: sentiment ?? this.sentiment,
      relatedTickers: relatedTickers ?? this.relatedTickers,
      publishedAt: publishedAt ?? this.publishedAt,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      isRead: isRead ?? this.isRead,
      isSaved: isSaved ?? this.isSaved,
      isDismissed: isDismissed ?? this.isDismissed,
    );
  }
}
