// lib/domain/repositories/market_repository.dart
import '../entities/market_index.dart';
import '../entities/stock_quote.dart';

abstract class MarketRepository {
  Future<List<MarketIndex>> getMarketIndices();
  Future<List<StockQuote>> getTopGainers();
  Future<List<StockQuote>> getTopLosers();
  Future<double> getUsdInrRate();
  Future<bool> isMarketOpen();
}
