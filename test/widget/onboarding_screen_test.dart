// test/widget/onboarding_screen_test.dart
import 'package:finswipe/presentation/providers/preferences_provider.dart';
import 'package:finswipe/presentation/screens/onboarding/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../helpers/app_wrapper.dart';

void main() {
  group('OnboardingScreen', () {
    Widget _buildOnboarding({bool didSetTopics = false}) {
      final router = GoRouter(
        initialLocation: '/onboarding',
        routes: [
          GoRoute(
            path: '/onboarding',
            builder: (_, __) => const OnboardingScreen(),
          ),
          GoRoute(path: '/', builder: (_, __) => const _Home()),
        ],
      );

      return ProviderScope(
        overrides: [
          preferencesProvider.overrideWith(() => _FakePrefs()),
        ],
        child: MaterialApp.router(
          theme: ThemeData.dark(),
          routerConfig: router,
        ),
      );
    }

    testWidgets('shows first page heading "Swipe Through the Market"',
        (WidgetTester tester) async {
      await tester.pumpWidget(_buildOnboarding());
      await tester.pump();
      expect(find.text('Swipe Through the Market'), findsOneWidget);
    });

    testWidgets('shows "Continue" button on first page',
        (WidgetTester tester) async {
      await tester.pumpWidget(_buildOnboarding());
      await tester.pump();
      expect(find.text('Continue'), findsOneWidget);
    });

    testWidgets('tapping Continue advances to page 2',
        (WidgetTester tester) async {
      await tester.pumpWidget(_buildOnboarding());
      await tester.pump();

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(find.text('Real-Time Market Data'), findsOneWidget);
    });

    testWidgets('tapping Continue twice reaches Smart Sentiment page',
        (WidgetTester tester) async {
      await tester.pumpWidget(_buildOnboarding());
      await tester.pump();

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(find.text('Smart Sentiment Analysis'), findsOneWidget);
    });

    testWidgets('topics page shows all 9 topic chips',
        (WidgetTester tester) async {
      await tester.pumpWidget(_buildOnboarding());
      await tester.pump();

      // Navigate through 3 info pages to reach the topics page
      for (int i = 0; i < 3; i++) {
        await tester.tap(find.text('Continue'));
        await tester.pumpAndSettle();
      }

      expect(find.text('What interests you?'), findsOneWidget);
      for (final topic in ['IT', 'Banking', 'IPO', 'Macro', 'Pharma', 'Auto', 'FMCG', 'Crypto', 'Policy']) {
        expect(find.text(topic), findsOneWidget, reason: 'Topic "$topic" not found');
      }
    });

    testWidgets('selecting a topic chip marks it selected',
        (WidgetTester tester) async {
      await tester.pumpWidget(_buildOnboarding());
      await tester.pump();

      for (int i = 0; i < 3; i++) {
        await tester.tap(find.text('Continue'));
        await tester.pumpAndSettle();
      }

      final itChip = find.widgetWithText(FilterChip, 'IT');
      expect(itChip, findsOneWidget);

      // Initially unselected
      expect(tester.widget<FilterChip>(itChip).selected, isFalse);

      await tester.tap(itChip);
      await tester.pump();

      // Should be selected after tap
      expect(tester.widget<FilterChip>(itChip).selected, isTrue);
    });

    testWidgets('"Get Started" button navigates to /', (WidgetTester tester) async {
      await tester.pumpWidget(_buildOnboarding());
      await tester.pump();

      for (int i = 0; i < 3; i++) {
        await tester.tap(find.text('Continue'));
        await tester.pumpAndSettle();
      }

      expect(find.text('Get Started'), findsOneWidget);
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();

      expect(find.byType(_Home), findsOneWidget);
    });
  });
}

// ---------------------------------------------------------------------------
// Stubs/Fakes
// ---------------------------------------------------------------------------

class _Home extends StatelessWidget {
  const _Home();
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Home')));
}

class _FakePrefs extends PreferencesNotifier {
  @override
  Future<AppPreferences> build() async => defaultPrefs;

  @override
  Future<void> setFavoriteTopics(List<String> topics) async {}
}
