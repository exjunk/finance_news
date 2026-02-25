// lib/data/datasources/remote/nse_datasource.dart
import '../../../core/constants/api_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/network/dio_client.dart';
import '../../models/stock_model.dart';
import '../../models/market_index_model.dart';

class NseDatasource {
  final NseDioClient _client;

  const NseDatasource(this._client);

  Future<List<MarketIndexModel>> fetchNifty50() async {
    try {
      final resp = await _client.dio.get(ApiConstants.nseNifty50);
      final data = resp.data as Map<String, dynamic>;
      final advances = (data['data'] as List<dynamic>?) ?? [];
      return advances
          .map((item) =>
              MarketIndexModel.fromNse(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(message: 'NSE Nifty 50 fetch failed: $e');
    }
  }

  Future<List<StockModel>> fetchTopGainers() async {
    try {
      final resp = await _client.dio.get(ApiConstants.nseTopGainers);
      final data = resp.data as Map<String, dynamic>;
      final items = (data['data'] as List<dynamic>?) ?? [];
      return items
          .take(10)
          .map((item) =>
              StockModel.fromNse(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(message: 'NSE top gainers fetch failed: $e');
    }
  }

  Future<List<StockModel>> fetchTopLosers() async {
    try {
      final resp = await _client.dio.get(ApiConstants.nseTopLosers);
      final data = resp.data as Map<String, dynamic>;
      final items = (data['data'] as List<dynamic>?) ?? [];
      return items
          .take(10)
          .map((item) =>
              StockModel.fromNse(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw ServerException(message: 'NSE top losers fetch failed: $e');
    }
  }

  Future<bool> fetchMarketStatus() async {
    try {
      final resp = await _client.dio.get(ApiConstants.nseMarketStatus);
      final data = resp.data as Map<String, dynamic>;
      final market = data['marketState'] as List<dynamic>?;
      if (market == null || market.isEmpty) return false;
      final status =
          (market.first as Map<String, dynamic>)['marketStatus'] as String? ?? '';
      return status.toLowerCase().contains('open');
    } catch (_) {
      return false;
    }
  }
}
