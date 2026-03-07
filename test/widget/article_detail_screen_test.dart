// test/widget/article_detail_screen_test.dart
//
// ArticleDetailScreen embeds a WebView which requires a native platform in
// production. In tests we suppress the WebViewWidget UnimplementedError so
// the rest of the screen (summary card, sentiment badge, action buttons, etc.)
// can render and be tested.

import 'package:finswipe/core/utils/sentiment_analyzer.dart';
import 'package:finswipe/presentation/screens/article_detail/article_detail_screen.dart';
import 'package:finswipe/presentation/widgets/sentiment_badge.dart';
import 'package:finswipe/presentation/widgets/stock_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
// ignore: depend_on_referenced_packages
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

import '../helpers/article_factory.dart';

// ---------------------------------------------------------------------------
// Minimal fake platform — enough to prevent the assert crash in initState
// ---------------------------------------------------------------------------

class _FakeWebViewPlatform extends WebViewPlatform {
  @override
  PlatformWebViewController createPlatformWebViewController(
      PlatformWebViewControllerCreationParams params) =>
      _FakeController(params);

  @override
  PlatformNavigationDelegate createPlatformNavigationDelegate(
      PlatformNavigationDelegateCreationParams params) =>
      _FakeDelegate(params);

  @override
  PlatformWebViewWidget createPlatformWebViewWidget(
      PlatformWebViewWidgetCreationParams params) =>
      _FakeWebViewWidget(params);
}

class _FakeController extends PlatformWebViewController {
  _FakeController(super.p) : super.implementation();
  @override Future<void> setJavaScriptMode(JavaScriptMode m) async {}
  Future<void> setNavigationDelegate(PlatformNavigationDelegate d) async {}
  @override Future<void> loadRequest(LoadRequestParams p) async {}
  @override Future<void> setBackgroundColor(Color c) async {}
  @override Future<void> setPlatformNavigationDelegate(PlatformNavigationDelegate d) async {}
  @override Future<void> setUserAgent(String? ua) async {}
}

class _FakeDelegate extends PlatformNavigationDelegate {
  _FakeDelegate(super.p) : super.implementation();
  @override Future<void> setOnNavigationRequest(NavigationRequestCallback cb) async {}
  @override Future<void> setOnPageStarted(PageEventCallback cb) async {}
  @override Future<void> setOnPageFinished(PageEventCallback cb) async {}
  @override Future<void> setOnHttpError(HttpResponseErrorCallback cb) async {}
  @override Future<void> setOnWebResourceError(WebResourceErrorCallback cb) async {}
  @override Future<void> setOnProgress(ProgressCallback cb) async {}
}

class _FakeWebViewWidget extends PlatformWebViewWidget {
  _FakeWebViewWidget(super.p) : super.implementation();
  @override
  Widget build(BuildContext context) => const SizedBox.shrink();
}

// ---------------------------------------------------------------------------
// Test scaffolding
// ---------------------------------------------------------------------------

/// Wraps [child] in a GoRouter app so context.pop() works.
Widget _wrap(Widget child) {
  final router = GoRouter(
    initialLocation: '/article',
    routes: [
      GoRoute(path: '/article', builder: (_, __) => child),
      GoRoute(path: '/', builder: (_, __) => const _Home()),
    ],
  );
  return ProviderScope(
    child: MaterialApp.router(
      theme: ThemeData.dark(),
      routerConfig: router,
    ),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late void Function(FlutterErrorDetails)? savedError;

  setUpAll(() {
    WebViewPlatform.instance = _FakeWebViewPlatform();
  });

  setUp(() {
    // Suppress UnimplementedError that bubbles up from WebViewWidget in tests.
    // This lets the rest of the screen (summary card, action buttons) render.
    savedError = FlutterError.onError;
    FlutterError.onError = (FlutterErrorDetails d) {
      if (d.exception is UnimplementedError) return;
      savedError?.call(d);
    };
  });

  tearDown(() {
    FlutterError.onError = savedError;
  });

  group('ArticleDetailScreen', () {
    testWidgets('renders article title in summary card',
        (WidgetTester tester) async {
      final art = ArticleFactory.create(title: 'RBI holds rates at 6.5%');
      await tester.pumpWidget(_wrap(ArticleDetailScreen(article: art)));
      await tester.pump();
      expect(find.text('RBI holds rates at 6.5%'), findsOneWidget);
    });

    testWidgets('renders SentimentBadge', (WidgetTester tester) async {
      final art = ArticleFactory.create(sentiment: Sentiment.bear);
      await tester.pumpWidget(_wrap(ArticleDetailScreen(article: art)));
      await tester.pump();
      expect(find.byType(SentimentBadge), findsOneWidget);
    });

    testWidgets('renders reading time label', (WidgetTester tester) async {
      final art = ArticleFactory.create(
        title: 'Sensex rallies',
        description: 'Markets moved higher as FIIs turned net buyers.',
      );
      await tester.pumpWidget(_wrap(ArticleDetailScreen(article: art)));
      await tester.pump();
      expect(find.textContaining('min read'), findsOneWidget);
    });

    testWidgets('renders article source in AppBar', (WidgetTester tester) async {
      final art = ArticleFactory.create(source: 'Moneycontrol');
      await tester.pumpWidget(_wrap(ArticleDetailScreen(article: art)));
      await tester.pump();
      expect(find.text('Moneycontrol'), findsOneWidget);
    });

    testWidgets('renders share and open-in-browser buttons',
        (WidgetTester tester) async {
      final art = ArticleFactory.create();
      await tester.pumpWidget(_wrap(ArticleDetailScreen(article: art)));
      await tester.pump();
      expect(find.byIcon(Icons.share), findsOneWidget);
      expect(find.byIcon(Icons.open_in_browser), findsOneWidget);
    });

    testWidgets('renders ticker chips when relatedTickers is non-empty',
        (WidgetTester tester) async {
      final art = ArticleFactory.create(relatedTickers: ['RELIANCE', 'TCS']);
      await tester.pumpWidget(_wrap(ArticleDetailScreen(article: art)));
      await tester.pump();
      expect(find.text('RELIANCE'), findsOneWidget);
      expect(find.text('TCS'), findsOneWidget);
    });

    testWidgets('no StockChip when relatedTickers is empty',
        (WidgetTester tester) async {
      final art = ArticleFactory.create(relatedTickers: []);
      await tester.pumpWidget(_wrap(ArticleDetailScreen(article: art)));
      await tester.pump();
      expect(find.byType(StockChip), findsNothing);
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
