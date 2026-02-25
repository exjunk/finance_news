// lib/core/utils/number_formatter.dart

class NumberFormatter {
  NumberFormatter._();

  /// Formats a number in Indian style: ₹1.2 Cr, ₹45.3 L, ₹1,25,000
  static String formatIndian(num value, {bool withSymbol = true}) {
    final symbol = withSymbol ? '₹' : '';
    final abs = value.abs();
    final sign = value < 0 ? '-' : '';

    if (abs >= 1e7) {
      // Crore
      return '$sign$symbol${(abs / 1e7).toStringAsFixed(2)} Cr';
    } else if (abs >= 1e5) {
      // Lakh
      return '$sign$symbol${(abs / 1e5).toStringAsFixed(2)} L';
    } else if (abs >= 1e3) {
      // Thousands with comma
      return '$sign$symbol${_indianComma(abs.round())}';
    }
    return '$sign$symbol${abs.toStringAsFixed(2)}';
  }

  static String _indianComma(int number) {
    final str = number.toString();
    if (str.length <= 3) return str;
    final last3 = str.substring(str.length - 3);
    final rest = str.substring(0, str.length - 3);
    final groups = <String>[];
    for (int i = rest.length; i > 0; i -= 2) {
      groups.insert(0, rest.substring(i < 2 ? 0 : i - 2, i));
    }
    return '${groups.join(',')},$last3';
  }

  /// Formats a percentage change: +1.23%, -0.45%
  static String formatChange(double change) {
    final sign = change >= 0 ? '+' : '';
    return '$sign${change.toStringAsFixed(2)}%';
  }

  /// Formats a stock price with 2 decimal places
  static String formatPrice(double price) {
    return '₹${price.toStringAsFixed(2)}';
  }

  /// Formats a large market cap number
  static String formatMarketCap(double value) {
    return formatIndian(value, withSymbol: true);
  }

  /// E.g. 24,523.15
  static String formatIndex(double value) {
    final parts = value.toStringAsFixed(2).split('.');
    return '${_indianComma(int.parse(parts[0]))}.${parts[1]}';
  }
}
