// lib/domain/entities/market_index.dart

class MarketIndex {
  final String symbol;
  final String name;
  final double value;
  final double change;
  final double changePercent;
  final bool isOpen;
  final DateTime updatedAt;

  const MarketIndex({
    required this.symbol,
    required this.name,
    required this.value,
    required this.change,
    required this.changePercent,
    required this.isOpen,
    required this.updatedAt,
  });

  bool get isPositive => change >= 0;
}
