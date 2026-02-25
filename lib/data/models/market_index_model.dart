// lib/data/models/market_index_model.dart
import '../../domain/entities/market_index.dart';
import '../../core/utils/time_formatter.dart';

class MarketIndexModel extends MarketIndex {
  const MarketIndexModel({
    required super.symbol,
    required super.name,
    required super.value,
    required super.change,
    required super.changePercent,
    required super.isOpen,
    required super.updatedAt,
  });

  factory MarketIndexModel.fromNse(Map<String, dynamic> data) {
    final name = data['indexSymbol'] as String? ??
        data['index'] as String? ??
        'Unknown';
    final value = (data['last'] as num?)?.toDouble() ??
        (data['previousClose'] as num?)?.toDouble() ??
        0.0;
    final change = (data['change'] as num?)?.toDouble() ?? 0.0;
    final changePercent = (data['percentChange'] as num?)?.toDouble() ?? 0.0;
    return MarketIndexModel(
      symbol: name.replaceAll(' ', '_'),
      name: name,
      value: value,
      change: change,
      changePercent: changePercent,
      isOpen: TimeFormatter.isMarketOpen(),
      updatedAt: DateTime.now(),
    );
  }

  factory MarketIndexModel.fromYahoo(
      Map<String, dynamic> json, String symbol, String name) {
    final meta =
        (json['chart']?['result']?[0]?['meta'] as Map<String, dynamic>?) ?? {};
    final price = (meta['regularMarketPrice'] as num?)?.toDouble() ?? 0.0;
    final prevClose =
        (meta['chartPreviousClose'] as num?)?.toDouble() ?? price;
    final change = price - prevClose;
    final changePercent = prevClose != 0 ? (change / prevClose * 100) : 0.0;

    return MarketIndexModel(
      symbol: symbol,
      name: name,
      value: price,
      change: change,
      changePercent: changePercent,
      isOpen: TimeFormatter.isMarketOpen(),
      updatedAt: DateTime.now(),
    );
  }

  /// Fallback/hardcoded placeholder
  factory MarketIndexModel.placeholder(String symbol, String name) {
    return MarketIndexModel(
      symbol: symbol,
      name: name,
      value: 0.0,
      change: 0.0,
      changePercent: 0.0,
      isOpen: TimeFormatter.isMarketOpen(),
      updatedAt: DateTime.now(),
    );
  }
}
