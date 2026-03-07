// test/widget/settings_screen_test.dart
import 'package:finswipe/data/datasources/local/local_datasource.dart';
import 'package:finswipe/domain/repositories/news_repository.dart';
import 'package:finswipe/injection_container.dart';
import 'package:finswipe/presentation/providers/preferences_provider.dart';
import 'package:finswipe/presentation/screens/home/settings/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/app_wrapper.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------
class MockNewsRepo extends Mock implements NewsRepository {}

class MockLocalDs extends Mock implements LocalDatasource {}

void main() {
  late MockNewsRepo mockNews;
  late MockLocalDs mockLocalDs;

  setUp(() {
    mockNews = MockNewsRepo();
    mockLocalDs = MockLocalDs();
    when(() => mockNews.clearCache()).thenAnswer((_) async {});
    when(() => mockLocalDs.clearReadHistory()).thenAnswer((_) async {});
  });

  /// Pumps the widget and waits just 1 second so async providers resolve
  /// without hitting the pumpAndSettle 100-frame timeout.
  Future<void> pumpSettings(WidgetTester tester, {_FakePrefs? prefs}) async {
    await tester.pumpWidget(
      makeTestableWidget(
        const SettingsScreen(),
        overrides: [
          preferencesProvider.overrideWith(() => prefs ?? _FakePrefs()),
          newsRepositoryProvider.overrideWithValue(mockNews),
          localDatasourceProvider.overrideWithValue(mockLocalDs),
        ],
      ),
    );
    // Give async providers one frame to resolve
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));
  }

  group('SettingsScreen', () {
    testWidgets('renders SETTINGS header', (WidgetTester tester) async {
      await pumpSettings(tester);
      expect(find.text('SETTINGS'), findsOneWidget);
    });

    testWidgets('renders Dark Mode SwitchListTile', (WidgetTester tester) async {
      await pumpSettings(tester);
      expect(find.text('Dark Mode'), findsOneWidget);
      expect(
        find.byWidgetPredicate(
            (w) => w is SwitchListTile && (w.title as Text).data == 'Dark Mode'),
        findsOneWidget,
      );
    });

    testWidgets('Dark Mode switch reflects isDarkMode=true',
        (WidgetTester tester) async {
      await pumpSettings(tester, prefs: _FakePrefs(isDark: true));
      final tile = tester.widget<SwitchListTile>(
        find.byWidgetPredicate(
            (w) => w is SwitchListTile && (w.title as Text).data == 'Dark Mode'),
      );
      expect(tile.value, isTrue);
    });

    testWidgets('renders Market Open Alert switch', (WidgetTester tester) async {
      await pumpSettings(tester);
      expect(find.text('Market Open Alert'), findsOneWidget);
    });

    testWidgets('renders Market Close Digest switch',
        (WidgetTester tester) async {
      await pumpSettings(tester);
      expect(find.text('Market Close Digest'), findsOneWidget);
    });

    testWidgets('renders API key fields', (WidgetTester tester) async {
      await pumpSettings(tester);
      expect(find.text('GNews API Token'), findsOneWidget);
      expect(find.text('NewsData.io Key'), findsOneWidget);
      expect(find.text('Alpha Vantage Key'), findsOneWidget);
    });

    testWidgets('Clear Cache shows success SnackBar',
        (WidgetTester tester) async {
      await pumpSettings(tester);

      // The Clear Cache tile is below the fold; drag the ScrollView down
      // using a targeted drag on the Scrollable to expose it.
      bool found = false;
      for (int i = 0; i < 5 && !found; i++) {
        await tester.drag(find.byType(Scrollable).first, const Offset(0, -300));
        await tester.pump();
        found = tester.any(find.widgetWithText(ListTile, 'Clear Cache'));
      }

      // Tap by icon which is less ambiguous than title text
      await tester.tap(find.byIcon(Icons.delete_sweep));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Cache cleared'), findsOneWidget);
    });

    testWidgets('renders app version 1.0.0', (WidgetTester tester) async {
      await pumpSettings(tester);
      // Version is in the About section — scroll down to reveal it
      await tester.dragUntilVisible(
        find.text('Version'),
        find.byType(ListView),
        const Offset(0, -300),
      );
      expect(find.text('Version'), findsOneWidget);
      expect(find.text('1.0.0'), findsOneWidget);
    });

    testWidgets('renders disclaimer text', (WidgetTester tester) async {
      await pumpSettings(tester);
      // Disclaimer is at the very bottom — drag until visible
      await tester.dragUntilVisible(
        find.textContaining('informational purposes only'),
        find.byType(ListView),
        const Offset(0, -300),
      );
      expect(find.textContaining('informational purposes only'), findsOneWidget);
    });
  });
}

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------
class _FakePrefs extends PreferencesNotifier {
  final bool isDark;
  _FakePrefs({this.isDark = true});

  @override
  Future<AppPreferences> build() async => AppPreferences(
        isDarkMode: isDark,
        notifMarketOpen: true,
        notifMarketClose: true,
      );

  @override
  Future<void> setDarkMode(bool v) async {}

  @override
  Future<void> setNotifMarketOpen(bool v) async {}

  @override
  Future<void> setNotifMarketClose(bool v) async {}
}
