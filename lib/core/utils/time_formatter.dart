// lib/core/utils/time_formatter.dart

class TimeFormatter {
  TimeFormatter._();

  static String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final diff = now.difference(dateTime);

    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) {
      return '${diff.inMinutes}m ago';
    }
    if (diff.inHours < 24) {
      return '${diff.inHours}h ago';
    }
    if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    }
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  static String timeAgoFromUnix(int unixTimestamp) {
    final dt = DateTime.fromMillisecondsSinceEpoch(unixTimestamp * 1000);
    return timeAgo(dt);
  }

  static int readingTimeMinutes(String text) {
    const wordsPerMinute = 200;
    final wordCount = text.trim().split(RegExp(r'\s+')).length;
    return (wordCount / wordsPerMinute).ceil().clamp(1, 60);
  }

  /// Returns true if current IST time is within market hours (9:15–3:30 PM Mon–Fri)
  static bool isMarketOpen() {
    // IST is UTC+5:30
    final now = DateTime.now().toUtc().add(const Duration(hours: 5, minutes: 30));
    if (now.weekday == DateTime.saturday || now.weekday == DateTime.sunday) {
      return false;
    }
    final marketStart = DateTime(now.year, now.month, now.day, 9, 15);
    final marketEnd = DateTime(now.year, now.month, now.day, 15, 30);
    return now.isAfter(marketStart) && now.isBefore(marketEnd);
  }

  static String marketStatusLabel() {
    if (isMarketOpen()) return 'NSE Open';
    final now = DateTime.now().toUtc().add(const Duration(hours: 5, minutes: 30));
    if (now.weekday == DateTime.saturday || now.weekday == DateTime.sunday) {
      return 'Market Closed (Weekend)';
    }
    final marketStart = DateTime(now.year, now.month, now.day, 9, 15);
    if (now.isBefore(marketStart)) return 'Pre-Market';
    return 'Market Closed';
  }

  static String formatDate(DateTime dt) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }
}
