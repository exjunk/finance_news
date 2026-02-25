// test/unit/number_formatter_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:stockswipe/core/utils/number_formatter.dart';

void main() {
  group('NumberFormatter', () {
    test('formats crore correctly', () {
      expect(NumberFormatter.formatIndian(12500000), '₹1.25 Cr');
    });

    test('formats lakh correctly', () {
      expect(NumberFormatter.formatIndian(450000), '₹4.50 L');
    });

    test('formats negative crore', () {
      final result = NumberFormatter.formatIndian(-12500000);
      expect(result, contains('Cr'));
      expect(result, startsWith('-'));
    });

    test('formats thousands', () {
      final result = NumberFormatter.formatIndian(75000);
      expect(result.contains('₹'), isTrue);
    });

    test('formatChange positive', () {
      expect(NumberFormatter.formatChange(1.23), '+1.23%');
    });

    test('formatChange negative', () {
      expect(NumberFormatter.formatChange(-0.45), '-0.45%');
    });

    test('formatPrice includes rupee symbol', () {
      final result = NumberFormatter.formatPrice(1234.56);
      expect(result, '₹1234.56');
    });

    test('formatIndex handles large numbers', () {
      final result = NumberFormatter.formatIndex(24523.15);
      expect(result.contains('.'), isTrue);
    });

    test('without symbol option', () {
      final result = NumberFormatter.formatIndian(12500000, withSymbol: false);
      expect(result.contains('₹'), isFalse);
      expect(result.contains('Cr'), isTrue);
    });
  });
}
