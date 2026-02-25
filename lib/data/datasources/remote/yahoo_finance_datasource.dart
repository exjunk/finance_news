// lib/data/datasources/remote/yahoo_finance_datasource.dart
import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../../models/stock_model.dart';
import '../../models/market_index_model.dart';

class YahooFinanceDatasource {
  final DioClient _client;

  const YahooFinanceDatasource(this._client);

  static const Map<String, String> _indexSymbols = {
    '^NSEI': 'NIFTY 50',
    '^BSESN': 'SENSEX',
    '^NSEBANK': 'BANK NIFTY',
  };

  Future<List<MarketIndexModel>> fetchIndices() async {
    final results = <MarketIndexModel>[];
    for (final entry in _indexSymbols.entries) {
      try {
        final model = await _fetchIndex(entry.key, entry.value);
        if (model != null) results.add(model);
      } catch (_) {
        results.add(MarketIndexModel.placeholder(entry.key, entry.value));
      }
    }
    return results;
  }

  Future<MarketIndexModel?> _fetchIndex(
      String symbol, String name) async {
    try {
      final resp = await _client.get(
        '${ApiConstants.yahooFinanceBase}/$symbol',
        queryParameters: {'interval': '1d', 'range': '1d'},
      );
      return MarketIndexModel.fromYahoo(
          resp.data as Map<String, dynamic>, symbol, name);
    } catch (e) {
      return null;
    }
  }

  Future<List<StockModel>> fetchStockQuotes(
      List<String> symbols) async {
    final results = <StockModel>[];
    for (final symbol in symbols) {
      try {
        final resp = await _client.get(
          '${ApiConstants.yahooFinanceBase}/$symbol',
          queryParameters: {'interval': '1d', 'range': '1d'},
        );
        results.add(StockModel.fromYahoo(
            resp.data as Map<String, dynamic>, symbol));
      } catch (e) {
        // Skip failed symbols
      }
    }
    return results;
  }

  Future<List<StockModel>> fetchTopMovers() async {
    // Use a curated list of large cap NSE stocks
    const topSymbols = [
      'RELIANCE.NS', 'TCS.NS', 'INFY.NS', 'HDFCBANK.NS', 'ICICIBANK.NS',
      'WIPRO.NS', 'KOTAKBANK.NS', 'AXISBANK.NS', 'SBIN.NS', 'LT.NS',
      'ITC.NS', 'BAJFINANCE.NS', 'MARUTI.NS', 'TATAMOTORS.NS', 'SUNPHARMA.NS',
    ];
    final quotes = await fetchStockQuotes(topSymbols);
    quotes.sort((a, b) => b.changePercent.abs().compareTo(a.changePercent.abs()));
    return quotes;
  }
}
