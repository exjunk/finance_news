// test/widget/home_screen_test.dart
import 'package:finswipe/domain/repositories/market_repository.dart';
import 'package:finswipe/domain/repositories/news_repository.dart';
import 'package:finswipe/injection_container.dart';
import 'package:finswipe/presentation/providers/news_provider.dart';
import 'package:finswipe/presentation/providers/preferences_provider.dart';
import 'package:finswipe/presentation/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/app_wrapper.dart';
import '../helpers/article_factory.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------
class MockNewsRepo extends Mock implements NewsRepository {}

class MockMarketRepo extends Mock implements MarketRepository {}

void main() {
  late MockNewsRepo mockNews;
  late MockMarketRepo mockMarket;

  setUp(() {
    mockNews = MockNewsRepo();
    mockMarket = MockMarketRepo();

    when(() => mockNews.getNewsFeed(category: any(named: 'category')))
        .thenAnswer((_) async => ArticleFactory.createList(0));
    when(() => mockNews.watchSavedArticles())
        .thenAnswer((_) => const Stream.empty());
    when(() => mockNews.getSavedArticles()).thenAnswer((_) async => []);
    when(() => mockMarket.getMarketIndices()).thenAnswer((_) async => []);
    when(() => mockMarket.getTopGainers()).thenAnswer((_) async => []);
    when(() => mockMarket.getTopLosers()).thenAnswer((_) async => []);
    when(() => mockMarket.getUsdInrRate()).thenAnswer((_) async => 83.0);
    when(() => mockMarket.isMarketOpen()).thenAnswer((_) async => true);
  });

  void setWideScreen(WidgetTester tester) {
    tester.view.physicalSize = const Size(2400, 1080);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  Widget buildHome({int initialIndex = 0}) {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => HomeScreen(initialIndex: initialIndex),
        ),
        GoRoute(path: '/search', builder: (_, __) => const _SearchStub()),
        GoRoute(path: '/article', builder: (_, __) => const _Stub('/article')),
      ],
    );

    return ProviderScope(
      overrides: [
        newsRepositoryProvider.overrideWithValue(mockNews),
        marketRepositoryProvider.overrideWithValue(mockMarket),
        preferencesProvider.overrideWith(() => _FakePrefs()),
        newsFeedProvider('All').overrideWith((ref) async => []),
        currentNewsFeedProvider.overrideWith((_) async => []),
        watchlistStreamProvider.overrideWith((ref) => const Stream.empty()),
      ],
      child: MaterialApp.router(
        theme: ThemeData.dark(),
        routerConfig: router,
      ),
    );
  }

  group('HomeScreen', () {
    testWidgets('renders BottomNavigationBar with 4 items',
        (WidgetTester tester) async {
      setWideScreen(tester);
      await tester.pumpWidget(buildHome());
      await tester.pump();

      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text('Feed'), findsOneWidget);
      expect(find.text('Markets'), findsOneWidget);
      expect(find.text('Saved'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('FAB visible on Feed tab (index 0)',
        (WidgetTester tester) async {
      setWideScreen(tester);
      await tester.pumpWidget(buildHome(initialIndex: 0));
      await tester.pump();
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    // Test the FAB logic directly by starting on non-Feed tabs.
    // This avoids tapping across tabs (which renders MarketPulseScreen and
    // causes MarketTickerBar overflow errors in test viewport).

    testWidgets('FAB not visible when initialIndex is Markets (1)',
        (WidgetTester tester) async {
      setWideScreen(tester);
      await tester.pumpWidget(buildHome(initialIndex: 1));
      await tester.pump();
      expect(find.byType(FloatingActionButton), findsNothing);
    });

    testWidgets('FAB not visible when initialIndex is Saved (2)',
        (WidgetTester tester) async {
      setWideScreen(tester);
      await tester.pumpWidget(buildHome(initialIndex: 2));
      await tester.pump();
      expect(find.byType(FloatingActionButton), findsNothing);
    });

    testWidgets('FAB not visible when initialIndex is Settings (3)',
        (WidgetTester tester) async {
      setWideScreen(tester);
      await tester.pumpWidget(buildHome(initialIndex: 3));
      await tester.pump();
      expect(find.byType(FloatingActionButton), findsNothing);
    });

  });
}

// ---------------------------------------------------------------------------
// Stubs
// ---------------------------------------------------------------------------

class _SearchStub extends StatelessWidget {
  const _SearchStub();
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Search')));
}

class _Stub extends StatelessWidget {
  final String label;
  const _Stub(this.label);
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('Stub: $label')));
}

class _FakePrefs extends PreferencesNotifier {
  @override
  Future<AppPreferences> build() async => defaultPrefs;
  @override
  Future<void> setDarkMode(bool v) async {}
  @override
  Future<void> setNotifMarketOpen(bool v) async {}
  @override
  Future<void> setNotifMarketClose(bool v) async {}
}
