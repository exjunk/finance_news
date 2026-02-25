// lib/presentation/screens/article_detail/article_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/article.dart';
import '../../widgets/sentiment_badge.dart';
import '../../widgets/stock_chip.dart';

class ArticleDetailScreen extends StatefulWidget {
  final Article article;
  const ArticleDetailScreen({super.key, required this.article});

  @override
  State<ArticleDetailScreen> createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  late final WebViewController _webController;
  bool _isLoading = true;
  double _loadProgress = 0;

  @override
  void initState() {
    super.initState();
    _webController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (p) => setState(() => _loadProgress = p / 100.0),
        onPageFinished: (_) => setState(() => _isLoading = false),
        onHttpError: (e) => setState(() => _isLoading = false),
      ))
      ..loadRequest(Uri.parse(widget.article.url));
  }

  @override
  Widget build(BuildContext context) {
    final article = widget.article;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          article.source,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => Share.share(
              '${article.title}\n${article.url}',
              subject: article.title,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.open_in_browser),
            onPressed: () => _webController.loadRequest(Uri.parse(article.url)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Article summary card
          _buildSummaryCard(context, article),

          // Loading indicator
          if (_isLoading)
            LinearProgressIndicator(
              value: _loadProgress,
              color: AppColors.primary,
              backgroundColor: AppColors.borderDark,
            ),

          // WebView
          Expanded(
            child: WebViewWidget(controller: _webController),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(BuildContext context, Article article) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDark, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SentimentBadge(sentiment: article.sentiment),
              const Spacer(),
              Text(
                '~${article.readingTimeMinutes} min read',
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            article.title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          if (article.description != null &&
              article.description!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              article.description!,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
          if (article.relatedTickers.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: article.relatedTickers
                  .take(5)
                  .map((t) => StockChip(symbol: t))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}
