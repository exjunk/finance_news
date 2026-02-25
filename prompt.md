## MASTER PROMPT

You are a senior full-stack mobile developer. Build a complete, production-ready Android (primary) + iOS (secondary) mobile application called **"StockSwipe"** — an Indian stock market & finance news app with a Tinder-style swipe UI. Follow every instruction below precisely with no placeholders, no TODOs, and no incomplete code. Every file must be fully implemented.

---

## 1. PROJECT OVERVIEW

**App Name:** StockSwipe  
**Tagline:** "Swipe Through the Market"  
**Platform:** Flutter (Dart) — targets Android first (Play Store publish), iOS secondary  
**State Management:** Riverpod  
**Local Database:** Drift (SQLite wrapper for Flutter)  
**Architecture:** Clean Architecture (data → domain → presentation layers)  
**Theme:** Minimalist dark-first design with gold/amber accents — feels like a Bloomberg terminal crossed with a modern fintech app  

---

## 2. FREE APIs TO USE (NO PAID KEYS REQUIRED)

Implement ALL of the following. Each must have its own datasource class with error handling and retry logic.

### 2a. News APIs (free tiers, no credit card required)
- **GNews API** — `https://gnews.io/api/v4/search?q=india+stock+market&lang=en&country=in&token=YOUR_TOKEN`
  - Register free at gnews.io (100 requests/day free)
  - Categories: market, economy, business, NSE, BSE, Sensex, Nifty
- **NewsData.io** — `https://newsdata.io/api/1/news?apikey=YOUR_KEY&country=in&category=business`
  - Free: 200 requests/day
- **TheNewsAPI** — `https://api.thenewsapi.com/v1/news/top?api_token=YOUR_TOKEN&locale=in&categories=business`
  - Free: 100 requests/day
- **RSS Fallback (no key needed):**
  - Economic Times Markets RSS: `https://economictimes.indiatimes.com/markets/rss.cms`
  - MoneyControl RSS: `https://www.moneycontrol.com/rss/buzzingstocks.xml`
  - Livemint: `https://www.livemint.com/rss/markets`
  - Business Standard: `https://www.business-standard.com/rss/markets-106.rss`
  - NSE India news page (scrape public HTML)
  - Use the `webfeed` or `dart_rss` Flutter package to parse RSS
  - RSS feeds require NO API key and have NO rate limits

### 2b. Stock Price APIs (free)
- **Yahoo Finance (unofficial)** via `yfinance` wrapper or direct URL:
  - `https://query1.finance.yahoo.com/v8/finance/chart/{SYMBOL}.NS?interval=1d&range=1mo`
  - Symbols: RELIANCE.NS, TCS.NS, INFY.NS, HDFCBANK.NS, ICICIBANK.NS, WIPRO.NS, etc.
- **Alpha Vantage Free Tier** — `https://www.alphavantage.co/query?function=GLOBAL_QUOTE&symbol=RELIANCE.BSE&apikey=demo`
  - Free: 25 requests/day (use demo key for testing, prompt user to enter their own free key)
- **Finnhub Free** — `https://finnhub.io/api/v1/quote?symbol=NSE:RELIANCE&token=YOUR_FREE_TOKEN`
  - Free tier available at finnhub.io
- **NSE India Public Endpoints (no key):**
  - `https://www.nseindia.com/api/equity-stockIndices?index=NIFTY%2050`
  - `https://www.nseindia.com/api/market-status`
  - These require proper headers: `User-Agent`, `Accept`, `Referer`

### 2c. Currency & Macro Data
- **ExchangeRate-API free tier** — `https://open.exchangerate-api.com/v6/latest/USD` (no key needed)
- **RBI (Reserve Bank of India) public data** — `https://rbidbie.rbi.org.in/` (public portal)
- **World Bank Open Data** — `https://api.worldbank.org/v2/country/IN/indicator/FP.CPI.TOTL.ZG?format=json`

---

## 3. APP FEATURES (IMPLEMENT ALL)

### Core Features
1. **Swipe Card Feed** — Main screen shows news cards in a swipeable stack
   - Swipe RIGHT → Save article to "Watchlist" (liked/bookmarked)
   - Swipe LEFT → Dismiss (mark as read, never show again in this session)
   - Swipe UP → Open full article in an in-app WebView
   - Tap card → Expand to detail view with full summary, related stocks, sentiment badge
   - Card stack shows 3 cards with parallax depth effect (back cards slightly scaled down and blurred)

2. **Smart Card Content** — Each card displays:
   - Headline (max 2 lines, large bold typography)
   - Source logo + source name + time ago ("ET Markets • 2h ago")
   - Category pill badge (e.g., "NSE", "Results", "IPO", "Macro", "Crypto")
   - Sentiment indicator: Bull 🟢 / Bear 🔴 / Neutral 🟡 — determined by simple keyword analysis on the headline
   - Relevant stock ticker chips if detected (e.g., "RELIANCE +1.2%")
   - Background gradient derived from the article's source color identity
   - Hero image if available (with shimmer loading placeholder)
   - Reading time estimate ("~2 min read")

3. **Market Ticker Bar** — Persistent top bar showing live scrolling prices:
   - NIFTY 50, SENSEX, BANK NIFTY, USD/INR, Gold (MCX)
   - Auto-refreshes every 60 seconds
   - Green/red color with directional arrows

4. **Watchlist Tab** — All right-swiped (saved) articles
   - Grouped by date
   - Each item shows title, source, sentiment tag
   - Swipe to delete from watchlist
   - Persist across sessions using Drift (SQLite)

5. **Market Pulse Tab** — Dashboard screen showing:
   - Top Gainers / Top Losers table (pull from NSE public API or Yahoo Finance)
   - Market status indicator (Open / Pre-open / Closed) with next open time
   - Sector heatmap — color-coded boxes showing IT, Banking, Pharma, Auto, FMCG performance
   - 52-week high/low movers
   - FII/DII activity summary if available from public sources
   - Quick stat cards: Advance/Decline ratio, Market Cap total

6. **Search & Filter**
   - Search bar to find articles by keyword, company name, or ticker
   - Filter chips: IPO | Results | Policy | Global | Crypto | Smallcap | Largecap | Economy
   - Category-specific feeds reload the swipe deck with filtered content

7. **Notifications (Local)**
   - Daily market opening reminder at 9:00 AM IST
   - Daily market closing digest at 3:30 PM IST (summary of top movers)
   - Use `flutter_local_notifications` package

8. **Onboarding Flow** (first launch only)
   - 3 splash screens explaining the swipe mechanics
   - User selects favorite topics (IT, Banking, IPO, Macro, etc.)
   - API key entry screen for Alpha Vantage (pre-filled with `demo`, user can update)
   - Preferences saved in SharedPreferences

9. **Settings Screen**
   - Dark/Light mode toggle (dark is default)
   - Notification preferences
   - Clear cache / Clear read history
   - API key management
   - About screen with app version, licenses, GitHub link placeholder
   - "Rate the App" link (points to Play Store page)

10. **Offline Mode**
    - Last fetched articles cached in Drift database
    - If no internet, show cached content with "Offline — showing cached news" banner
    - Graceful error states with retry buttons

11. **Sentiment Engine (local, no ML library needed)**
    - Keyword dictionary approach:
      - Bullish keywords: surges, rallies, gains, beats, profit, growth, record, high, up, bullish, positive
      - Bearish keywords: falls, drops, crash, loss, decline, weak, below, concern, sell-off, cut, downgrade
    - Score each headline → return Bull / Bear / Neutral
    - Show as colored badge on card and in detail view

12. **Pull-to-Refresh** on all list screens  
13. **Haptic Feedback** on swipe actions  
14. **Share Article** via native share sheet  
15. **Deep Link Support** for article URLs  

---

## 4. DATABASE SCHEMA (Drift / SQLite)

Create a Drift database with the following tables:

```dart
// articles table
class Articles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get articleId => text().unique()(); // hash of URL
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get url => text()();
  TextColumn get imageUrl => text().nullable()();
  TextColumn get source => text()();
  TextColumn get category => text()();
  TextColumn get sentiment => text()(); // bull | bear | neutral
  TextColumn get relatedTickers => text().nullable()(); // JSON array string
  IntColumn get publishedAt => integer()(); // unix timestamp
  IntColumn get fetchedAt => integer()(); // unix timestamp
  BoolColumn get isRead => boolean().withDefault(const Constant(false))();
  BoolColumn get isSaved => boolean().withDefault(const Constant(false))();
  BoolColumn get isDismissed => boolean().withDefault(const Constant(false))();
}

// market_snapshots table  
class MarketSnapshots extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get symbol => text()();
  TextColumn get name => text()();
  RealColumn get price => real()();
  RealColumn get change => real()();
  RealColumn get changePercent => real()();
  IntColumn get snapshotAt => integer()();
}

// user_preferences table
class UserPreferences extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get key => text().unique()();
  TextColumn get value => text()();
}

// read_history table (for deduplication)
class ReadHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get articleId => text().unique()();
  IntColumn get readAt => integer()();
}
```

Write full DAO classes for each table with all CRUD operations.

---

## 5. FOLDER STRUCTURE

```
lib/
├── main.dart
├── app.dart                          # MaterialApp setup, theme, routing
├── core/
│   ├── constants/
│   │   ├── api_constants.dart        # All API URLs, endpoints
│   │   ├── app_constants.dart        # App-wide constants
│   │   └── ticker_symbols.dart       # NSE/BSE symbols list
│   ├── theme/
│   │   ├── app_theme.dart            # Dark + Light ThemeData
│   │   ├── app_colors.dart           # Color palette
│   │   └── app_typography.dart       # Text styles
│   ├── utils/
│   │   ├── sentiment_analyzer.dart   # Keyword-based sentiment
│   │   ├── ticker_extractor.dart     # Extract stock tickers from text
│   │   ├── time_formatter.dart       # "2h ago" formatting
│   │   ├── number_formatter.dart     # Indian number formatting (₹1.2Cr)
│   │   └── connectivity_checker.dart
│   ├── errors/
│   │   ├── failures.dart
│   │   └── exceptions.dart
│   └── network/
│       └── dio_client.dart           # Dio HTTP client with interceptors
├── data/
│   ├── datasources/
│   │   ├── remote/
│   │   │   ├── gnews_datasource.dart
│   │   │   ├── newsdata_datasource.dart
│   │   │   ├── rss_datasource.dart   # Parses all RSS feeds
│   │   │   ├── yahoo_finance_datasource.dart
│   │   │   ├── nse_datasource.dart   # NSE India public API
│   │   │   └── exchange_rate_datasource.dart
│   │   └── local/
│   │       ├── database.dart         # Drift database definition
│   │       ├── daos/
│   │       │   ├── articles_dao.dart
│   │       │   ├── market_dao.dart
│   │       │   └── preferences_dao.dart
│   │       └── local_datasource.dart
│   ├── models/
│   │   ├── article_model.dart        # with fromJson, toJson, fromRss
│   │   ├── stock_model.dart
│   │   └── market_index_model.dart
│   └── repositories/
│       ├── news_repository_impl.dart
│       └── market_repository_impl.dart
├── domain/
│   ├── entities/
│   │   ├── article.dart
│   │   ├── stock_quote.dart
│   │   └── market_index.dart
│   ├── repositories/
│   │   ├── news_repository.dart      # Abstract interface
│   │   └── market_repository.dart
│   └── usecases/
│       ├── get_news_feed.dart
│       ├── save_article.dart
│       ├── dismiss_article.dart
│       ├── get_saved_articles.dart
│       ├── get_market_indices.dart
│       ├── get_top_movers.dart
│       └── search_articles.dart
├── presentation/
│   ├── providers/                    # Riverpod providers
│   │   ├── news_provider.dart
│   │   ├── market_provider.dart
│   │   ├── watchlist_provider.dart
│   │   └── preferences_provider.dart
│   ├── screens/
│   │   ├── splash/
│   │   │   └── splash_screen.dart
│   │   ├── onboarding/
│   │   │   └── onboarding_screen.dart
│   │   ├── home/
│   │   │   ├── home_screen.dart      # Bottom nav host
│   │   │   ├── swipe_feed/
│   │   │   │   ├── swipe_feed_screen.dart
│   │   │   │   ├── news_card.dart    # The main swipe card widget
│   │   │   │   ├── swipe_card_stack.dart  # Stack with depth effect
│   │   │   │   └── swipe_action_overlay.dart  # Like/dislike overlays
│   │   │   ├── watchlist/
│   │   │   │   └── watchlist_screen.dart
│   │   │   ├── market_pulse/
│   │   │   │   ├── market_pulse_screen.dart
│   │   │   │   ├── sector_heatmap.dart
│   │   │   │   └── movers_table.dart
│   │   │   └── settings/
│   │   │       └── settings_screen.dart
│   │   ├── article_detail/
│   │   │   └── article_detail_screen.dart  # WebView + summary
│   │   └── search/
│   │       └── search_screen.dart
│   └── widgets/
│       ├── market_ticker_bar.dart    # Scrolling price ticker
│       ├── sentiment_badge.dart
│       ├── stock_chip.dart
│       ├── shimmer_card.dart         # Loading skeleton
│       ├── error_view.dart
│       ├── empty_state_view.dart
│       └── offline_banner.dart
└── injection_container.dart          # Dependency injection setup
```

---

## 6. UI DESIGN SYSTEM

### Color Palette
```dart
// Dark Theme (primary)
background: Color(0xFF0A0A0F)       // Near-black with blue tint
surface: Color(0xFF13131A)          // Card surface
surfaceElevated: Color(0xFF1C1C27)  // Elevated elements
primary: Color(0xFFFFB300)          // Amber gold — brand color
primaryLight: Color(0xFFFFCC02)     
bull: Color(0xFF00C853)             // Green for gains
bear: Color(0xFFFF1744)             // Red for losses
neutral: Color(0xFFFFAB00)          // Amber for neutral
textPrimary: Color(0xFFF5F5F5)
textSecondary: Color(0xFF9E9E9E)
border: Color(0xFF2A2A3A)

// Light Theme (secondary)
background: Color(0xFFF8F9FA)
surface: Colors.white
primary: Color(0xFFFFB300)
```

### Typography
Use **Google Fonts** package. Font pairing:
- Display / Headlines: `Clash Display` or `Space Grotesk Bold` — for card titles, big numbers
- Body: `DM Sans` — for descriptions, metadata
- Monospace (prices): `JetBrains Mono` — for stock prices, percentages
- Load via `google_fonts` package

### Card Design
The swipe card must:
- Be 88% screen width, 72% screen height
- Have rounded corners: 24px
- Show a subtle gradient overlay at bottom for text legibility
- Background: either the article's source brand color (map each source to a color) OR a blurred version of the article image
- Drop shadow: `BoxShadow(blurRadius: 32, spreadRadius: -8, color: Colors.black54)`
- Category pill in top-left corner
- Sentiment badge (bull/bear/neutral) in top-right corner
- Source row at bottom: logo + name + time
- Swipe RIGHT: green "SAVE" overlay with bookmark icon fades in on left side of card
- Swipe LEFT: red "SKIP" overlay with X icon fades in on right side of card
- Swipe UP: blue "READ" overlay with eye icon
- Implement using `flutter_card_swiper` or `appinio_swiper` package

### Bottom Navigation
4 tabs with custom icons:
1. 🃏 Feed (home/swipe)
2. 📈 Markets (market pulse)  
3. 🔖 Saved (watchlist)
4. ⚙️ Settings

Use `BottomNavigationBar` with `type: BottomNavigationBarType.fixed`, custom icon sizes, gold selected color.

### Animations
- Card swipe: spring physics, rotation on drag (max 15°)
- Card stack: smooth scale transition when top card is removed
- Market ticker: continuous horizontal scroll
- Number changes: animate digit changes (use `AnimatedFlipCounter` or custom)
- Screen transitions: custom page route with slide+fade
- Skeleton shimmer on load (use `shimmer` package)
- Micro-interaction: thumb icon pulse on successful save

---

## 7. PUBSPEC.YAML — DEPENDENCIES

```yaml
name: stockswipe
description: Swipe through Indian market news
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'
  flutter: ">=3.10.0"

dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_riverpod: ^2.4.9
  riverpod_annotation: ^2.3.3

  # Navigation
  go_router: ^13.0.0

  # Network
  dio: ^5.4.0
  connectivity_plus: ^5.0.2
  webfeed: ^0.7.0              # RSS/Atom feed parsing

  # Database
  drift: ^2.14.1
  sqlite3_flutter_libs: ^0.5.15
  path_provider: ^2.1.2
  path: ^1.9.0

  # UI
  google_fonts: ^6.1.0
  appinio_swiper: ^2.0.2       # Tinder-style swipe cards
  shimmer: ^3.0.0
  cached_network_image: ^3.3.1
  flutter_svg: ^2.0.9
  lottie: ^3.0.0               # For empty state animations
  animated_flip_counter: ^0.3.2
  percent_indicator: ^4.2.3

  # Utilities
  shared_preferences: ^2.2.2
  flutter_local_notifications: ^16.3.0
  share_plus: ^7.2.1
  url_launcher: ^6.2.4
  webview_flutter: ^4.4.2
  intl: ^0.19.0
  crypto: ^3.0.3               # For article ID hashing
  html: ^0.15.4                # HTML parsing for RSS descriptions
  xml: ^6.4.2

  # Dev
dev_dependencies:
  flutter_test:
    sdk: flutter
  build_runner: ^2.4.8
  drift_dev: ^2.14.1
  riverpod_generator: ^2.3.9
  flutter_lints: ^3.0.1
```

---

## 8. NETWORK LAYER IMPLEMENTATION

### Dio Client Setup
```dart
// core/network/dio_client.dart
// Implement with:
// - BaseOptions with 30s timeout
// - LogInterceptor in debug mode
// - RetryInterceptor (3 attempts, exponential backoff)
// - Custom error handling interceptor that converts DioException to domain Failures
// - User-Agent header that mimics a real browser (for NSE API)
```

### RSS Aggregator
The RSS datasource must:
- Fetch all 4 RSS feeds in parallel using `Future.wait()`
- Deduplicate by URL hash
- Sort by publish date descending
- Filter out articles older than 7 days
- Return combined, deduplicated list

### Data Refresh Strategy
- News feed: refresh every 15 minutes (or on app foreground)
- Market data: refresh every 60 seconds when on Market Pulse tab
- Use `Timer.periodic` + `ref.onDispose` for cleanup in Riverpod
- Cache in Drift; show cached while fetching fresh

---

## 9. SENTIMENT ANALYSIS ENGINE

```dart
// core/utils/sentiment_analyzer.dart

class SentimentAnalyzer {
  static const bullishKeywords = [
    'surge', 'rally', 'gain', 'jump', 'soar', 'climb', 'rise', 'profit',
    'beat', 'record', 'high', 'growth', 'bullish', 'upgrade', 'positive',
    'strong', 'boost', 'outperform', 'recovery', 'breakout', 'buy',
    'dividend', 'bonus', 'acquisition', 'expansion', 'target', 'up'
  ];
  
  static const bearishKeywords = [
    'fall', 'drop', 'crash', 'plunge', 'sink', 'decline', 'loss', 'below',
    'concern', 'worry', 'sell-off', 'cut', 'downgrade', 'weak', 'bear',
    'negative', 'miss', 'slump', 'tumble', 'retreat', 'caution', 'risk',
    'debt', 'fraud', 'probe', 'penalty', 'fine', 'warning', 'down'
  ];

  static Sentiment analyze(String text) {
    // Implement scoring: count matches, return Bull/Bear/Neutral
    // Weight title matches 2x vs description matches
    // Return Neutral if |bullScore - bearScore| < 2
  }
}
```

### Ticker Extractor
```dart
// core/utils/ticker_extractor.dart
// Pre-load a Map<String, String> of company names + NSE symbols
// e.g., {'reliance': 'RELIANCE', 'tata motors': 'TATAMOTORS', ...}
// Scan article title + description for matches
// Return list of {symbol, currentPrice, changePercent} for matched tickers
// ~100 most common NSE large/mid cap names should be in the dictionary
```

---

## 10. NOTIFICATION SYSTEM

```dart
// Implement in a NotificationService class:
// 1. Initialize flutter_local_notifications on app start
// 2. Request permission on Android 13+
// 3. Schedule daily notification at 9:00 AM IST: "Market is Open 🔔 — Swipe today's top stories"
// 4. Schedule daily notification at 3:35 PM IST: "Market Closed 📊 — See how Nifty did today"
// 5. Allow user to toggle each notification type in Settings
// 6. Persist notification preferences in SharedPreferences
// 7. Re-schedule on app foreground (handle app restart)
```

---

## 11. ANDROID CONFIGURATION

### android/app/src/main/AndroidManifest.xml additions:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.VIBRATE"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
```

### App Identity
- Application ID: `com.stockswipe.app`
- App Name: `StockSwipe`
- Min SDK: 21 (Android 5.0)
- Target SDK: 34
- Compile SDK: 34

### App Icons
Create launcher icons using `flutter_launcher_icons` package:
- Design: Dark background (#0A0A0F) with a golden "S" made of a stock chart upward arrow
- Adaptive icon: foreground layer = icon, background = solid dark color
- Generate all required sizes for both Android and iOS

### Splash Screen
Use `flutter_native_splash` package:
- Dark background: #0A0A0F
- Center logo: white/gold version of the app icon
- No spinner (keep clean)

---

## 12. COMPLETE SCREEN SPECIFICATIONS

### Screen 1: Swipe Feed (Main)
```
Layout:
├── SafeArea
├── MarketTickerBar (height: 36px, scrolling horizontally)
├── Filter Chips Row (horizontal scroll: All | IPO | Results | Macro | Crypto | Policy)
├── Expanded → SwipeCardStack
│   ├── Card 3 (back): scale 0.90, translateY: -16px, opacity 0.5
│   ├── Card 2 (middle): scale 0.95, translateY: -8px, opacity 0.8
│   └── Card 1 (top): full size, draggable
└── Action Buttons Row (bottom): ❌ Skip | ⬆ Read | 💾 Save
     (Tapping buttons triggers programmatic swipe)
```

When deck runs out of cards:
- Show an animated empty state with Lottie animation of a chart
- "You're all caught up! Pull to refresh for more stories"
- Auto-reload after 60 seconds

### Screen 2: Market Pulse
```
Layout (scrollable):
├── Market Status Header ("NSE Open • Closes in 2h 34m")
├── Index Cards Row (NIFTY 50, SENSEX, BANK NIFTY) — horizontal scroll
├── Sector Heatmap Grid (3x3 grid of colored squares)
├── Top Gainers Table (top 5)
├── Top Losers Table (top 5)
├── Global Indices mini-section (DOW, NASDAQ, FTSE — from Yahoo Finance)
└── Advance/Decline Ratio bar
```

### Screen 3: Watchlist
```
Layout:
├── Header with saved count "💾 23 Saved Stories"
├── SearchBar (filter saved articles)
├── ListView grouped by date
│   └── ArticleListTile:
│       ├── Source + time
│       ├── Title (2 lines)
│       ├── Sentiment badge
│       └── Swipe-to-delete (red background, trash icon)
└── Empty state if no saved articles
```

### Screen 4: Settings
```
Layout (ListView):
├── Profile section (guest user, no auth required)
├── Appearance: Dark/Light toggle
├── Notifications: Market Open toggle | Market Close toggle
├── Data: Refresh interval selector | Clear cache button | Clear read history
├── API Keys: Alpha Vantage key input | GNews key input | NewsData key input
├── About: App version | Open source licenses | Rate app | Share app
└── Developer section: Data sources info, disclaimer
```

---

## 13. ADDITIONAL QUALITY FEATURES

### Real Developer Touches (implement all)
1. **Pull-to-refresh** with custom gold-colored `RefreshIndicator`
2. **Scroll-to-top** FAB that appears after scrolling 300px
3. **Haptic feedback**: `HapticFeedback.mediumImpact()` on right swipe, `HapticFeedback.lightImpact()` on left swipe
4. **Error boundaries**: every async widget wrapped in error handler showing a retry UI
5. **Loading skeletons**: pixel-perfect shimmer cards matching real card layout (not generic grey boxes)
6. **Indian number formatting**: ₹1.25 Cr, ₹45.3 L, not ₹1,250,000
7. **Market hours awareness**: Show "Market Closed" banner when time is outside 9:15 AM–3:30 PM IST on weekdays
8. **Dismiss undo**: After left-swipe, show a 3-second snackbar "Article dismissed. [Undo]"
9. **Reading time estimate**: `(wordCount / 200).ceil()` minutes
10. **Source color mapping**: ET Markets = orange, Moneycontrol = blue, Livemint = green, BSE = purple, etc.
11. **Card velocity detection**: fast swipe = instant dismiss; slow swipe = show overlay gradually
12. **App rating prompt**: Show after 20 cards swiped, using `in_app_review` package
13. **Keyboard handling**: search screen properly handles keyboard avoiding
14. **Safe area handling**: all screens respect notches, home indicators
15. **Text scaling**: max text scale of 1.3x to prevent layout breaks
16. **Network timeout feedback**: If request takes >10s, show "Slow connection" warning

---

## 14. ERROR HANDLING STRATEGY

Every network call must handle these cases explicitly:
- `NoInternetException` → show offline banner, load from cache
- `TimeoutException` → retry with exponential backoff (1s, 2s, 4s)
- `ApiRateLimitException` → switch to next available source gracefully (source rotation)
- `ParseException` → log error, skip malformed article, continue
- `EmptyResponseException` → show appropriate empty state

API source rotation logic:
```
If GNews fails → try NewsData.io → try RSS feeds → show cached data
If Yahoo Finance fails → try Alpha Vantage → try NSE API → show cached prices
```

---

## 15. TESTING

Write the following tests (use `flutter_test` and `mocktail`):

1. `test/unit/sentiment_analyzer_test.dart` — test 10 headlines with expected outcomes
2. `test/unit/ticker_extractor_test.dart` — test extraction from sample headlines
3. `test/unit/number_formatter_test.dart` — test Indian number formatting
4. `test/unit/news_repository_test.dart` — mock datasource, test aggregation logic
5. `test/widget/news_card_test.dart` — render a card with mock data, verify key elements

---

## 16. PLAY STORE PUBLISHING GUIDE

After building the app, generate this file at `PUBLISHING.md`:

```markdown
# StockSwipe — Play Store Publishing Guide

## Step 1: Create a Google Play Developer Account
1. Go to https://play.google.com/console
2. Pay one-time $25 registration fee
3. Complete identity verification
4. Accept Developer Distribution Agreement

## Step 2: Prepare Release Build
```bash
# Generate signing keystore (run ONCE, save keystore file securely)
keytool -genkey -v -keystore ~/stockswipe-release.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias stockswipe

# Add to android/key.properties:
storePassword=YOUR_PASSWORD
keyPassword=YOUR_PASSWORD
keyAlias=stockswipe
storeFile=/path/to/stockswipe-release.jks

# Update android/app/build.gradle to read key.properties
# (Code for this is included in the project)

# Build App Bundle (preferred over APK for Play Store)
flutter build appbundle --release

# Output: build/app/outputs/bundle/release/app-release.aab
```

## Step 3: Play Store Listing Assets Needed
- App icon: 512x512 PNG (no alpha)
- Feature graphic: 1024x500 PNG
- Screenshots: minimum 2, recommended 8 (phone 16:9 or 9:16)
- Short description: max 80 characters
  Suggested: "Swipe through Indian stock market news. Save or skip. Stay ahead."
- Full description: max 4000 characters (template provided below)
- Privacy Policy URL (required for apps accessing internet)
  Create a free privacy policy at https://privacypolicygenerator.info

## Step 4: App Content Rating
- Complete IARC questionnaire
- StockSwipe is rated: Everyone (no violence, no adult content, financial info only)

## Step 5: Pricing & Distribution
- Free app, no in-app purchases initially
- Available in: India (primary), worldwide

## Step 6: Create Release in Play Console
1. Create app → "StockSwipe"
2. Complete store listing
3. Upload AAB to Internal Testing first
4. Test on physical device via Play Store
5. Promote to Production
6. Submit for review (typically 1-3 days for new apps)

## Privacy Policy Template
Host this at a public URL (GitHub Pages works fine):
> StockSwipe does not collect personal data. All news is fetched from 
> publicly available sources. Stock prices are from public APIs. 
> User preferences are stored locally on device only. 
> We do not share any data with third parties.

## App Store Listing Description Template
StockSwipe makes staying on top of Indian stock market news as easy as swiping right.

📱 SWIPE THROUGH THE MARKET
Browse NSE/BSE news like never before. Right swipe to save. Left swipe to skip. Up swipe to read the full story.

📊 REAL-TIME MARKET DATA  
Live NIFTY 50, SENSEX, BANK NIFTY prices. Top gainers and losers. Sector heatmap. All in one place.

🎯 SMART SENTIMENT ANALYSIS
Every news card is automatically tagged as Bullish 🟢, Bearish 🔴, or Neutral 🟡.

🔖 YOUR PERSONAL WATCHLIST
Save articles to read later. All stored offline on your device.

📰 SOURCES YOU TRUST
Economic Times, Moneycontrol, Livemint, Business Standard — aggregated in one feed.

No login required. No subscription. Completely free.
```

---

## 17. FINAL IMPLEMENTATION CHECKLIST

Before declaring the app complete, verify:

- [ ] App runs on Android emulator API 28+ without crashes
- [ ] All 4 bottom nav tabs are functional  
- [ ] Swipe left, right, and up work on physical gesture and button tap
- [ ] Articles load from at least 2 sources (RSS as guaranteed fallback)
- [ ] Market prices display (even if delayed/cached)
- [ ] Watchlist persists after app restart
- [ ] Offline mode shows cached content
- [ ] Sentiment badge appears on every card
- [ ] Dark and light themes both look polished
- [ ] No debug banners in release build
- [ ] App icon and splash screen are custom (not Flutter default)
- [ ] All hardcoded API keys are moved to a `lib/core/constants/api_keys.dart` file with clear instructions to replace
- [ ] `flutter analyze` passes with no errors
- [ ] `flutter test` all tests pass
- [ ] Release APK/AAB builds without errors
- [ ] README.md includes setup instructions

---

## 18. STARTER DATA (HARDCODED FALLBACK)

If all API calls fail (for demo/testing), load this hardcoded dataset of 5 sample articles representing typical Indian finance news. This ensures the app is never completely empty during development.

---

## START BUILDING

Now implement the entire application following every specification above. Start with:

1. `pubspec.yaml` — full dependencies
2. `android/` — manifest, build.gradle, signing setup  
3. `lib/core/` — theme, constants, utilities
4. `lib/data/` — database, models, datasources, repositories
5. `lib/domain/` — entities, use cases
6. `lib/presentation/` — providers, screens, widgets
7. `lib/main.dart` and `lib/app.dart`
8. `test/` — all test files
9. `PUBLISHING.md` — complete publishing guide
10. `README.md` — setup and run instructions

Write every file completely. No stubs. No `// TODO`. No placeholder comments. Production-grade code only.
```