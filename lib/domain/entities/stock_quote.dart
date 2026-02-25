// lib/domain/entities/stock_quote.dart

class StockQuote {
  final String symbol;
  final String name;
  final double price;
  final double change;
  final double changePercent;
  final double? open;
  final double? high;
  final double? low;
  final double? previousClose;
  final double? volume;
  final DateTime updatedAt;

  const StockQuote({
    required this.symbol,
    required this.name,
    required this.price,
    required this.change,
    required this.changePercent,
    this.open,
    this.high,
    this.low,
    this.previousClose,
    this.volume,
    required this.updatedAt,
  });

  bool get isPositive => change >= 0;
}
