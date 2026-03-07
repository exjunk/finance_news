// test/helpers/app_wrapper.dart
import 'package:finswipe/core/theme/app_theme.dart';
import 'package:finswipe/presentation/providers/preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Returns a [GoRouter] that hosts [widget] at [path] and stubs all
/// other routes used by the app (so navigation calls don't throw).
GoRouter buildTestRouter({
  required Widget widget,
  String initialLocation = '/',
  String path = '/',
}) {
  return GoRouter(
    initialLocation: initialLocation,
    routes: [
      GoRoute(path: path, builder: (_, __) => widget),
      GoRoute(path: '/splash', builder: (_, __) => const _Stub('/splash')),
      GoRoute(path: '/onboarding', builder: (_, __) => const _Stub('/onboarding')),
      GoRoute(path: '/search', builder: (_, __) => const _Stub('/search')),
      GoRoute(
        path: '/article',
        builder: (_, __) => const _Stub('/article'),
      ),
    ],
    errorBuilder: (_, state) => _Stub(state.uri.path),
  );
}

/// Pumps [widget] inside a [ProviderScope] + [MaterialApp] with the dark theme.
/// Pass [overrides] to inject stub providers.
Widget makeTestableWidget(
  Widget widget, {
  List<Override> overrides = const [],
}) {
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp(
      theme: AppTheme.darkTheme,
      home: widget,
    ),
  );
}

/// Pumps [widget] inside a [ProviderScope] + [MaterialApp.router] so that
/// [GoRouter] navigation can be exercised in tests.
Widget makeRoutedTestableWidget(
  Widget widget, {
  List<Override> overrides = const [],
  GoRouter? router,
  String initialLocation = '/',
  String path = '/',
}) {
  final r = router ??
      buildTestRouter(
        widget: widget,
        initialLocation: initialLocation,
        path: path,
      );
  return ProviderScope(
    overrides: overrides,
    child: MaterialApp.router(
      theme: AppTheme.darkTheme,
      routerConfig: r,
    ),
  );
}

/// A default stub preferences: non-first-launch, dark mode on.
const defaultPrefs = AppPreferences(
  isDarkMode: true,
  notifMarketOpen: true,
  notifMarketClose: true,
);

/// Minimal placeholder screen used as navigation targets in router stubs.
class _Stub extends StatelessWidget {
  final String label;
  const _Stub(this.label);

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('Stub: $label')));
}
