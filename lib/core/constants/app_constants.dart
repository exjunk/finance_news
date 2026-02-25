// lib/core/constants/app_constants.dart

class AppConstants {
  AppConstants._();

  static const String appName = 'StockSwipe';
  static const String appTagline = 'Swipe Through the Market';
  static const String appVersion = '1.0.0';
  static const String githubUrl = 'https://github.com/stockswipe/app';
  static const String playStoreUrl =
      'https://play.google.com/store/apps/details?id=com.stockswipe.app';

  // Refresh intervals
  static const int newsRefreshMinutes = 15;
  static const int marketRefreshSeconds = 60;

  // Swipe card config
  static const double cardWidthFactor = 0.88;
  static const double cardHeightFactor = 0.72;
  static const double cardBorderRadius = 24.0;
  static const int maxSwipeAngleDegrees = 15;

  // Article filters
  static const List<String> filterCategories = [
    'All',
    'IPO',
    'Results',
    'Macro',
    'Crypto',
    'Policy',
    'Smallcap',
    'Largecap',
  ];

  // Reading time
  static const int wordsPerMinute = 200;

  // Undo dismiss duration
  static const int undoDismissSeconds = 3;

  // App rating prompt threshold (cards swiped)
  static const int appRatingCardThreshold = 20;

  // Text scaling limit
  static const double maxTextScaleFactor = 1.3;

  // Network timeout threshold for slow connection warning
  static const int slowConnectionMs = 10000;

  // Article age limit for RSS
  static const int articleAgeLimitDays = 7;

  // Notification IDs
  static const int marketOpenNotificationId = 1001;
  static const int marketCloseNotificationId = 1002;

  // Notification schedule (IST = UTC+5:30)
  static const int marketOpenHourIST = 9;
  static const int marketOpenMinuteIST = 0;
  static const int marketCloseHourIST = 15;
  static const int marketCloseMinuteIST = 35;

  // Market hours in IST
  static const int marketStartHourIST = 9;
  static const int marketStartMinuteIST = 15;
  static const int marketEndHourIST = 15;
  static const int marketEndMinuteIST = 30;

  // Source color keys
  static const String sourceEtMarkets = 'ET Markets';
  static const String sourceMoneyControl = 'Moneycontrol';
  static const String sourceLivemint = 'Livemint';
  static const String sourceBusinessStandard = 'Business Standard';
  static const String sourceNse = 'NSE India';
  static const String sourceBse = 'BSE India';

  // SharedPreferences keys
  static const String prefFirstLaunch = 'first_launch';
  static const String prefDarkMode = 'dark_mode';
  static const String prefAlphaVantageKey = 'alpha_vantage_key';
  static const String prefGnewsKey = 'gnews_key';
  static const String prefNewsDataKey = 'newsdata_key';
  static const String prefNotifMarketOpen = 'notif_market_open';
  static const String prefNotifMarketClose = 'notif_market_close';
  static const String prefFavoriteTopics = 'favorite_topics';
  static const String prefCardsSwiped = 'cards_swiped';
  static const String prefRefreshInterval = 'refresh_interval';

  // Hardcoded fallback articles (used when all APIs fail)
  static const int fallbackArticleCount = 5;

  // Scroll threshold for scroll-to-top FAB
  static const double scrollToTopThreshold = 300.0;
}
