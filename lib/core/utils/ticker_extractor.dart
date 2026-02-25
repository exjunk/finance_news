// lib/core/utils/ticker_extractor.dart
import '../constants/ticker_symbols.dart';

class ExtractedTicker {
  final String symbol;
  final String companyName;

  const ExtractedTicker({required this.symbol, required this.companyName});
}

class TickerExtractor {
  TickerExtractor._();

  /// Scans the given [text] for known company names and returns matched tickers.
  static List<ExtractedTicker> extract(String title, {String? description}) {
    final combined = '${title.toLowerCase()} ${description?.toLowerCase() ?? ''}';
    final found = <String, ExtractedTicker>{};

    // Sort by key length descending to match longer phrases first
    final sortedEntries = TickerSymbols.companyToSymbol.entries.toList()
      ..sort((a, b) => b.key.length.compareTo(a.key.length));

    for (final entry in sortedEntries) {
      if (combined.contains(entry.key)) {
        final symbol = entry.value;
        if (!found.containsKey(symbol)) {
          found[symbol] = ExtractedTicker(
            symbol: symbol,
            companyName: _displayName(entry.key),
          );
        }
      }
    }
    return found.values.toList();
  }

  static String _displayName(String key) {
    return key
        .split(' ')
        .map((w) => w.isEmpty ? '' : w[0].toUpperCase() + w.substring(1))
        .join(' ');
  }
}
