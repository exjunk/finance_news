// test/unit/sentiment_analyzer_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:finswipe/core/utils/sentiment_analyzer.dart';

void main() {
  group('SentimentAnalyzer', () {
    test('detects bullish headline with strong buy signal', () {
      final result = SentimentAnalyzer.analyze(
          'Nifty surges to record high as banking stocks rally');
      expect(result, Sentiment.bull);
    });

    test('detects bearish headline with crash signal', () {
      final result =
          SentimentAnalyzer.analyze('Sensex crashes 800 points on FII sell-off');
      expect(result, Sentiment.bear);
    });

    test('returns neutral for no strong signal', () {
      final result = SentimentAnalyzer.analyze(
          'Nifty closes flat as traders await RBI policy decision');
      expect(result, Sentiment.neutral);
    });

    test('detects bearish from downgrade keyword', () {
      final result = SentimentAnalyzer.analyze(
          'Analyst downgrades Infosys citing weak demand outlook');
      expect(result, Sentiment.bear);
    });

    test('detects bullish from earnings beat', () {
      final result = SentimentAnalyzer.analyze(
          'TCS beats Q3 estimates, reports record profit growth');
      expect(result, Sentiment.bull);
    });

    test('detects bullish from IPO gain', () {
      final result = SentimentAnalyzer.analyze(
          'New IPO rises strongly on debut with 45% gains');
      expect(result, Sentiment.bull);
    });

    test('detects bearish from debt concern', () {
      final result = SentimentAnalyzer.analyze(
          'Company faces debt crisis, losses mount amid probe');
      expect(result, Sentiment.bear);
    });

    test('title weight 2x makes bull win over weak body bear', () {
      final result = SentimentAnalyzer.analyze(
        'Market rallies strongly on positive FII data',
        description: 'Some analysts feel cautious',
      );
      expect(result, Sentiment.bull);
    });

    test('sentimentLabel returns correct string', () {
      expect(SentimentAnalyzer.sentimentLabel(Sentiment.bull), 'Bullish');
      expect(SentimentAnalyzer.sentimentLabel(Sentiment.bear), 'Bearish');
      expect(SentimentAnalyzer.sentimentLabel(Sentiment.neutral), 'Neutral');
    });

    test('detects bullish dividend announcement', () {
      final result = SentimentAnalyzer.analyze(
          'HDFC Bank announces special dividend; shares climb 3%');
      expect(result, Sentiment.bull);
    });
  });
}
