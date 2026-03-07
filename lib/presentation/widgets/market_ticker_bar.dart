// lib/presentation/widgets/market_ticker_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/number_formatter.dart';
import '../providers/market_provider.dart';

class MarketTickerBar extends ConsumerStatefulWidget {
  const MarketTickerBar({super.key});

  @override
  ConsumerState<MarketTickerBar> createState() => _MarketTickerBarState();
}

class _MarketTickerBarState extends ConsumerState<MarketTickerBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final indicesAsync = ref.watch(marketIndicesProvider);

    return Container(
      height: 36,
      color: Theme.of(context).colorScheme.surface,
      child: indicesAsync.when(
        loading: () => _buildStaticTicker(),
        error: (_, __) => _buildStaticTicker(),
        data: (indices) {
          if (indices.isEmpty) return _buildStaticTicker();

          final items = indices
              .map((index) => _TickerItem(
                    label: index.name,
                    value: NumberFormatter.formatIndex(index.value),
                    change: index.changePercent,
                  ))
              .toList();

          return _ScrollingTicker(items: items, controller: _controller);
        },
      ),
    );
  }

  Widget _buildStaticTicker() {
    final items = [
      const _TickerItem(label: 'NIFTY 50', value: '--', change: 0),
      const _TickerItem(label: 'SENSEX', value: '--', change: 0),
      const _TickerItem(label: 'BANK NIFTY', value: '--', change: 0),
    ];
    return _ScrollingTicker(items: items, controller: _controller);
  }
}

class _TickerItem {
  final String label;
  final String value;
  final double change;

  const _TickerItem(
      {required this.label, required this.value, required this.change});
}

class _ScrollingTicker extends StatelessWidget {
  final List<_TickerItem> items;
  final AnimationController controller;

  const _ScrollingTicker({required this.items, required this.controller});

  @override
  Widget build(BuildContext context) {
    // Repeat items for seamless looping
    final repeated = [...items, ...items, ...items];

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return ClipRect(
          child: OverflowBox(
            maxWidth: double.infinity,
            child: Transform.translate(
              offset: Offset(
                -controller.value *
                    (items.length * 180.0), // Move items pixel-width per cycle
                0,
              ),
              child: Row(
                children: repeated
                    .map((item) => _buildItem(context, item))
                    .toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildItem(BuildContext context, _TickerItem item) {
    final isPos = item.change >= 0;
    final changeColor = isPos ? AppColors.bull : AppColors.bear;
    return Container(
      width: 180,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              item.label,
              style: GoogleFonts.dmSans(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              item.value,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              isPos ? Icons.arrow_drop_up : Icons.arrow_drop_down,
              color: changeColor,
              size: 16,
            ),
            Text(
              '${isPos ? '+' : ''}${item.change.toStringAsFixed(2)}%',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 10,
                color: changeColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            Container(
              width: 1,
              height: 16,
              margin: const EdgeInsets.only(left: 12),
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withOpacity(0.1),
            ),
          ],
        ),
      ),
    );
  }
}
