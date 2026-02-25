// lib/domain/usecases/get_news_feed.dart
import '../entities/article.dart';
import '../repositories/news_repository.dart';

class GetNewsFeed {
  final NewsRepository repository;
  const GetNewsFeed(this.repository);

  Future<List<Article>> call({String? category}) =>
      repository.getNewsFeed(category: category);
}

// lib/domain/usecases/save_article.dart (inline as separate part)
class SaveArticle {
  final NewsRepository repository;
  const SaveArticle(this.repository);

  Future<void> call(String articleId) => repository.saveArticle(articleId);
}

// lib/domain/usecases/dismiss_article.dart
class DismissArticle {
  final NewsRepository repository;
  const DismissArticle(this.repository);

  Future<void> call(String articleId) => repository.dismissArticle(articleId);
}

// lib/domain/usecases/get_saved_articles.dart
class GetSavedArticles {
  final NewsRepository repository;
  const GetSavedArticles(this.repository);

  Future<List<Article>> call() => repository.getSavedArticles();
  Stream<List<Article>> watch() => repository.watchSavedArticles();
}

// lib/domain/usecases/search_articles.dart
class SearchArticles {
  final NewsRepository repository;
  const SearchArticles(this.repository);

  Future<List<Article>> call(String query) => repository.searchArticles(query);
}
