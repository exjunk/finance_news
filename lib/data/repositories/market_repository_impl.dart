// lib/data/repositories/market_repository_impl.dart
import '../../core/utils/time_formatter.dart';
import '../../domain/entities/market_index.dart';
import '../../domain/entities/stock_quote.dart';
import '../../domain/repositories/market_repository.dart';
import '../datasources/remote/yahoo_finance_datasource.dart';
import '../datasources/remote/nse_datasource.dart';
import '../datasources/remote/exchange_rate_datasource.dart';
import '../datasources/local/local_datasource.dart';
import '../models/market_index_model.dart';

class MarketRepositoryImpl implements MarketRepository {
  final YahooFinanceDatasource _yahoo;
  final NseDatasource _nse;
  final ExchangeRateDatasource _exchangeRate;
  final LocalDatasource _local;

  const MarketRepositoryImpl({
    required YahooFinanceDatasource yahoo,
    required NseDatasource nse,
    required ExchangeRateDatasource exchangeRate,
    required LocalDatasource local,
  })  : _yahoo = yahoo,
        _nse = nse,
        _exchangeRate = exchangeRate,
        _local = local;

  @override
  Future<List<MarketIndex>> getMarketIndices() async {
    // Try Yahoo Finance first (most reliable for indices)
    try {
      final results = await _yahoo.fetchIndices();
      if (results.isNotEmpty) {
        await _local.cacheStockQuotes(
            results.map((r) => r as StockQuote).toList());
        return results;
      }
    } catch (_) {}

    // Fallback to NSE API
    try {
      final nse = await _nse.fetchNifty50();
      if (nse.isNotEmpty) return nse.take(3).toList();
    } catch (_) {}

    // Return cached or placeholder
    final cached = await _local.getCachedSnapshots();
    if (cached.isNotEmpty) {
      return cached
          .take(3)
          .map((q) => MarketIndexModel(
                symbol: q.symbol,
                name: q.name,
                value: q.price,
                change: q.change,
                changePercent: q.changePercent,
                isOpen: TimeFormatter.isMarketOpen(),
                updatedAt: q.updatedAt,
              ))
          .toList();
    }

    return [
      MarketIndexModel.placeholder('^NSEI', 'NIFTY 50'),
      MarketIndexModel.placeholder('^BSESN', 'SENSEX'),
      MarketIndexModel.placeholder('^NSEBANK', 'BANK NIFTY'),
    ];
  }

  @override
  Future<List<StockQuote>> getTopGainers() async {
    try {
      return await _nse.fetchTopGainers();
    } catch (_) {
      try {
        final movers = await _yahoo.fetchTopMovers();
        return movers.where((s) => s.changePercent > 0).take(5).toList();
      } catch (_) {
        return [];
      }
    }
  }

  @override
  Future<List<StockQuote>> getTopLosers() async {
    try {
      return await _nse.fetchTopLosers();
    } catch (_) {
      try {
        final movers = await _yahoo.fetchTopMovers();
        return movers.where((s) => s.changePercent < 0).take(5).toList();
      } catch (_) {
        return [];
      }
    }
  }

  @override
  Future<double> getUsdInrRate() async {
    try {
      return await _exchangeRate.fetchUsdToInr();
    } catch (_) {
      return 83.0;
    }
  }

  @override
  Future<bool> isMarketOpen() async {
    try {
      return await _nse.fetchMarketStatus();
    } catch (_) {
      return TimeFormatter.isMarketOpen();
    }
  }
}
