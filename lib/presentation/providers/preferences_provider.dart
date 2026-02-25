// lib/presentation/providers/preferences_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

class AppPreferences {
  final bool isDarkMode;
  final bool notifMarketOpen;
  final bool notifMarketClose;
  final String alphaVantageKey;
  final String gnewsKey;
  final String newsDataKey;
  final List<String> favoriteTopics;
  final int cardsSwiped;

  const AppPreferences({
    this.isDarkMode = true,
    this.notifMarketOpen = true,
    this.notifMarketClose = true,
    this.alphaVantageKey = 'demo',
    this.gnewsKey = '',
    this.newsDataKey = '',
    this.favoriteTopics = const [],
    this.cardsSwiped = 0,
  });

  AppPreferences copyWith({
    bool? isDarkMode,
    bool? notifMarketOpen,
    bool? notifMarketClose,
    String? alphaVantageKey,
    String? gnewsKey,
    String? newsDataKey,
    List<String>? favoriteTopics,
    int? cardsSwiped,
  }) =>
      AppPreferences(
        isDarkMode: isDarkMode ?? this.isDarkMode,
        notifMarketOpen: notifMarketOpen ?? this.notifMarketOpen,
        notifMarketClose: notifMarketClose ?? this.notifMarketClose,
        alphaVantageKey: alphaVantageKey ?? this.alphaVantageKey,
        gnewsKey: gnewsKey ?? this.gnewsKey,
        newsDataKey: newsDataKey ?? this.newsDataKey,
        favoriteTopics: favoriteTopics ?? this.favoriteTopics,
        cardsSwiped: cardsSwiped ?? this.cardsSwiped,
      );
}

class PreferencesNotifier extends AsyncNotifier<AppPreferences> {
  late SharedPreferences _prefs;

  @override
  Future<AppPreferences> build() async {
    _prefs = await SharedPreferences.getInstance();
    return _loadFromPrefs();
  }

  AppPreferences _loadFromPrefs() => AppPreferences(
        isDarkMode: _prefs.getBool(AppConstants.prefDarkMode) ?? true,
        notifMarketOpen:
            _prefs.getBool(AppConstants.prefNotifMarketOpen) ?? true,
        notifMarketClose:
            _prefs.getBool(AppConstants.prefNotifMarketClose) ?? true,
        alphaVantageKey:
            _prefs.getString(AppConstants.prefAlphaVantageKey) ?? 'demo',
        gnewsKey: _prefs.getString(AppConstants.prefGnewsKey) ?? '',
        newsDataKey: _prefs.getString(AppConstants.prefNewsDataKey) ?? '',
        favoriteTopics:
            _prefs.getStringList(AppConstants.prefFavoriteTopics) ?? [],
        cardsSwiped: _prefs.getInt(AppConstants.prefCardsSwiped) ?? 0,
      );

  Future<void> setDarkMode(bool value) async {
    await _prefs.setBool(AppConstants.prefDarkMode, value);
    state = AsyncData(state.value!.copyWith(isDarkMode: value));
  }

  Future<void> setNotifMarketOpen(bool value) async {
    await _prefs.setBool(AppConstants.prefNotifMarketOpen, value);
    state = AsyncData(state.value!.copyWith(notifMarketOpen: value));
  }

  Future<void> setNotifMarketClose(bool value) async {
    await _prefs.setBool(AppConstants.prefNotifMarketClose, value);
    state = AsyncData(state.value!.copyWith(notifMarketClose: value));
  }

  Future<void> setAlphaVantageKey(String key) async {
    await _prefs.setString(AppConstants.prefAlphaVantageKey, key);
    state = AsyncData(state.value!.copyWith(alphaVantageKey: key));
  }

  Future<void> setGnewsKey(String key) async {
    await _prefs.setString(AppConstants.prefGnewsKey, key);
    state = AsyncData(state.value!.copyWith(gnewsKey: key));
  }

  Future<void> setNewsDataKey(String key) async {
    await _prefs.setString(AppConstants.prefNewsDataKey, key);
    state = AsyncData(state.value!.copyWith(newsDataKey: key));
  }

  Future<void> setFavoriteTopics(List<String> topics) async {
    await _prefs.setStringList(AppConstants.prefFavoriteTopics, topics);
    state = AsyncData(state.value!.copyWith(favoriteTopics: topics));
  }

  Future<void> incrementCardsSwiped() async {
    final current = state.value?.cardsSwiped ?? 0;
    await _prefs.setInt(AppConstants.prefCardsSwiped, current + 1);
    state = AsyncData(state.value!.copyWith(cardsSwiped: current + 1));
  }

  Future<bool> isFirstLaunch() async {
    final first = _prefs.getBool(AppConstants.prefFirstLaunch) ?? true;
    if (first) {
      await _prefs.setBool(AppConstants.prefFirstLaunch, false);
    }
    return first;
  }
}

final preferencesProvider =
    AsyncNotifierProvider<PreferencesNotifier, AppPreferences>(
        PreferencesNotifier.new);
