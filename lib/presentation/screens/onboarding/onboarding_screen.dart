// lib/presentation/screens/onboarding/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/preferences_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  final _pages = [
    _OnboardingPage(
      icon: Icons.swipe,
      title: 'Swipe Through the Market',
      description:
          'Swipe RIGHT to save a story\nSwipe LEFT to skip it\nSwipe UP to read the full article',
      color: AppColors.primary,
    ),
    _OnboardingPage(
      icon: Icons.trending_up,
      title: 'Real-Time Market Data',
      description:
          'Live NIFTY 50, SENSEX, BANK NIFTY prices. Top gainers and losers. All in one place.',
      color: AppColors.bull,
    ),
    _OnboardingPage(
      icon: Icons.psychology,
      title: 'Smart Sentiment Analysis',
      description:
          'Every news card is automatically tagged as Bullish 🟢, Bearish 🔴, or Neutral 🟡.',
      color: AppColors.readOverlay,
    ),
  ];

  final _selectedTopics = <String>{};
  static const _allTopics = ['IT', 'Banking', 'IPO', 'Macro', 'Pharma', 'Auto', 'FMCG', 'Crypto', 'Policy'];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length + 1) {
      _pageController.nextPage(
          duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
    }
  }

  Future<void> _finish() async {
    await ref.read(preferencesProvider.notifier).setFavoriteTopics(
        _selectedTopics.toList());
    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final totalPages = _pages.length + 2; // pages + topics + api
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: Column(
          children: [
            // Page dots
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  totalPages,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _currentPage == i ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _currentPage == i
                          ? AppColors.primary
                          : AppColors.borderDark,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

            // Content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (p) => setState(() => _currentPage = p),
                children: [
                  ..._pages.map((p) => _buildInfoPage(p)),
                  _buildTopicsPage(),
                  _buildApiKeyPage(),
                ],
              ),
            ),

            // Action button
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _currentPage < totalPages - 1 ? _nextPage : _finish,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.backgroundDark,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    textStyle: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  child: Text(
                      _currentPage < totalPages - 1 ? 'Continue' : 'Get Started'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoPage(_OnboardingPage page) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: page.color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(page.icon, color: page.color, size: 56),
          ),
          const SizedBox(height: 40),
          Text(page.title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w700),
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Text(page.description,
              style: const TextStyle(
                  color: AppColors.textSecondaryDark, fontSize: 16, height: 1.6),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildTopicsPage() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('What interests you?',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          const Text('Select topics for a personalized feed.',
              style:
                  TextStyle(color: AppColors.textSecondaryDark, fontSize: 16)),
          const SizedBox(height: 32),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _allTopics.map((topic) {
              final sel = _selectedTopics.contains(topic);
              return FilterChip(
                label: Text(topic),
                selected: sel,
                onSelected: (_) {
                  setState(() {
                    if (sel)
                      _selectedTopics.remove(topic);
                    else
                      _selectedTopics.add(topic);
                  });
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildApiKeyPage() {
    final alphaController = TextEditingController(text: 'demo');
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('API Key Setup',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          const Text(
              'Optional: Get a free Alpha Vantage key for live stock prices. '
              'RSS feeds work without any key.',
              style: TextStyle(
                  color: AppColors.textSecondaryDark, fontSize: 15, height: 1.5)),
          const SizedBox(height: 24),
          TextField(
            controller: alphaController,
            decoration: const InputDecoration(
              labelText: 'Alpha Vantage Key',
              hintText: 'demo',
              helperText: 'Free key at alphavantage.co — 25 req/day',
            ),
            onChanged: (v) async {
              await ref.read(preferencesProvider.notifier).setAlphaVantageKey(v);
            },
          ),
          const SizedBox(height: 20),
          const Text(
            '⚡ You can add more API keys later in Settings → API Keys',
            style: TextStyle(
                color: AppColors.textSecondaryDark, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

class _OnboardingPage {
  final IconData icon;
  final String title;
  final String description;
  final Color color;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}
