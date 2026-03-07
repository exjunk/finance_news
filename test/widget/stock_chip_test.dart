// test/widget/stock_chip_test.dart
import 'package:finswipe/presentation/widgets/stock_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/app_wrapper.dart';

void main() {
  group('StockChip', () {
    testWidgets('renders the ticker symbol text', (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          const Scaffold(
            body: Center(child: StockChip(symbol: 'RELIANCE')),
          ),
        ),
      );
      expect(find.text('RELIANCE'), findsOneWidget);
    });

    testWidgets('renders change percent when provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          const Scaffold(
            body: Center(
              child: StockChip(symbol: 'TCS', changePercent: 2.5),
            ),
          ),
        ),
      );
      expect(find.text('TCS'), findsOneWidget);
      expect(find.text('+2.5%'), findsOneWidget);
    });

    testWidgets('renders negative change percent without + sign',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          const Scaffold(
            body: Center(
              child: StockChip(symbol: 'INFY', changePercent: -1.2),
            ),
          ),
        ),
      );
      expect(find.text('INFY'), findsOneWidget);
      expect(find.text('-1.2%'), findsOneWidget);
    });

    testWidgets('does not render percent text when changePercent is null',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          const Scaffold(
            body: Center(child: StockChip(symbol: 'HDFC')),
          ),
        ),
      );
      expect(find.text('HDFC'), findsOneWidget);
      // No percent text should be present
      expect(find.textContaining('%'), findsNothing);
    });
  });
}
