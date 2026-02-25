// lib/presentation/providers/market_provider.dart
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/market_index.dart';
import '../../domain/entities/stock_quote.dart';
import '../../injection_container.dart';

// ── Market indices (auto-refresh every 60s) ───────────────────────

final marketIndicesProvider =
    FutureProvider.autoDispose<List<MarketIndex>>((ref) async {
  // Auto-refresh every 60 seconds
  ref.cacheFor(const Duration(seconds: 60));
  return ref.watch(getMarketIndicesProvider).call();
});

// ── Top gainers ───────────────────────────────────────────────────

final topGainersProvider =
    FutureProvider.autoDispose<List<StockQuote>>((ref) async {
  return ref.watch(getTopMoversProvider).gainers();
});

// ── Top losers ────────────────────────────────────────────────────

final topLosersProvider =
    FutureProvider.autoDispose<List<StockQuote>>((ref) async {
  return ref.watch(getTopMoversProvider).losers();
});

// ── Market open status ────────────────────────────────────────────

final marketOpenProvider =
    FutureProvider.autoDispose<bool>((ref) async {
  return ref.watch(marketRepositoryProvider).isMarketOpen();
});

// ── USD/INR rate ──────────────────────────────────────────────────

final usdInrRateProvider =
    FutureProvider.autoDispose<double>((ref) async {
  return ref.watch(marketRepositoryProvider).getUsdInrRate();
});

// Extension to add cacheFor to AutoDisposeFutureProvider
extension CacheForExtension on Ref {
  void cacheFor(Duration duration) {
    final timer = Timer(duration, invalidateSelf);
    onDispose(timer.cancel);
  }
}
