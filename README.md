# StockSwipe

> **Swipe Through the Market** — An Indian stock market & finance news app with a Tinder-style swipe UI.

## Features

- 🃏 **Swipe Feed** — RIGHT to save, LEFT to skip, UP to read
- 📈 **Live Market Data** — NIFTY 50, SENSEX, BANK NIFTY (auto-refresh 60s)
- 🎯 **Sentiment Analysis** — Bullish 🟢 / Bearish 🔴 / Neutral 🟡 on every article
- 🔖 **Watchlist** — Saved articles persisted offline with Drift/SQLite
- 📊 **Market Pulse** — Top gainers, losers, sector heatmap
- 🔍 **Search** — Full-text search through cached articles
- 🔔 **Notifications** — Daily market open/close reminders (IST)
- 📵 **Offline Mode** — Cached news always available

## Setup

### Prerequisites
- Flutter 3.10+ & Dart 3.0+
- Android SDK 21+ / iOS 12+

### 1. Clone & Install

```bash
cd /path/to/stockswipe
flutter pub get
```

### 2. Add API Keys (Optional but Recommended)

Edit `lib/core/constants/api_keys.dart`:

```dart
class ApiKeys {
  static const String gnews = 'YOUR_KEY';       // gnews.io — 100 req/day free
  static const String newsData = 'YOUR_KEY';    // newsdata.io — 200 req/day free
  static const String theNewsApi = 'YOUR_KEY';  // thenewsapi.com — 100 req/day free
  static const String alphaVantage = 'demo';    // alphavantage.co — 25 req/day free
  static const String finnhub = 'YOUR_KEY';     // finnhub.io — free tier
}
```

> **Note:** RSS feeds (ET Markets, Moneycontrol, Livemint, Business Standard) work **without any API key** and serve as a guaranteed fallback.

### 3. Generate Drift Database Code

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 4. Run

```bash
flutter run
```

### 5. Run Tests

```bash
flutter test
```

### 6. Analyze

```bash
flutter analyze
```

## Architecture

```
lib/
├── core/          # Constants, theme, utilities, network
├── data/          # Models, Drift DB, DAOs, remote datasources, repositories
├── domain/        # Entities, repository interfaces, use cases
├── presentation/  # Providers, screens, widgets
└── services/      # Notifications
```

**Clean Architecture layers:**
- `data` → `domain` ← `presentation`

**State Management:** Riverpod (AsyncNotifier, FutureProvider, StateNotifier)

**Database:** Drift/SQLite for offline articles & market snapshots

## API Sources

| Source | Type | Key Required | Limit |
|--------|------|-------------|-------|
| GNews | News | Yes (free) | 100/day |
| NewsData.io | News | Yes (free) | 200/day |
| ET Markets RSS | News | **No** | None |
| Moneycontrol RSS | News | **No** | None |
| Livemint RSS | News | **No** | None |
| Business Standard RSS | News | **No** | None |
| Yahoo Finance | Stocks | **No** | Unofficial |
| NSE India API | Stocks | **No** | Public |
| ExchangeRate-API | Currency | **No** | None |

## CI / CD

| Workflow | Trigger | What it does |
|---|---|---|
| **CI** (`.github/workflows/ci.yml`) | push to `main`/`develop`, PRs | `flutter analyze` + `flutter test` |
| **Release** (`.github/workflows/release.yml`) | push of tag `v*.*.*` | Signed AAB + split APKs → GitHub Release + Play Store upload |

### Step 1 — Generate a release keystore (once)

```bash
keytool -genkey -v -keystore stockswipe-release.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias stockswipe -storepass YOUR_STORE_PASS -keypass YOUR_KEY_PASS

# Base64-encode it for GitHub
base64 -i stockswipe-release.jks | pbcopy   # macOS — paste as KEYSTORE_BASE64 secret
```

### Step 2 — Set up GitHub Secrets

In **Settings → Secrets and variables → Actions** on the repo, add:

| Secret | Value |
|---|---|
| `KEYSTORE_BASE64` | Output of the `base64` command above |
| `STORE_PASSWORD` | Keystore store password |
| `KEY_ALIAS` | `stockswipe` (or your alias) |
| `KEY_PASSWORD` | Key password |
| `PLAY_SERVICE_ACCOUNT_JSON` | Google Play service account JSON *(optional — skipped if blank)* |

### Step 3 — Local development signing

Copy the template and fill in your values:
```bash
cp android/key.properties.template android/key.properties
# Edit android/key.properties — this file is gitignored
```

### Step 4 — Trigger a release

```bash
git tag v1.0.0
git push origin v1.0.0
```

The **Release** workflow will build a signed AAB + APKs, create a GitHub Release with them attached, and (if `PLAY_SERVICE_ACCOUNT_JSON` is set) upload the AAB to the Play Store internal track.

## Building Locally for Release

```bash
# Build app bundle (Play Store)
flutter build appbundle --release

# Build split APKs (sideload)
flutter build apk --release --split-per-abi
```

See `distribution/whatsnew/` for Play Store release notes.
