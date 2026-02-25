// lib/data/datasources/remote/exchange_rate_datasource.dart
import '../../../core/constants/api_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/network/dio_client.dart';

class ExchangeRateDatasource {
  final DioClient _client;

  const ExchangeRateDatasource(this._client);

  /// Fetches USD/INR exchange rate (no API key required)
  Future<double> fetchUsdToInr() async {
    try {
      final resp = await _client.get(ApiConstants.exchangeRateBase);
      final data = resp.data as Map<String, dynamic>;
      final rates = data['rates'] as Map<String, dynamic>?;
      return (rates?['INR'] as num?)?.toDouble() ?? 83.0;
    } catch (_) {
      return 83.0; // fallback
    }
  }

  /// Returns a map of currency → rate relative to USD
  Future<Map<String, double>> fetchAllRates() async {
    try {
      final resp = await _client.get(ApiConstants.exchangeRateBase);
      final data = resp.data as Map<String, dynamic>;
      final rawRates = data['rates'] as Map<String, dynamic>? ?? {};
      return rawRates.map(
          (k, v) => MapEntry(k, (v as num).toDouble()));
    } catch (e) {
      throw ServerException(message: 'Exchange rate fetch failed: $e');
    }
  }
}
