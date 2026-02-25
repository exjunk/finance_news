// lib/data/models/stock_model.dart
import '../../domain/entities/stock_quote.dart';

class StockModel extends StockQuote {
  const StockModel({
    required super.symbol,
    required super.name,
    required super.price,
    required super.change,
    required super.changePercent,
    super.open,
    super.high,
    super.low,
    super.previousClose,
    super.volume,
    required super.updatedAt,
  });

  /// From Yahoo Finance chart response
  factory StockModel.fromYahoo(Map<String, dynamic> json, String symbol) {
    final meta = (json['chart']?['result']?[0]?['meta'] as Map<String, dynamic>?) ?? {};
    final price = (meta['regularMarketPrice'] as num?)?.toDouble() ?? 0.0;
    final prevClose =
        (meta['chartPreviousClose'] as num?)?.toDouble() ?? price;
    final change = price - prevClose;
    final changePercent = prevClose != 0 ? (change / prevClose * 100) : 0.0;

    return StockModel(
      symbol: symbol.replaceAll('.NS', '').replaceAll('.BSE', ''),
      name: meta['longName'] as String? ??
          meta['shortName'] as String? ??
          symbol,
      price: price,
      change: change,
      changePercent: changePercent,
      open: (meta['regularMarketOpen'] as num?)?.toDouble(),
      high: (meta['regularMarketDayHigh'] as num?)?.toDouble(),
      low: (meta['regularMarketDayLow'] as num?)?.toDouble(),
      previousClose: prevClose,
      volume: (meta['regularMarketVolume'] as num?)?.toDouble(),
      updatedAt: DateTime.now(),
    );
  }

  /// From Finnhub quote response
  factory StockModel.fromFinnhub(
      Map<String, dynamic> json, String symbol, String name) {
    final price = (json['c'] as num?)?.toDouble() ?? 0.0;
    final change = (json['d'] as num?)?.toDouble() ?? 0.0;
    final changePercent = (json['dp'] as num?)?.toDouble() ?? 0.0;
    return StockModel(
      symbol: symbol,
      name: name,
      price: price,
      change: change,
      changePercent: changePercent,
      open: (json['o'] as num?)?.toDouble(),
      high: (json['h'] as num?)?.toDouble(),
      low: (json['l'] as num?)?.toDouble(),
      previousClose: (json['pc'] as num?)?.toDouble(),
      updatedAt: DateTime.now(),
    );
  }

  /// From NSE equity stock indices response
  factory StockModel.fromNse(Map<String, dynamic> json) {
    final symbol = json['symbol'] as String? ?? '';
    final price = (json['lastPrice'] as num?)?.toDouble() ?? 0.0;
    final change = (json['change'] as num?)?.toDouble() ?? 0.0;
    final changePercent = (json['pChange'] as num?)?.toDouble() ?? 0.0;
    return StockModel(
      symbol: symbol,
      name: json['companyName'] as String? ?? symbol,
      price: price,
      change: change,
      changePercent: changePercent,
      open: (json['open'] as num?)?.toDouble(),
      high: (json['dayHigh'] as num?)?.toDouble(),
      low: (json['dayLow'] as num?)?.toDouble(),
      previousClose: (json['previousClose'] as num?)?.toDouble(),
      updatedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toDbMap() {
    return {
      'symbol': symbol,
      'name': name,
      'price': price,
      'change': change,
      'changePercent': changePercent,
      'snapshotAt': updatedAt.millisecondsSinceEpoch ~/ 1000,
    };
  }
}
