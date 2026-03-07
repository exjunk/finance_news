// test/widget/search_screen_test.dart
import 'package:finswipe/domain/repositories/news_repository.dart';
import 'package:finswipe/domain/usecases/get_news_feed.dart';
import 'package:finswipe/injection_container.dart';
import 'package:finswipe/presentation/providers/news_provider.dart';
import 'package:finswipe/presentation/screens/search/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import '../helpers/article_factory.dart';
import '../helpers/app_wrapper.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------
class MockNewsRepo extends Mock implements NewsRepository {}

void main() {
  late MockNewsRepo mockNews;

  setUp(() {
    mockNews = MockNewsRepo();
    // Default: only empty list
    when(() => mockNews.searchArticles(any())).thenAnswer((_) async => []);
    when(() => mockNews.searchArticles('IPO'))
        .thenAnswer((_) async => ArticleFactory.createList(3));
    when(() => mockNews.watchSavedArticles())
        .thenAnswer((_) => const Stream.empty());
    when(() => mockNews.getSavedArticles()).thenAnswer((_) async => []);
  });

  Widget _buildSearch() {
    final router = GoRouter(
      initialLocation: '/search',
      routes: [
        GoRoute(path: '/search', builder: (_, __) => const SearchScreen()),
        GoRoute(path: '/', builder: (_, __) => const _Home()),
        GoRoute(path: '/article', builder: (_, __) => const _Stub('article')),
      ],
    );

    return ProviderScope(
      overrides: [
        newsRepositoryProvider.overrideWithValue(mockNews),
        // Override use-cases that depend on the news repo
        getSavedArticlesProvider.overrideWith(
          (ref) => GetSavedArticles(mockNews),
        ),
        searchArticlesProvider.overrideWith(
          (ref) => SearchArticles(mockNews),
        ),
        // Override the family providers with per-argument stubs
        searchResultsProvider('').overrideWith(
          (ref) async => [],
        ),
        searchResultsProvider('IPO').overrideWith(
          (ref) async => ArticleFactory.createList(3),
        ),
        searchResultsProvider('nodata').overrideWith(
          (ref) async => [],
        ),
        watchlistStreamProvider.overrideWith(
          (ref) => const Stream.empty(),
        ),
      ],
      child: MaterialApp.router(
        theme: ThemeData.dark(),
        routerConfig: router,
      ),
    );
  }

  group('SearchScreen', () {
    testWidgets('shows "Search News" empty state initially',
        (WidgetTester tester) async {
      await tester.pumpWidget(_buildSearch());
      await tester.pumpAndSettle();
      expect(find.text('Search News'), findsOneWidget);
    });

    testWidgets('shows quick-tag chips on screen', (WidgetTester tester) async {
      await tester.pumpWidget(_buildSearch());
      await tester.pump();
      expect(find.text('IPO'), findsOneWidget);
      expect(find.text('Nifty'), findsOneWidget);
      expect(find.text('Results'), findsOneWidget);
      expect(find.text('RBI'), findsOneWidget);
      expect(find.text('FII'), findsOneWidget);
    });

    testWidgets('tapping IPO chip populates the search TextField',
        (WidgetTester tester) async {
      await tester.pumpWidget(_buildSearch());
      await tester.pump();

      await tester.tap(find.widgetWithText(ActionChip, 'IPO'));
      await tester.pump();

      final tf = tester.widget<TextField>(find.byType(TextField));
      expect(tf.controller?.text, 'IPO');
    });

    testWidgets('typing a query shows articles from mock',
        (WidgetTester tester) async {
      await tester.pumpWidget(_buildSearch());
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'IPO');
      await tester.pumpAndSettle();

      expect(find.textContaining('Article headline number'), findsWidgets);
    });

    testWidgets('shows "No Results" for empty result query',
        (WidgetTester tester) async {
      await tester.pumpWidget(_buildSearch());
      await tester.pump();

      await tester.enterText(find.byType(TextField), 'nodata');
      await tester.pumpAndSettle();

      expect(find.text('No Results'), findsOneWidget);
    });

    testWidgets('Cancel button navigates back', (WidgetTester tester) async {
      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(path: '/', builder: (_, __) => const _Home()),
          GoRoute(path: '/search', builder: (_, __) => const SearchScreen()),
          GoRoute(path: '/article', builder: (_, __) => const _Stub('article')),
        ],
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            newsRepositoryProvider.overrideWithValue(mockNews),
            getSavedArticlesProvider
                .overrideWith((ref) => GetSavedArticles(mockNews)),
            searchArticlesProvider
                .overrideWith((ref) => SearchArticles(mockNews)),
            searchResultsProvider('').overrideWith((ref) async => []),
            watchlistStreamProvider.overrideWith((ref) => const Stream.empty()),
          ],
          child: MaterialApp.router(
            theme: ThemeData.dark(),
            routerConfig: router,
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Navigate to /search
      router.push('/search');
      await tester.pumpAndSettle();

      expect(find.byType(SearchScreen), findsOneWidget);

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(find.byType(_Home), findsOneWidget);
    });
  });
}

// ---------------------------------------------------------------------------
// Stubs
// ---------------------------------------------------------------------------
class _Home extends StatelessWidget {
  const _Home();
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Home')));
}

class _Stub extends StatelessWidget {
  final String label;
  const _Stub(this.label);
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('Stub: $label')));
}
