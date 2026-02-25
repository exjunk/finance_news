// lib/domain/usecases/get_market_indices.dart
import '../entities/market_index.dart';
import '../entities/stock_quote.dart';
import '../repositories/market_repository.dart';

class GetMarketIndices {
  final MarketRepository repository;
  const GetMarketIndices(this.repository);

  Future<List<MarketIndex>> call() => repository.getMarketIndices();
}

class GetTopMovers {
  final MarketRepository repository;
  const GetTopMovers(this.repository);

  Future<List<StockQuote>> gainers() => repository.getTopGainers();
  Future<List<StockQuote>> losers() => repository.getTopLosers();
}
