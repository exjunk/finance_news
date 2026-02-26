// test/unit/ticker_extractor_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:finswipe/core/utils/ticker_extractor.dart';

void main() {
  group('TickerExtractor', () {
    test('extracts Reliance from headline', () {
      final tickers = TickerExtractor.extract('Reliance Industries gains 2% on strong earnings');
      expect(tickers.any((t) => t.symbol == 'RELIANCE'), isTrue);
    });

    test('extracts TCS from abbreviation', () {
      final tickers = TickerExtractor.extract('TCS beats Q3 estimates, announces bonus shares');
      expect(tickers.any((t) => t.symbol == 'TCS'), isTrue);
    });

    test('extracts Infosys', () {
      final tickers = TickerExtractor.extract('Infosys cuts revenue outlook for FY25');
      expect(tickers.any((t) => t.symbol == 'INFY'), isTrue);
    });

    test('extracts HDFC Bank', () {
      final tickers = TickerExtractor.extract('HDFC Bank reports record profits in Q2');
      expect(tickers.any((t) => t.symbol == 'HDFCBANK'), isTrue);
    });

    test('extracts multiple tickers from one headline', () {
      final tickers = TickerExtractor.extract('TCS and Infosys both surge on IT sector boost');
      final symbols = tickers.map((t) => t.symbol).toList();
      expect(symbols.contains('TCS'), isTrue);
      expect(symbols.contains('INFY'), isTrue);
    });

    test('returns empty list for no known company', () {
      final tickers = TickerExtractor.extract('Global crude oil prices rise on OPEC+ cuts');
      expect(tickers, isEmpty);
    });

    test('extracts Maruti Suzuki', () {
      final tickers = TickerExtractor.extract('Maruti Suzuki hits record sales in September');
      expect(tickers.any((t) => t.symbol == 'MARUTI'), isTrue);
    });

    test('extracts SBI from full name', () {
      final tickers = TickerExtractor.extract('State Bank of India announces new loan scheme');
      expect(tickers.any((t) => t.symbol == 'SBIN'), isTrue);
    });
  });
}
