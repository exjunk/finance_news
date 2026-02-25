// lib/injection_container.dart
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/datasources/local/database.dart';
import 'data/datasources/local/local_datasource.dart';
import 'data/datasources/remote/gnews_datasource.dart';
import 'data/datasources/remote/newsdata_datasource.dart';
import 'data/datasources/remote/rss_datasource.dart';
import 'data/datasources/remote/yahoo_finance_datasource.dart';
import 'data/datasources/remote/nse_datasource.dart';
import 'data/datasources/remote/exchange_rate_datasource.dart';
import 'data/repositories/news_repository_impl.dart';
import 'data/repositories/market_repository_impl.dart';
import 'domain/repositories/news_repository.dart';
import 'domain/repositories/market_repository.dart';
import 'domain/usecases/get_news_feed.dart';
import 'domain/usecases/get_market_indices.dart';
import 'core/network/dio_client.dart';

// ── Database ──────────────────────────────────────────────────────

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final localDatasourceProvider = Provider<LocalDatasource>((ref) {
  return LocalDatasource(ref.watch(appDatabaseProvider));
});

// ── Network ───────────────────────────────────────────────────────

final dioClientProvider = Provider<DioClient>((ref) => DioClient());

final nseDioClientProvider =
    Provider<NseDioClient>((ref) => NseDioClient());

// ── Remote Datasources ────────────────────────────────────────────

final gNewsDatasourceProvider = Provider<GNewsDatasource>(
    (ref) => GNewsDatasource(ref.watch(dioClientProvider)));

final newsDataDatasourceProvider = Provider<NewsDataDatasource>(
    (ref) => NewsDataDatasource(ref.watch(dioClientProvider)));

final rssDatasourceProvider = Provider<RssDatasource>(
    (ref) => RssDatasource(ref.watch(dioClientProvider).dio));

final yahooFinanceDatasourceProvider = Provider<YahooFinanceDatasource>(
    (ref) => YahooFinanceDatasource(ref.watch(dioClientProvider)));

final nseDatasourceProvider = Provider<NseDatasource>(
    (ref) => NseDatasource(ref.watch(nseDioClientProvider)));

final exchangeRateDatasourceProvider = Provider<ExchangeRateDatasource>(
    (ref) => ExchangeRateDatasource(ref.watch(dioClientProvider)));

// ── Repositories ──────────────────────────────────────────────────

final newsRepositoryProvider = Provider<NewsRepository>((ref) {
  return NewsRepositoryImpl(
    gNews: ref.watch(gNewsDatasourceProvider),
    newsData: ref.watch(newsDataDatasourceProvider),
    rss: ref.watch(rssDatasourceProvider),
    local: ref.watch(localDatasourceProvider),
  );
});

final marketRepositoryProvider = Provider<MarketRepository>((ref) {
  return MarketRepositoryImpl(
    yahoo: ref.watch(yahooFinanceDatasourceProvider),
    nse: ref.watch(nseDatasourceProvider),
    exchangeRate: ref.watch(exchangeRateDatasourceProvider),
    local: ref.watch(localDatasourceProvider),
  );
});

// ── Use Cases ─────────────────────────────────────────────────────

final getNewsFeedProvider = Provider<GetNewsFeed>(
    (ref) => GetNewsFeed(ref.watch(newsRepositoryProvider)));

final getMarketIndicesProvider = Provider<GetMarketIndices>(
    (ref) => GetMarketIndices(ref.watch(marketRepositoryProvider)));

final getTopMoversProvider = Provider<GetTopMovers>(
    (ref) => GetTopMovers(ref.watch(marketRepositoryProvider)));

final getSavedArticlesProvider = Provider<GetSavedArticles>(
    (ref) => GetSavedArticles(ref.watch(newsRepositoryProvider)));

final searchArticlesProvider = Provider<SearchArticles>(
    (ref) => SearchArticles(ref.watch(newsRepositoryProvider)));
