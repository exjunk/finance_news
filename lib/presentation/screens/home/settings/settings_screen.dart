// lib/presentation/screens/home/settings/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../injection_container.dart';
import '../../../providers/preferences_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _gnewsController = TextEditingController();
  final _newsDataController = TextEditingController();
  final _alphaVantageController = TextEditingController();

  @override
  void dispose() {
    _gnewsController.dispose();
    _newsDataController.dispose();
    _alphaVantageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final prefsAsync = ref.watch(preferencesProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: prefsAsync.when(
          loading: () => const Center(
              child: CircularProgressIndicator(color: AppColors.primary)),
          error: (e, _) => Center(child: Text(e.toString())),
          data: (prefs) {
            _gnewsController.text =
                _gnewsController.text.isEmpty ? prefs.gnewsKey : _gnewsController.text;
            _newsDataController.text =
                _newsDataController.text.isEmpty ? prefs.newsDataKey : _newsDataController.text;
            _alphaVantageController.text =
                _alphaVantageController.text.isEmpty ? prefs.alphaVantageKey : _alphaVantageController.text;

            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                const _SectionHeader(title: 'SETTINGS'),

                // Appearance
                _SectionCard(
                  title: 'Appearance',
                  children: [
                    SwitchListTile(
                      title: const Text('Dark Mode'),
                      subtitle: const Text('Minimalist dark theme'),
                      value: prefs.isDarkMode,
                      onChanged: (v) =>
                          ref.read(preferencesProvider.notifier).setDarkMode(v),
                    ),
                  ],
                ),

                // Notifications
                _SectionCard(
                  title: 'Notifications',
                  children: [
                    SwitchListTile(
                      title: const Text('Market Open Alert'),
                      subtitle: const Text('Daily at 9:00 AM IST'),
                      value: prefs.notifMarketOpen,
                      onChanged: (v) => ref
                          .read(preferencesProvider.notifier)
                          .setNotifMarketOpen(v),
                    ),
                    const Divider(),
                    SwitchListTile(
                      title: const Text('Market Close Digest'),
                      subtitle: const Text('Daily at 3:35 PM IST'),
                      value: prefs.notifMarketClose,
                      onChanged: (v) => ref
                          .read(preferencesProvider.notifier)
                          .setNotifMarketClose(v),
                    ),
                  ],
                ),

                // API Keys
                _SectionCard(
                  title: 'API Keys',
                  children: [
                    _ApiKeyField(
                      label: 'GNews API Token',
                      hint: 'Get free key at gnews.io',
                      controller: _gnewsController,
                      onSave: (v) =>
                          ref.read(preferencesProvider.notifier).setGnewsKey(v),
                    ),
                    const Divider(),
                    _ApiKeyField(
                      label: 'NewsData.io Key',
                      hint: 'Get free key at newsdata.io',
                      controller: _newsDataController,
                      onSave: (v) => ref
                          .read(preferencesProvider.notifier)
                          .setNewsDataKey(v),
                    ),
                    const Divider(),
                    _ApiKeyField(
                      label: 'Alpha Vantage Key',
                      hint: '"demo" works for testing',
                      controller: _alphaVantageController,
                      onSave: (v) => ref
                          .read(preferencesProvider.notifier)
                          .setAlphaVantageKey(v),
                    ),
                  ],
                ),

                // Data management
                _SectionCard(
                  title: 'Data',
                  children: [
                    ListTile(
                      leading: const Icon(Icons.delete_sweep),
                      title: const Text('Clear Cache'),
                      subtitle: const Text('Remove all fetched articles'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        await ref.read(newsRepositoryProvider).clearCache();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Cache cleared')),
                          );
                        }
                      },
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.history),
                      title: const Text('Clear Read History'),
                      subtitle: const Text('Reset seen articles'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () async {
                        await ref.read(localDatasourceProvider).clearReadHistory();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Read history cleared')),
                          );
                        }
                      },
                    ),
                  ],
                ),

                // About
                _SectionCard(
                  title: 'About',
                  children: [
                    const ListTile(
                      leading: Icon(Icons.info_outline),
                      title: Text('Version'),
                      trailing: Text(AppConstants.appVersion,
                          style: TextStyle(color: AppColors.textSecondaryDark)),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.star),
                      title: const Text('Rate the App'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => launchUrl(
                          Uri.parse(AppConstants.playStoreUrl)),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.share),
                      title: const Text('Share App'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Share.share(
                          'Check out StockSwipe — swipe through Indian market news! ${AppConstants.playStoreUrl}'),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.description_outlined),
                      title: const Text('Open Source Licenses'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => showLicensePage(context: context),
                    ),
                  ],
                ),

                // Disclaimer
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    '⚠️ StockSwipe is for informational purposes only. '
                    'Not financial advice. Data sourced from public APIs.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondaryDark),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          const Icon(Icons.settings, color: AppColors.primary, size: 24),
          const SizedBox(width: 10),
          Text(title, style: Theme.of(context).textTheme.headlineSmall),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(),
              style: Theme.of(context)
                  .textTheme
                  .labelSmall
                  ?.copyWith(color: AppColors.primary, letterSpacing: 1)),
          const SizedBox(height: 6),
          Card(
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

class _ApiKeyField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final ValueChanged<String> onSave;

  const _ApiKeyField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(hintText: hint),
                  obscureText: true,
                  onSubmitted: onSave,
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon:
                    const Icon(Icons.save, color: AppColors.primary),
                onPressed: () => onSave(controller.text),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
