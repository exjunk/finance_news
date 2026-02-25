// lib/presentation/screens/home/market_pulse/market_pulse_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/number_formatter.dart';
import '../../../../core/utils/time_formatter.dart';
import '../../../../domain/entities/stock_quote.dart';
import '../../../providers/market_provider.dart';
import '../../../widgets/shimmer_card.dart';

class MarketPulseScreen extends ConsumerWidget {
  const MarketPulseScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(marketIndicesProvider);
            ref.invalidate(topGainersProvider);
            ref.invalidate(topLosersProvider);
          },
          color: AppColors.primary,
          child: CustomScrollView(
            slivers: [
              _buildAppBar(context, ref),
              SliverToBoxAdapter(
                child: _MarketStatusBanner(ref: ref),
              ),
              SliverToBoxAdapter(
                child: _IndexCardsRow(ref: ref),
              ),
              const SliverToBoxAdapter(
                child: _SectorHeatmap(),
              ),
              SliverToBoxAdapter(
                child: _MoversSection(ref: ref),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 32)),
            ],
          ),
        ),
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context, WidgetRef ref) {
    return SliverAppBar(
      floating: true,
      title: Text(
        'Market Pulse',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            ref.invalidate(marketIndicesProvider);
            ref.invalidate(topGainersProvider);
            ref.invalidate(topLosersProvider);
          },
        ),
      ],
    );
  }
}

class _MarketStatusBanner extends StatelessWidget {
  final WidgetRef ref;
  const _MarketStatusBanner({required this.ref});

  @override
  Widget build(BuildContext context) {
    final isOpen = TimeFormatter.isMarketOpen();
    final color = isOpen ? AppColors.bull : AppColors.textSecondaryDark;

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            TimeFormatter.marketStatusLabel(),
            style: TextStyle(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _IndexCardsRow extends StatelessWidget {
  final WidgetRef ref;
  const _IndexCardsRow({required this.ref});

  @override
  Widget build(BuildContext context) {
    final indicesAsync = ref.watch(marketIndicesProvider);

    return SizedBox(
      height: 120,
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: indicesAsync.when(
          loading: () => const _IndexCardSkeleton(),
          error: (_, __) => const _IndexCardSkeleton(),
          data: (indices) {
            if (indices.isEmpty) return const _IndexCardSkeleton();
            return ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: indices.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (_, i) {
                final idx = indices[i];
                return _IndexCard(
                  name: idx.name,
                  value: NumberFormatter.formatIndex(idx.value),
                  change: idx.changePercent,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _IndexCardSkeleton extends StatelessWidget {
  const _IndexCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: 3,
      separatorBuilder: (_, __) => const SizedBox(width: 12),
      itemBuilder: (context, _) => Container(
        width: 140,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const ShimmerListTile(),
      ),
    );
  }
}

class _IndexCard extends StatelessWidget {
  final String name;
  final String value;
  final double change;

  const _IndexCard(
      {required this.name, required this.value, required this.change});

  @override
  Widget build(BuildContext context) {
    final isPos = change >= 0;
    final color = isPos ? AppColors.bull : AppColors.bear;

    return Container(
      width: 150,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: color.withOpacity(0.2), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondaryDark),
              maxLines: 1,
              overflow: TextOverflow.ellipsis),
          Text(value,
              style: GoogleFonts.jetBrainsMono(
                  fontSize: 18, fontWeight: FontWeight.w700)),
          Row(
            children: [
              Icon(
                  isPos ? Icons.trending_up : Icons.trending_down,
                  color: color,
                  size: 14),
              const SizedBox(width: 4),
              Text(
                '${isPos ? '+' : ''}${change.toStringAsFixed(2)}%',
                style: GoogleFonts.jetBrainsMono(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectorHeatmap extends StatelessWidget {
  static const _sectors = [
    ('IT', 1.2),
    ('Banking', -0.5),
    ('Pharma', 0.8),
    ('Auto', -1.1),
    ('FMCG', 0.3),
    ('Energy', 2.1),
    ('Metals', -0.7),
    ('Realty', 1.5),
    ('Infra', -0.2),
  ];

  const _SectorHeatmap();

  Color _heatColor(double pct) {
    if (pct >= 2) return AppColors.sectorBullStrong;
    if (pct >= 0.5) return AppColors.sectorBullMild;
    if (pct >= -0.5) return AppColors.sectorNeutral;
    if (pct >= -2) return AppColors.sectorBearMild;
    return AppColors.sectorBearStrong;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Sector Heatmap',
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 3,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 2,
            children: _sectors.map((s) {
              final (name, pct) = s;
              return Container(
                decoration: BoxDecoration(
                  color: _heatColor(pct),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(name,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700)),
                    Text(
                      '${pct >= 0 ? '+' : ''}${pct.toStringAsFixed(1)}%',
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _MoversSection extends StatelessWidget {
  final WidgetRef ref;
  const _MoversSection({required this.ref});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Top Gainers', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          _MoversTable(provider: topGainersProvider),
          const SizedBox(height: 20),
          Text('Top Losers', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          _MoversTable(provider: topLosersProvider),
        ],
      ),
    );
  }
}

class _MoversTable extends ConsumerWidget {
  final ProviderBase<AsyncValue<List<StockQuote>>> provider;
  const _MoversTable({required this.provider});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(provider);
    return async.when(
      loading: () => const SizedBox(
          height: 200,
          child: Center(
              child: CircularProgressIndicator(color: AppColors.primary))),
      error: (_, __) =>
          const Text('Could not load data', style: TextStyle(color: AppColors.textSecondaryDark)),
      data: (quotes) {
        if (quotes.isEmpty) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Text('No data available',
                style: TextStyle(color: AppColors.textSecondaryDark)),
          );
        }
        return Column(
          children: quotes
              .take(5)
              .map((q) => _MoverRow(quote: q))
              .toList(),
        );
      },
    );
  }
}

class _MoverRow extends StatelessWidget {
  final StockQuote quote;
  const _MoverRow({required this.quote});

  @override
  Widget build(BuildContext context) {
    final isPos = quote.isPositive;
    final color = isPos ? AppColors.bull : AppColors.bear;
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(quote.symbol,
                    style: GoogleFonts.jetBrainsMono(
                        fontSize: 13, fontWeight: FontWeight.w700)),
                Text(quote.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 11, color: AppColors.textSecondaryDark)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(NumberFormatter.formatPrice(quote.price),
                  style: GoogleFonts.jetBrainsMono(
                      fontSize: 13, fontWeight: FontWeight.w700)),
              Row(
                children: [
                  Icon(isPos ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                      color: color, size: 16),
                  Text(
                    '${isPos ? '+' : ''}${quote.changePercent.toStringAsFixed(2)}%',
                    style: GoogleFonts.jetBrainsMono(
                        color: color,
                        fontSize: 11,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
