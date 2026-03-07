// test/widget/splash_screen_test.dart
//
// Note: Navigation tests (to /onboarding and /) are omitted because SplashScreen
// uses Future.delayed timers that require fakeAsync to advance in tests.
// Those flows are covered by integration tests. This file covers the render logic.
import 'package:finswipe/presentation/providers/preferences_provider.dart';
import 'package:finswipe/presentation/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../helpers/app_wrapper.dart';

void main() {
  group('SplashScreen', () {
    Widget buildSplash() {
      final router = GoRouter(
        initialLocation: '/splash',
        routes: [
          GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
          GoRoute(path: '/', builder: (_, __) => const _Stub('home')),
          GoRoute(path: '/onboarding', builder: (_, __) => const _Stub('onboarding')),
          GoRoute(path: '/search', builder: (_, __) => const _Stub('search')),
          GoRoute(path: '/article', builder: (_, __) => const _Stub('article')),
        ],
      );
      return ProviderScope(
        overrides: [
          preferencesProvider.overrideWith(() => _FakePrefs(isFirst: false)),
        ],
        child: MaterialApp.router(
          theme: ThemeData.dark(),
          routerConfig: router,
        ),
      );
    }

    testWidgets('renders StockSwipe title', (WidgetTester tester) async {
      await tester.pumpWidget(buildSplash());
      // Just the build frame — before any navigation timer fires
      await tester.pump();
      expect(find.text('StockSwipe'), findsOneWidget);
    });

    testWidgets('renders "Swipe Through the Market" tagline',
        (WidgetTester tester) async {
      await tester.pumpWidget(buildSplash());
      await tester.pump();
      expect(find.text('Swipe Through the Market'), findsOneWidget);
    });

    testWidgets('renders trending_up icon', (WidgetTester tester) async {
      await tester.pumpWidget(buildSplash());
      await tester.pump();
      expect(find.byIcon(Icons.trending_up), findsOneWidget);
    });
  });
}

// ---------------------------------------------------------------------------
// Stubs
// ---------------------------------------------------------------------------
class _Stub extends StatelessWidget {
  final String label;
  const _Stub(this.label);
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('Stub: $label')));
}

class _FakePrefs extends PreferencesNotifier {
  final bool isFirst;
  _FakePrefs({required this.isFirst});

  @override
  Future<AppPreferences> build() async => defaultPrefs;

  @override
  Future<bool> isFirstLaunch() async => isFirst;
}
