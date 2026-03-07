// test/widget/sentiment_badge_test.dart
import 'package:finswipe/core/utils/sentiment_analyzer.dart';
import 'package:finswipe/presentation/widgets/sentiment_badge.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../helpers/app_wrapper.dart';

void main() {
  group('SentimentBadge', () {
    Future<void> pumpBadge(
      WidgetTester tester,
      Sentiment sentiment, {
      bool compact = false,
    }) async {
      await tester.pumpWidget(
        makeTestableWidget(
          Scaffold(
            body: Center(
              child: SentimentBadge(sentiment: sentiment, compact: compact),
            ),
          ),
        ),
      );
    }

    testWidgets('renders BULLISH label for bull sentiment',
        (WidgetTester tester) async {
      await pumpBadge(tester, Sentiment.bull);
      expect(find.text('BULLISH'), findsOneWidget);
      expect(find.text('🟢'), findsOneWidget);
    });

    testWidgets('renders BEARISH label for bear sentiment',
        (WidgetTester tester) async {
      await pumpBadge(tester, Sentiment.bear);
      expect(find.text('BEARISH'), findsOneWidget);
      expect(find.text('🔴'), findsOneWidget);
    });

    testWidgets('renders NEUTRAL label for neutral sentiment',
        (WidgetTester tester) async {
      await pumpBadge(tester, Sentiment.neutral);
      expect(find.text('NEUTRAL'), findsOneWidget);
      expect(find.text('🟡'), findsOneWidget);
    });

    testWidgets('compact mode uses smaller font size (10)',
        (WidgetTester tester) async {
      await pumpBadge(tester, Sentiment.bull, compact: true);

      final textWidget = tester.widgetList<Text>(find.text('BULLISH')).first;
      expect(textWidget.style?.fontSize, equals(10));
    });

    testWidgets('non-compact mode uses default font size (11)',
        (WidgetTester tester) async {
      await pumpBadge(tester, Sentiment.bull);

      final textWidget = tester.widgetList<Text>(find.text('BULLISH')).first;
      expect(textWidget.style?.fontSize, equals(11));
    });
  });
}
