// lib/core/utils/sentiment_analyzer.dart

enum Sentiment { bull, bear, neutral }

class SentimentAnalyzer {
  SentimentAnalyzer._();

  static const List<String> bullishKeywords = [
    'surge', 'surge', 'surges', 'rally', 'rallies', 'gain', 'gains', 'gained',
    'jump', 'jumps', 'jumped', 'soar', 'soars', 'soared', 'climb', 'climbs',
    'climbed', 'rise', 'rises', 'rose', 'risen', 'profit', 'profits',
    'beat', 'beats', 'beating', 'record', 'high', 'highs', 'growth', 'grew',
    'bullish', 'upgrade', 'upgraded', 'positive', 'strong', 'strength',
    'boost', 'boosted', 'outperform', 'outperforms', 'recovery', 'recovers',
    'breakout', 'buy', 'dividend', 'bonus', 'acquisition', 'expansion',
    'target', 'up', 'upside', 'winning', 'winner', 'elevated', 'peak',
    'top', 'best', 'outpace', 'milestone', 'boom', 'booming', 'robust',
    'healthy', 'solid', 'strong', 'accelerate', 'acceleration', 'above',
    'exceed', 'exceeds', 'exceeded', 'momentum', 'opportunity', 'potential',
    'optimistic', 'optimism', 'confident', 'confidence', 'recovery',
  ];

  static const List<String> bearishKeywords = [
    'fall', 'falls', 'fell', 'fallen', 'drop', 'drops', 'dropped', 'crash',
    'crashes', 'crashed', 'plunge', 'plunges', 'plunged', 'sink', 'sinks',
    'sank', 'decline', 'declines', 'declined', 'loss', 'losses', 'below',
    'concern', 'concerns', 'worry', 'worries', 'worried', 'sell-off',
    'selloff', 'cut', 'cuts', 'downgrade', 'downgraded', 'weak', 'weakness',
    'bear', 'bearish', 'negative', 'miss', 'misses', 'missed', 'slump',
    'slumps', 'slumped', 'tumble', 'tumbles', 'tumbled', 'retreat',
    'retreats', 'retreated', 'caution', 'risk', 'risks', 'debt', 'fraud',
    'probe', 'penalty', 'penalties', 'fine', 'fines', 'warning', 'down',
    'downside', 'losing', 'loser', 'low', 'lows', 'bottom', 'worst',
    'poor', 'under', 'underperform', 'slow', 'slowdown', 'contraction',
    'contract', 'recession', 'pressure', 'pressure', 'stressed', 'stress',
    'volatile', 'volatility', 'uncertainty', 'uncertain', 'fear', 'fears',
    'correction', 'sell', 'selling', 'dump', 'dumping', 'crisis',
  ];

  /// Analyzes the sentiment of a headline + optional description.
  /// Title matches are weighted 2x vs description matches.
  /// Returns Neutral if |bullScore - bearScore| < 2.
  static Sentiment analyze(String title, {String? description}) {
    int bullScore = _scoreText(title) * 2;
    int bearScore = _scoreText(title, bull: false) * 2;

    if (description != null && description.isNotEmpty) {
      bullScore += _scoreText(description);
      bearScore += _scoreText(description, bull: false);
    }

    final diff = bullScore - bearScore;
    if (diff.abs() < 2) return Sentiment.neutral;
    return diff > 0 ? Sentiment.bull : Sentiment.bear;
  }

  static int _scoreText(String text, {bool bull = true}) {
    final lower = text.toLowerCase();
    final words = lower.split(RegExp(r'\W+'));
    final keywords = bull ? bullishKeywords : bearishKeywords;
    int score = 0;
    for (final word in words) {
      if (keywords.contains(word)) score++;
    }
    return score;
  }

  static String sentimentLabel(Sentiment s) {
    switch (s) {
      case Sentiment.bull:
        return 'Bullish';
      case Sentiment.bear:
        return 'Bearish';
      case Sentiment.neutral:
        return 'Neutral';
    }
  }

  static String sentimentEmoji(Sentiment s) {
    switch (s) {
      case Sentiment.bull:
        return '🟢';
      case Sentiment.bear:
        return '🔴';
      case Sentiment.neutral:
        return '🟡';
    }
  }
}
