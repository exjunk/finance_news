// lib/data/datasources/local/daos/articles_dao.dart
import 'package:drift/drift.dart';
import '../database.dart';

part 'articles_dao.g.dart';

@DriftAccessor(tables: [Articles, ReadHistory])
class ArticlesDao extends DatabaseAccessor<AppDatabase>
    with _$ArticlesDaoMixin {
  ArticlesDao(super.db);

  // ── INSERT / UPSERT ──────────────────────────────────────────────

  Future<void> upsertArticle(ArticlesCompanion article) async {
    await into(articles).insertOnConflictUpdate(article);
  }

  Future<void> upsertArticles(List<ArticlesCompanion> rows) async {
    await batch((b) {
      for (final row in rows) {
        b.insert(articles, row, mode: InsertMode.insertOrReplace);
      }
    });
  }

  // ── READ ─────────────────────────────────────────────────────────

  Future<List<Article>> getAllArticles() =>
      (select(articles)
            ..where((a) => a.isDismissed.equals(false))
            ..orderBy([(a) => OrderingTerm.desc(a.publishedAt)]))
          .get();

  Stream<List<Article>> watchAllArticles() =>
      (select(articles)
            ..where((a) => a.isDismissed.equals(false))
            ..orderBy([(a) => OrderingTerm.desc(a.publishedAt)]))
          .watch();

  Future<List<Article>> getSavedArticles() =>
      (select(articles)
            ..where((a) => a.isSaved.equals(true))
            ..orderBy([(a) => OrderingTerm.desc(a.publishedAt)]))
          .get();

  Stream<List<Article>> watchSavedArticles() =>
      (select(articles)
            ..where((a) => a.isSaved.equals(true))
            ..orderBy([(a) => OrderingTerm.desc(a.publishedAt)]))
          .watch();

  Future<Article?> getArticleById(String articleId) =>
      (select(articles)..where((a) => a.articleId.equals(articleId)))
          .getSingleOrNull();

  Future<List<Article>> searchArticles(String query) =>
      (select(articles)
            ..where((a) =>
                a.title.contains(query) | a.description.contains(query))
            ..where((a) => a.isDismissed.equals(false))
            ..orderBy([(a) => OrderingTerm.desc(a.publishedAt)]))
          .get();

  Future<List<Article>> getArticlesByCategory(String category) =>
      (select(articles)
            ..where((a) => a.category.equals(category))
            ..where((a) => a.isDismissed.equals(false))
            ..orderBy([(a) => OrderingTerm.desc(a.publishedAt)]))
          .get();

  // ── UPDATE ───────────────────────────────────────────────────────

  Future<void> markAsRead(String articleId) async {
    await (update(articles)..where((a) => a.articleId.equals(articleId)))
        .write(const ArticlesCompanion(isRead: Value(true)));
  }

  Future<void> markAsSaved(String articleId, {required bool saved}) async {
    await (update(articles)..where((a) => a.articleId.equals(articleId)))
        .write(ArticlesCompanion(isSaved: Value(saved)));
  }

  Future<void> markAsDismissed(String articleId) async {
    await (update(articles)..where((a) => a.articleId.equals(articleId)))
        .write(const ArticlesCompanion(isDismissed: Value(true)));
  }

  // ── DELETE ───────────────────────────────────────────────────────

  Future<void> deleteArticle(String articleId) async {
    await (delete(articles)..where((a) => a.articleId.equals(articleId))).go();
  }

  Future<void> clearDismissed() async {
    await (delete(articles)..where((a) => a.isDismissed.equals(true))).go();
  }

  Future<void> clearOldArticles(int olderThanUnix) async {
    await (delete(articles)..where((a) => a.fetchedAt.isSmallerThanValue(olderThanUnix))).go();
  }

  Future<void> clearAllArticles() => delete(articles).go();

  // ── READ HISTORY ─────────────────────────────────────────────────

  Future<void> addToReadHistory(String articleId) async {
    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    await into(readHistory).insertOnConflictUpdate(
      ReadHistoryCompanion(
        articleId: Value(articleId),
        readAt: Value(now),
      ),
    );
  }

  Future<bool> isInReadHistory(String articleId) async {
    final row = await (select(readHistory)
          ..where((r) => r.articleId.equals(articleId)))
        .getSingleOrNull();
    return row != null;
  }

  Future<void> clearReadHistory() => delete(readHistory).go();
}
