// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ArticlesTable extends Articles with TableInfo<$ArticlesTable, Article> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ArticlesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _articleIdMeta =
      const VerificationMeta('articleId');
  @override
  late final GeneratedColumn<String> articleId = GeneratedColumn<String>(
      'article_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'title', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _descriptionMeta =
      const VerificationMeta('description');
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
      'description', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
      'url', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _imageUrlMeta =
      const VerificationMeta('imageUrl');
  @override
  late final GeneratedColumn<String> imageUrl = GeneratedColumn<String>(
      'image_url', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _sourceMeta = const VerificationMeta('source');
  @override
  late final GeneratedColumn<String> source = GeneratedColumn<String>(
      'source', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _sentimentMeta =
      const VerificationMeta('sentiment');
  @override
  late final GeneratedColumn<String> sentiment = GeneratedColumn<String>(
      'sentiment', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _relatedTickersMeta =
      const VerificationMeta('relatedTickers');
  @override
  late final GeneratedColumn<String> relatedTickers = GeneratedColumn<String>(
      'related_tickers', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _publishedAtMeta =
      const VerificationMeta('publishedAt');
  @override
  late final GeneratedColumn<int> publishedAt = GeneratedColumn<int>(
      'published_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _fetchedAtMeta =
      const VerificationMeta('fetchedAt');
  @override
  late final GeneratedColumn<int> fetchedAt = GeneratedColumn<int>(
      'fetched_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isReadMeta = const VerificationMeta('isRead');
  @override
  late final GeneratedColumn<bool> isRead = GeneratedColumn<bool>(
      'is_read', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_read" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isSavedMeta =
      const VerificationMeta('isSaved');
  @override
  late final GeneratedColumn<bool> isSaved = GeneratedColumn<bool>(
      'is_saved', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_saved" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isDismissedMeta =
      const VerificationMeta('isDismissed');
  @override
  late final GeneratedColumn<bool> isDismissed = GeneratedColumn<bool>(
      'is_dismissed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_dismissed" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        articleId,
        title,
        description,
        url,
        imageUrl,
        source,
        category,
        sentiment,
        relatedTickers,
        publishedAt,
        fetchedAt,
        isRead,
        isSaved,
        isDismissed
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'articles';
  @override
  VerificationContext validateIntegrity(Insertable<Article> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('article_id')) {
      context.handle(_articleIdMeta,
          articleId.isAcceptableOrUnknown(data['article_id']!, _articleIdMeta));
    } else if (isInserting) {
      context.missing(_articleIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
          _descriptionMeta,
          description.isAcceptableOrUnknown(
              data['description']!, _descriptionMeta));
    }
    if (data.containsKey('url')) {
      context.handle(
          _urlMeta, url.isAcceptableOrUnknown(data['url']!, _urlMeta));
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('image_url')) {
      context.handle(_imageUrlMeta,
          imageUrl.isAcceptableOrUnknown(data['image_url']!, _imageUrlMeta));
    }
    if (data.containsKey('source')) {
      context.handle(_sourceMeta,
          source.isAcceptableOrUnknown(data['source']!, _sourceMeta));
    } else if (isInserting) {
      context.missing(_sourceMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('sentiment')) {
      context.handle(_sentimentMeta,
          sentiment.isAcceptableOrUnknown(data['sentiment']!, _sentimentMeta));
    } else if (isInserting) {
      context.missing(_sentimentMeta);
    }
    if (data.containsKey('related_tickers')) {
      context.handle(
          _relatedTickersMeta,
          relatedTickers.isAcceptableOrUnknown(
              data['related_tickers']!, _relatedTickersMeta));
    }
    if (data.containsKey('published_at')) {
      context.handle(
          _publishedAtMeta,
          publishedAt.isAcceptableOrUnknown(
              data['published_at']!, _publishedAtMeta));
    } else if (isInserting) {
      context.missing(_publishedAtMeta);
    }
    if (data.containsKey('fetched_at')) {
      context.handle(_fetchedAtMeta,
          fetchedAt.isAcceptableOrUnknown(data['fetched_at']!, _fetchedAtMeta));
    } else if (isInserting) {
      context.missing(_fetchedAtMeta);
    }
    if (data.containsKey('is_read')) {
      context.handle(_isReadMeta,
          isRead.isAcceptableOrUnknown(data['is_read']!, _isReadMeta));
    }
    if (data.containsKey('is_saved')) {
      context.handle(_isSavedMeta,
          isSaved.isAcceptableOrUnknown(data['is_saved']!, _isSavedMeta));
    }
    if (data.containsKey('is_dismissed')) {
      context.handle(
          _isDismissedMeta,
          isDismissed.isAcceptableOrUnknown(
              data['is_dismissed']!, _isDismissedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Article map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Article(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      articleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}article_id'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}title'])!,
      description: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}description']),
      url: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}url'])!,
      imageUrl: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}image_url']),
      source: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}source'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      sentiment: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}sentiment'])!,
      relatedTickers: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}related_tickers']),
      publishedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}published_at'])!,
      fetchedAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}fetched_at'])!,
      isRead: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_read'])!,
      isSaved: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_saved'])!,
      isDismissed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_dismissed'])!,
    );
  }

  @override
  $ArticlesTable createAlias(String alias) {
    return $ArticlesTable(attachedDatabase, alias);
  }
}

class Article extends DataClass implements Insertable<Article> {
  final int id;
  final String articleId;
  final String title;
  final String? description;
  final String url;
  final String? imageUrl;
  final String source;
  final String category;
  final String sentiment;
  final String? relatedTickers;
  final int publishedAt;
  final int fetchedAt;
  final bool isRead;
  final bool isSaved;
  final bool isDismissed;
  const Article(
      {required this.id,
      required this.articleId,
      required this.title,
      this.description,
      required this.url,
      this.imageUrl,
      required this.source,
      required this.category,
      required this.sentiment,
      this.relatedTickers,
      required this.publishedAt,
      required this.fetchedAt,
      required this.isRead,
      required this.isSaved,
      required this.isDismissed});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['article_id'] = Variable<String>(articleId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['url'] = Variable<String>(url);
    if (!nullToAbsent || imageUrl != null) {
      map['image_url'] = Variable<String>(imageUrl);
    }
    map['source'] = Variable<String>(source);
    map['category'] = Variable<String>(category);
    map['sentiment'] = Variable<String>(sentiment);
    if (!nullToAbsent || relatedTickers != null) {
      map['related_tickers'] = Variable<String>(relatedTickers);
    }
    map['published_at'] = Variable<int>(publishedAt);
    map['fetched_at'] = Variable<int>(fetchedAt);
    map['is_read'] = Variable<bool>(isRead);
    map['is_saved'] = Variable<bool>(isSaved);
    map['is_dismissed'] = Variable<bool>(isDismissed);
    return map;
  }

  ArticlesCompanion toCompanion(bool nullToAbsent) {
    return ArticlesCompanion(
      id: Value(id),
      articleId: Value(articleId),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      url: Value(url),
      imageUrl: imageUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(imageUrl),
      source: Value(source),
      category: Value(category),
      sentiment: Value(sentiment),
      relatedTickers: relatedTickers == null && nullToAbsent
          ? const Value.absent()
          : Value(relatedTickers),
      publishedAt: Value(publishedAt),
      fetchedAt: Value(fetchedAt),
      isRead: Value(isRead),
      isSaved: Value(isSaved),
      isDismissed: Value(isDismissed),
    );
  }

  factory Article.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Article(
      id: serializer.fromJson<int>(json['id']),
      articleId: serializer.fromJson<String>(json['articleId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      url: serializer.fromJson<String>(json['url']),
      imageUrl: serializer.fromJson<String?>(json['imageUrl']),
      source: serializer.fromJson<String>(json['source']),
      category: serializer.fromJson<String>(json['category']),
      sentiment: serializer.fromJson<String>(json['sentiment']),
      relatedTickers: serializer.fromJson<String?>(json['relatedTickers']),
      publishedAt: serializer.fromJson<int>(json['publishedAt']),
      fetchedAt: serializer.fromJson<int>(json['fetchedAt']),
      isRead: serializer.fromJson<bool>(json['isRead']),
      isSaved: serializer.fromJson<bool>(json['isSaved']),
      isDismissed: serializer.fromJson<bool>(json['isDismissed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'articleId': serializer.toJson<String>(articleId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'url': serializer.toJson<String>(url),
      'imageUrl': serializer.toJson<String?>(imageUrl),
      'source': serializer.toJson<String>(source),
      'category': serializer.toJson<String>(category),
      'sentiment': serializer.toJson<String>(sentiment),
      'relatedTickers': serializer.toJson<String?>(relatedTickers),
      'publishedAt': serializer.toJson<int>(publishedAt),
      'fetchedAt': serializer.toJson<int>(fetchedAt),
      'isRead': serializer.toJson<bool>(isRead),
      'isSaved': serializer.toJson<bool>(isSaved),
      'isDismissed': serializer.toJson<bool>(isDismissed),
    };
  }

  Article copyWith(
          {int? id,
          String? articleId,
          String? title,
          Value<String?> description = const Value.absent(),
          String? url,
          Value<String?> imageUrl = const Value.absent(),
          String? source,
          String? category,
          String? sentiment,
          Value<String?> relatedTickers = const Value.absent(),
          int? publishedAt,
          int? fetchedAt,
          bool? isRead,
          bool? isSaved,
          bool? isDismissed}) =>
      Article(
        id: id ?? this.id,
        articleId: articleId ?? this.articleId,
        title: title ?? this.title,
        description: description.present ? description.value : this.description,
        url: url ?? this.url,
        imageUrl: imageUrl.present ? imageUrl.value : this.imageUrl,
        source: source ?? this.source,
        category: category ?? this.category,
        sentiment: sentiment ?? this.sentiment,
        relatedTickers:
            relatedTickers.present ? relatedTickers.value : this.relatedTickers,
        publishedAt: publishedAt ?? this.publishedAt,
        fetchedAt: fetchedAt ?? this.fetchedAt,
        isRead: isRead ?? this.isRead,
        isSaved: isSaved ?? this.isSaved,
        isDismissed: isDismissed ?? this.isDismissed,
      );
  Article copyWithCompanion(ArticlesCompanion data) {
    return Article(
      id: data.id.present ? data.id.value : this.id,
      articleId: data.articleId.present ? data.articleId.value : this.articleId,
      title: data.title.present ? data.title.value : this.title,
      description:
          data.description.present ? data.description.value : this.description,
      url: data.url.present ? data.url.value : this.url,
      imageUrl: data.imageUrl.present ? data.imageUrl.value : this.imageUrl,
      source: data.source.present ? data.source.value : this.source,
      category: data.category.present ? data.category.value : this.category,
      sentiment: data.sentiment.present ? data.sentiment.value : this.sentiment,
      relatedTickers: data.relatedTickers.present
          ? data.relatedTickers.value
          : this.relatedTickers,
      publishedAt:
          data.publishedAt.present ? data.publishedAt.value : this.publishedAt,
      fetchedAt: data.fetchedAt.present ? data.fetchedAt.value : this.fetchedAt,
      isRead: data.isRead.present ? data.isRead.value : this.isRead,
      isSaved: data.isSaved.present ? data.isSaved.value : this.isSaved,
      isDismissed:
          data.isDismissed.present ? data.isDismissed.value : this.isDismissed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Article(')
          ..write('id: $id, ')
          ..write('articleId: $articleId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('url: $url, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('source: $source, ')
          ..write('category: $category, ')
          ..write('sentiment: $sentiment, ')
          ..write('relatedTickers: $relatedTickers, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('isRead: $isRead, ')
          ..write('isSaved: $isSaved, ')
          ..write('isDismissed: $isDismissed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      articleId,
      title,
      description,
      url,
      imageUrl,
      source,
      category,
      sentiment,
      relatedTickers,
      publishedAt,
      fetchedAt,
      isRead,
      isSaved,
      isDismissed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Article &&
          other.id == this.id &&
          other.articleId == this.articleId &&
          other.title == this.title &&
          other.description == this.description &&
          other.url == this.url &&
          other.imageUrl == this.imageUrl &&
          other.source == this.source &&
          other.category == this.category &&
          other.sentiment == this.sentiment &&
          other.relatedTickers == this.relatedTickers &&
          other.publishedAt == this.publishedAt &&
          other.fetchedAt == this.fetchedAt &&
          other.isRead == this.isRead &&
          other.isSaved == this.isSaved &&
          other.isDismissed == this.isDismissed);
}

class ArticlesCompanion extends UpdateCompanion<Article> {
  final Value<int> id;
  final Value<String> articleId;
  final Value<String> title;
  final Value<String?> description;
  final Value<String> url;
  final Value<String?> imageUrl;
  final Value<String> source;
  final Value<String> category;
  final Value<String> sentiment;
  final Value<String?> relatedTickers;
  final Value<int> publishedAt;
  final Value<int> fetchedAt;
  final Value<bool> isRead;
  final Value<bool> isSaved;
  final Value<bool> isDismissed;
  const ArticlesCompanion({
    this.id = const Value.absent(),
    this.articleId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.url = const Value.absent(),
    this.imageUrl = const Value.absent(),
    this.source = const Value.absent(),
    this.category = const Value.absent(),
    this.sentiment = const Value.absent(),
    this.relatedTickers = const Value.absent(),
    this.publishedAt = const Value.absent(),
    this.fetchedAt = const Value.absent(),
    this.isRead = const Value.absent(),
    this.isSaved = const Value.absent(),
    this.isDismissed = const Value.absent(),
  });
  ArticlesCompanion.insert({
    this.id = const Value.absent(),
    required String articleId,
    required String title,
    this.description = const Value.absent(),
    required String url,
    this.imageUrl = const Value.absent(),
    required String source,
    required String category,
    required String sentiment,
    this.relatedTickers = const Value.absent(),
    required int publishedAt,
    required int fetchedAt,
    this.isRead = const Value.absent(),
    this.isSaved = const Value.absent(),
    this.isDismissed = const Value.absent(),
  })  : articleId = Value(articleId),
        title = Value(title),
        url = Value(url),
        source = Value(source),
        category = Value(category),
        sentiment = Value(sentiment),
        publishedAt = Value(publishedAt),
        fetchedAt = Value(fetchedAt);
  static Insertable<Article> custom({
    Expression<int>? id,
    Expression<String>? articleId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<String>? url,
    Expression<String>? imageUrl,
    Expression<String>? source,
    Expression<String>? category,
    Expression<String>? sentiment,
    Expression<String>? relatedTickers,
    Expression<int>? publishedAt,
    Expression<int>? fetchedAt,
    Expression<bool>? isRead,
    Expression<bool>? isSaved,
    Expression<bool>? isDismissed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (articleId != null) 'article_id': articleId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (url != null) 'url': url,
      if (imageUrl != null) 'image_url': imageUrl,
      if (source != null) 'source': source,
      if (category != null) 'category': category,
      if (sentiment != null) 'sentiment': sentiment,
      if (relatedTickers != null) 'related_tickers': relatedTickers,
      if (publishedAt != null) 'published_at': publishedAt,
      if (fetchedAt != null) 'fetched_at': fetchedAt,
      if (isRead != null) 'is_read': isRead,
      if (isSaved != null) 'is_saved': isSaved,
      if (isDismissed != null) 'is_dismissed': isDismissed,
    });
  }

  ArticlesCompanion copyWith(
      {Value<int>? id,
      Value<String>? articleId,
      Value<String>? title,
      Value<String?>? description,
      Value<String>? url,
      Value<String?>? imageUrl,
      Value<String>? source,
      Value<String>? category,
      Value<String>? sentiment,
      Value<String?>? relatedTickers,
      Value<int>? publishedAt,
      Value<int>? fetchedAt,
      Value<bool>? isRead,
      Value<bool>? isSaved,
      Value<bool>? isDismissed}) {
    return ArticlesCompanion(
      id: id ?? this.id,
      articleId: articleId ?? this.articleId,
      title: title ?? this.title,
      description: description ?? this.description,
      url: url ?? this.url,
      imageUrl: imageUrl ?? this.imageUrl,
      source: source ?? this.source,
      category: category ?? this.category,
      sentiment: sentiment ?? this.sentiment,
      relatedTickers: relatedTickers ?? this.relatedTickers,
      publishedAt: publishedAt ?? this.publishedAt,
      fetchedAt: fetchedAt ?? this.fetchedAt,
      isRead: isRead ?? this.isRead,
      isSaved: isSaved ?? this.isSaved,
      isDismissed: isDismissed ?? this.isDismissed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (articleId.present) {
      map['article_id'] = Variable<String>(articleId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (imageUrl.present) {
      map['image_url'] = Variable<String>(imageUrl.value);
    }
    if (source.present) {
      map['source'] = Variable<String>(source.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (sentiment.present) {
      map['sentiment'] = Variable<String>(sentiment.value);
    }
    if (relatedTickers.present) {
      map['related_tickers'] = Variable<String>(relatedTickers.value);
    }
    if (publishedAt.present) {
      map['published_at'] = Variable<int>(publishedAt.value);
    }
    if (fetchedAt.present) {
      map['fetched_at'] = Variable<int>(fetchedAt.value);
    }
    if (isRead.present) {
      map['is_read'] = Variable<bool>(isRead.value);
    }
    if (isSaved.present) {
      map['is_saved'] = Variable<bool>(isSaved.value);
    }
    if (isDismissed.present) {
      map['is_dismissed'] = Variable<bool>(isDismissed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ArticlesCompanion(')
          ..write('id: $id, ')
          ..write('articleId: $articleId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('url: $url, ')
          ..write('imageUrl: $imageUrl, ')
          ..write('source: $source, ')
          ..write('category: $category, ')
          ..write('sentiment: $sentiment, ')
          ..write('relatedTickers: $relatedTickers, ')
          ..write('publishedAt: $publishedAt, ')
          ..write('fetchedAt: $fetchedAt, ')
          ..write('isRead: $isRead, ')
          ..write('isSaved: $isSaved, ')
          ..write('isDismissed: $isDismissed')
          ..write(')'))
        .toString();
  }
}

class $MarketSnapshotsTable extends MarketSnapshots
    with TableInfo<$MarketSnapshotsTable, MarketSnapshot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MarketSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _symbolMeta = const VerificationMeta('symbol');
  @override
  late final GeneratedColumn<String> symbol = GeneratedColumn<String>(
      'symbol', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _changeMeta = const VerificationMeta('change');
  @override
  late final GeneratedColumn<double> change = GeneratedColumn<double>(
      'change', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _changePercentMeta =
      const VerificationMeta('changePercent');
  @override
  late final GeneratedColumn<double> changePercent = GeneratedColumn<double>(
      'change_percent', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _snapshotAtMeta =
      const VerificationMeta('snapshotAt');
  @override
  late final GeneratedColumn<int> snapshotAt = GeneratedColumn<int>(
      'snapshot_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns =>
      [id, symbol, name, price, change, changePercent, snapshotAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'market_snapshots';
  @override
  VerificationContext validateIntegrity(Insertable<MarketSnapshot> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('symbol')) {
      context.handle(_symbolMeta,
          symbol.isAcceptableOrUnknown(data['symbol']!, _symbolMeta));
    } else if (isInserting) {
      context.missing(_symbolMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('change')) {
      context.handle(_changeMeta,
          change.isAcceptableOrUnknown(data['change']!, _changeMeta));
    } else if (isInserting) {
      context.missing(_changeMeta);
    }
    if (data.containsKey('change_percent')) {
      context.handle(
          _changePercentMeta,
          changePercent.isAcceptableOrUnknown(
              data['change_percent']!, _changePercentMeta));
    } else if (isInserting) {
      context.missing(_changePercentMeta);
    }
    if (data.containsKey('snapshot_at')) {
      context.handle(
          _snapshotAtMeta,
          snapshotAt.isAcceptableOrUnknown(
              data['snapshot_at']!, _snapshotAtMeta));
    } else if (isInserting) {
      context.missing(_snapshotAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MarketSnapshot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MarketSnapshot(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      symbol: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}symbol'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      change: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}change'])!,
      changePercent: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}change_percent'])!,
      snapshotAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}snapshot_at'])!,
    );
  }

  @override
  $MarketSnapshotsTable createAlias(String alias) {
    return $MarketSnapshotsTable(attachedDatabase, alias);
  }
}

class MarketSnapshot extends DataClass implements Insertable<MarketSnapshot> {
  final int id;
  final String symbol;
  final String name;
  final double price;
  final double change;
  final double changePercent;
  final int snapshotAt;
  const MarketSnapshot(
      {required this.id,
      required this.symbol,
      required this.name,
      required this.price,
      required this.change,
      required this.changePercent,
      required this.snapshotAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['symbol'] = Variable<String>(symbol);
    map['name'] = Variable<String>(name);
    map['price'] = Variable<double>(price);
    map['change'] = Variable<double>(change);
    map['change_percent'] = Variable<double>(changePercent);
    map['snapshot_at'] = Variable<int>(snapshotAt);
    return map;
  }

  MarketSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return MarketSnapshotsCompanion(
      id: Value(id),
      symbol: Value(symbol),
      name: Value(name),
      price: Value(price),
      change: Value(change),
      changePercent: Value(changePercent),
      snapshotAt: Value(snapshotAt),
    );
  }

  factory MarketSnapshot.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MarketSnapshot(
      id: serializer.fromJson<int>(json['id']),
      symbol: serializer.fromJson<String>(json['symbol']),
      name: serializer.fromJson<String>(json['name']),
      price: serializer.fromJson<double>(json['price']),
      change: serializer.fromJson<double>(json['change']),
      changePercent: serializer.fromJson<double>(json['changePercent']),
      snapshotAt: serializer.fromJson<int>(json['snapshotAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'symbol': serializer.toJson<String>(symbol),
      'name': serializer.toJson<String>(name),
      'price': serializer.toJson<double>(price),
      'change': serializer.toJson<double>(change),
      'changePercent': serializer.toJson<double>(changePercent),
      'snapshotAt': serializer.toJson<int>(snapshotAt),
    };
  }

  MarketSnapshot copyWith(
          {int? id,
          String? symbol,
          String? name,
          double? price,
          double? change,
          double? changePercent,
          int? snapshotAt}) =>
      MarketSnapshot(
        id: id ?? this.id,
        symbol: symbol ?? this.symbol,
        name: name ?? this.name,
        price: price ?? this.price,
        change: change ?? this.change,
        changePercent: changePercent ?? this.changePercent,
        snapshotAt: snapshotAt ?? this.snapshotAt,
      );
  MarketSnapshot copyWithCompanion(MarketSnapshotsCompanion data) {
    return MarketSnapshot(
      id: data.id.present ? data.id.value : this.id,
      symbol: data.symbol.present ? data.symbol.value : this.symbol,
      name: data.name.present ? data.name.value : this.name,
      price: data.price.present ? data.price.value : this.price,
      change: data.change.present ? data.change.value : this.change,
      changePercent: data.changePercent.present
          ? data.changePercent.value
          : this.changePercent,
      snapshotAt:
          data.snapshotAt.present ? data.snapshotAt.value : this.snapshotAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MarketSnapshot(')
          ..write('id: $id, ')
          ..write('symbol: $symbol, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('change: $change, ')
          ..write('changePercent: $changePercent, ')
          ..write('snapshotAt: $snapshotAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, symbol, name, price, change, changePercent, snapshotAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MarketSnapshot &&
          other.id == this.id &&
          other.symbol == this.symbol &&
          other.name == this.name &&
          other.price == this.price &&
          other.change == this.change &&
          other.changePercent == this.changePercent &&
          other.snapshotAt == this.snapshotAt);
}

class MarketSnapshotsCompanion extends UpdateCompanion<MarketSnapshot> {
  final Value<int> id;
  final Value<String> symbol;
  final Value<String> name;
  final Value<double> price;
  final Value<double> change;
  final Value<double> changePercent;
  final Value<int> snapshotAt;
  const MarketSnapshotsCompanion({
    this.id = const Value.absent(),
    this.symbol = const Value.absent(),
    this.name = const Value.absent(),
    this.price = const Value.absent(),
    this.change = const Value.absent(),
    this.changePercent = const Value.absent(),
    this.snapshotAt = const Value.absent(),
  });
  MarketSnapshotsCompanion.insert({
    this.id = const Value.absent(),
    required String symbol,
    required String name,
    required double price,
    required double change,
    required double changePercent,
    required int snapshotAt,
  })  : symbol = Value(symbol),
        name = Value(name),
        price = Value(price),
        change = Value(change),
        changePercent = Value(changePercent),
        snapshotAt = Value(snapshotAt);
  static Insertable<MarketSnapshot> custom({
    Expression<int>? id,
    Expression<String>? symbol,
    Expression<String>? name,
    Expression<double>? price,
    Expression<double>? change,
    Expression<double>? changePercent,
    Expression<int>? snapshotAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (symbol != null) 'symbol': symbol,
      if (name != null) 'name': name,
      if (price != null) 'price': price,
      if (change != null) 'change': change,
      if (changePercent != null) 'change_percent': changePercent,
      if (snapshotAt != null) 'snapshot_at': snapshotAt,
    });
  }

  MarketSnapshotsCompanion copyWith(
      {Value<int>? id,
      Value<String>? symbol,
      Value<String>? name,
      Value<double>? price,
      Value<double>? change,
      Value<double>? changePercent,
      Value<int>? snapshotAt}) {
    return MarketSnapshotsCompanion(
      id: id ?? this.id,
      symbol: symbol ?? this.symbol,
      name: name ?? this.name,
      price: price ?? this.price,
      change: change ?? this.change,
      changePercent: changePercent ?? this.changePercent,
      snapshotAt: snapshotAt ?? this.snapshotAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (symbol.present) {
      map['symbol'] = Variable<String>(symbol.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (change.present) {
      map['change'] = Variable<double>(change.value);
    }
    if (changePercent.present) {
      map['change_percent'] = Variable<double>(changePercent.value);
    }
    if (snapshotAt.present) {
      map['snapshot_at'] = Variable<int>(snapshotAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MarketSnapshotsCompanion(')
          ..write('id: $id, ')
          ..write('symbol: $symbol, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('change: $change, ')
          ..write('changePercent: $changePercent, ')
          ..write('snapshotAt: $snapshotAt')
          ..write(')'))
        .toString();
  }
}

class $UserPreferencesTable extends UserPreferences
    with TableInfo<$UserPreferencesTable, UserPreference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserPreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
      'key', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
      'value', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_preferences';
  @override
  VerificationContext validateIntegrity(Insertable<UserPreference> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('key')) {
      context.handle(
          _keyMeta, key.isAcceptableOrUnknown(data['key']!, _keyMeta));
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
          _valueMeta, value.isAcceptableOrUnknown(data['value']!, _valueMeta));
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserPreference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserPreference(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      key: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}key'])!,
      value: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}value'])!,
    );
  }

  @override
  $UserPreferencesTable createAlias(String alias) {
    return $UserPreferencesTable(attachedDatabase, alias);
  }
}

class UserPreference extends DataClass implements Insertable<UserPreference> {
  final int id;
  final String key;
  final String value;
  const UserPreference(
      {required this.id, required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  UserPreferencesCompanion toCompanion(bool nullToAbsent) {
    return UserPreferencesCompanion(
      id: Value(id),
      key: Value(key),
      value: Value(value),
    );
  }

  factory UserPreference.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserPreference(
      id: serializer.fromJson<int>(json['id']),
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  UserPreference copyWith({int? id, String? key, String? value}) =>
      UserPreference(
        id: id ?? this.id,
        key: key ?? this.key,
        value: value ?? this.value,
      );
  UserPreference copyWithCompanion(UserPreferencesCompanion data) {
    return UserPreference(
      id: data.id.present ? data.id.value : this.id,
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserPreference(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserPreference &&
          other.id == this.id &&
          other.key == this.key &&
          other.value == this.value);
}

class UserPreferencesCompanion extends UpdateCompanion<UserPreference> {
  final Value<int> id;
  final Value<String> key;
  final Value<String> value;
  const UserPreferencesCompanion({
    this.id = const Value.absent(),
    this.key = const Value.absent(),
    this.value = const Value.absent(),
  });
  UserPreferencesCompanion.insert({
    this.id = const Value.absent(),
    required String key,
    required String value,
  })  : key = Value(key),
        value = Value(value);
  static Insertable<UserPreference> custom({
    Expression<int>? id,
    Expression<String>? key,
    Expression<String>? value,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (key != null) 'key': key,
      if (value != null) 'value': value,
    });
  }

  UserPreferencesCompanion copyWith(
      {Value<int>? id, Value<String>? key, Value<String>? value}) {
    return UserPreferencesCompanion(
      id: id ?? this.id,
      key: key ?? this.key,
      value: value ?? this.value,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserPreferencesCompanion(')
          ..write('id: $id, ')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }
}

class $ReadHistoryTable extends ReadHistory
    with TableInfo<$ReadHistoryTable, ReadHistoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReadHistoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _articleIdMeta =
      const VerificationMeta('articleId');
  @override
  late final GeneratedColumn<String> articleId = GeneratedColumn<String>(
      'article_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _readAtMeta = const VerificationMeta('readAt');
  @override
  late final GeneratedColumn<int> readAt = GeneratedColumn<int>(
      'read_at', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, articleId, readAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'read_history';
  @override
  VerificationContext validateIntegrity(Insertable<ReadHistoryData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('article_id')) {
      context.handle(_articleIdMeta,
          articleId.isAcceptableOrUnknown(data['article_id']!, _articleIdMeta));
    } else if (isInserting) {
      context.missing(_articleIdMeta);
    }
    if (data.containsKey('read_at')) {
      context.handle(_readAtMeta,
          readAt.isAcceptableOrUnknown(data['read_at']!, _readAtMeta));
    } else if (isInserting) {
      context.missing(_readAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReadHistoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReadHistoryData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      articleId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}article_id'])!,
      readAt: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}read_at'])!,
    );
  }

  @override
  $ReadHistoryTable createAlias(String alias) {
    return $ReadHistoryTable(attachedDatabase, alias);
  }
}

class ReadHistoryData extends DataClass implements Insertable<ReadHistoryData> {
  final int id;
  final String articleId;
  final int readAt;
  const ReadHistoryData(
      {required this.id, required this.articleId, required this.readAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['article_id'] = Variable<String>(articleId);
    map['read_at'] = Variable<int>(readAt);
    return map;
  }

  ReadHistoryCompanion toCompanion(bool nullToAbsent) {
    return ReadHistoryCompanion(
      id: Value(id),
      articleId: Value(articleId),
      readAt: Value(readAt),
    );
  }

  factory ReadHistoryData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReadHistoryData(
      id: serializer.fromJson<int>(json['id']),
      articleId: serializer.fromJson<String>(json['articleId']),
      readAt: serializer.fromJson<int>(json['readAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'articleId': serializer.toJson<String>(articleId),
      'readAt': serializer.toJson<int>(readAt),
    };
  }

  ReadHistoryData copyWith({int? id, String? articleId, int? readAt}) =>
      ReadHistoryData(
        id: id ?? this.id,
        articleId: articleId ?? this.articleId,
        readAt: readAt ?? this.readAt,
      );
  ReadHistoryData copyWithCompanion(ReadHistoryCompanion data) {
    return ReadHistoryData(
      id: data.id.present ? data.id.value : this.id,
      articleId: data.articleId.present ? data.articleId.value : this.articleId,
      readAt: data.readAt.present ? data.readAt.value : this.readAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReadHistoryData(')
          ..write('id: $id, ')
          ..write('articleId: $articleId, ')
          ..write('readAt: $readAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, articleId, readAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReadHistoryData &&
          other.id == this.id &&
          other.articleId == this.articleId &&
          other.readAt == this.readAt);
}

class ReadHistoryCompanion extends UpdateCompanion<ReadHistoryData> {
  final Value<int> id;
  final Value<String> articleId;
  final Value<int> readAt;
  const ReadHistoryCompanion({
    this.id = const Value.absent(),
    this.articleId = const Value.absent(),
    this.readAt = const Value.absent(),
  });
  ReadHistoryCompanion.insert({
    this.id = const Value.absent(),
    required String articleId,
    required int readAt,
  })  : articleId = Value(articleId),
        readAt = Value(readAt);
  static Insertable<ReadHistoryData> custom({
    Expression<int>? id,
    Expression<String>? articleId,
    Expression<int>? readAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (articleId != null) 'article_id': articleId,
      if (readAt != null) 'read_at': readAt,
    });
  }

  ReadHistoryCompanion copyWith(
      {Value<int>? id, Value<String>? articleId, Value<int>? readAt}) {
    return ReadHistoryCompanion(
      id: id ?? this.id,
      articleId: articleId ?? this.articleId,
      readAt: readAt ?? this.readAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (articleId.present) {
      map['article_id'] = Variable<String>(articleId.value);
    }
    if (readAt.present) {
      map['read_at'] = Variable<int>(readAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReadHistoryCompanion(')
          ..write('id: $id, ')
          ..write('articleId: $articleId, ')
          ..write('readAt: $readAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ArticlesTable articles = $ArticlesTable(this);
  late final $MarketSnapshotsTable marketSnapshots =
      $MarketSnapshotsTable(this);
  late final $UserPreferencesTable userPreferences =
      $UserPreferencesTable(this);
  late final $ReadHistoryTable readHistory = $ReadHistoryTable(this);
  late final ArticlesDao articlesDao = ArticlesDao(this as AppDatabase);
  late final MarketDao marketDao = MarketDao(this as AppDatabase);
  late final PreferencesDao preferencesDao =
      PreferencesDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [articles, marketSnapshots, userPreferences, readHistory];
}

typedef $$ArticlesTableCreateCompanionBuilder = ArticlesCompanion Function({
  Value<int> id,
  required String articleId,
  required String title,
  Value<String?> description,
  required String url,
  Value<String?> imageUrl,
  required String source,
  required String category,
  required String sentiment,
  Value<String?> relatedTickers,
  required int publishedAt,
  required int fetchedAt,
  Value<bool> isRead,
  Value<bool> isSaved,
  Value<bool> isDismissed,
});
typedef $$ArticlesTableUpdateCompanionBuilder = ArticlesCompanion Function({
  Value<int> id,
  Value<String> articleId,
  Value<String> title,
  Value<String?> description,
  Value<String> url,
  Value<String?> imageUrl,
  Value<String> source,
  Value<String> category,
  Value<String> sentiment,
  Value<String?> relatedTickers,
  Value<int> publishedAt,
  Value<int> fetchedAt,
  Value<bool> isRead,
  Value<bool> isSaved,
  Value<bool> isDismissed,
});

class $$ArticlesTableFilterComposer
    extends Composer<_$AppDatabase, $ArticlesTable> {
  $$ArticlesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get articleId => $composableBuilder(
      column: $table.articleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get sentiment => $composableBuilder(
      column: $table.sentiment, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get relatedTickers => $composableBuilder(
      column: $table.relatedTickers,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get publishedAt => $composableBuilder(
      column: $table.publishedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get fetchedAt => $composableBuilder(
      column: $table.fetchedAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isRead => $composableBuilder(
      column: $table.isRead, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isSaved => $composableBuilder(
      column: $table.isSaved, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDismissed => $composableBuilder(
      column: $table.isDismissed, builder: (column) => ColumnFilters(column));
}

class $$ArticlesTableOrderingComposer
    extends Composer<_$AppDatabase, $ArticlesTable> {
  $$ArticlesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get articleId => $composableBuilder(
      column: $table.articleId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get url => $composableBuilder(
      column: $table.url, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get imageUrl => $composableBuilder(
      column: $table.imageUrl, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get source => $composableBuilder(
      column: $table.source, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get sentiment => $composableBuilder(
      column: $table.sentiment, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get relatedTickers => $composableBuilder(
      column: $table.relatedTickers,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get publishedAt => $composableBuilder(
      column: $table.publishedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get fetchedAt => $composableBuilder(
      column: $table.fetchedAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isRead => $composableBuilder(
      column: $table.isRead, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isSaved => $composableBuilder(
      column: $table.isSaved, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDismissed => $composableBuilder(
      column: $table.isDismissed, builder: (column) => ColumnOrderings(column));
}

class $$ArticlesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ArticlesTable> {
  $$ArticlesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get articleId =>
      $composableBuilder(column: $table.articleId, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
      column: $table.description, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get imageUrl =>
      $composableBuilder(column: $table.imageUrl, builder: (column) => column);

  GeneratedColumn<String> get source =>
      $composableBuilder(column: $table.source, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<String> get sentiment =>
      $composableBuilder(column: $table.sentiment, builder: (column) => column);

  GeneratedColumn<String> get relatedTickers => $composableBuilder(
      column: $table.relatedTickers, builder: (column) => column);

  GeneratedColumn<int> get publishedAt => $composableBuilder(
      column: $table.publishedAt, builder: (column) => column);

  GeneratedColumn<int> get fetchedAt =>
      $composableBuilder(column: $table.fetchedAt, builder: (column) => column);

  GeneratedColumn<bool> get isRead =>
      $composableBuilder(column: $table.isRead, builder: (column) => column);

  GeneratedColumn<bool> get isSaved =>
      $composableBuilder(column: $table.isSaved, builder: (column) => column);

  GeneratedColumn<bool> get isDismissed => $composableBuilder(
      column: $table.isDismissed, builder: (column) => column);
}

class $$ArticlesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ArticlesTable,
    Article,
    $$ArticlesTableFilterComposer,
    $$ArticlesTableOrderingComposer,
    $$ArticlesTableAnnotationComposer,
    $$ArticlesTableCreateCompanionBuilder,
    $$ArticlesTableUpdateCompanionBuilder,
    (Article, BaseReferences<_$AppDatabase, $ArticlesTable, Article>),
    Article,
    PrefetchHooks Function()> {
  $$ArticlesTableTableManager(_$AppDatabase db, $ArticlesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ArticlesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ArticlesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ArticlesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> articleId = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String?> description = const Value.absent(),
            Value<String> url = const Value.absent(),
            Value<String?> imageUrl = const Value.absent(),
            Value<String> source = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<String> sentiment = const Value.absent(),
            Value<String?> relatedTickers = const Value.absent(),
            Value<int> publishedAt = const Value.absent(),
            Value<int> fetchedAt = const Value.absent(),
            Value<bool> isRead = const Value.absent(),
            Value<bool> isSaved = const Value.absent(),
            Value<bool> isDismissed = const Value.absent(),
          }) =>
              ArticlesCompanion(
            id: id,
            articleId: articleId,
            title: title,
            description: description,
            url: url,
            imageUrl: imageUrl,
            source: source,
            category: category,
            sentiment: sentiment,
            relatedTickers: relatedTickers,
            publishedAt: publishedAt,
            fetchedAt: fetchedAt,
            isRead: isRead,
            isSaved: isSaved,
            isDismissed: isDismissed,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String articleId,
            required String title,
            Value<String?> description = const Value.absent(),
            required String url,
            Value<String?> imageUrl = const Value.absent(),
            required String source,
            required String category,
            required String sentiment,
            Value<String?> relatedTickers = const Value.absent(),
            required int publishedAt,
            required int fetchedAt,
            Value<bool> isRead = const Value.absent(),
            Value<bool> isSaved = const Value.absent(),
            Value<bool> isDismissed = const Value.absent(),
          }) =>
              ArticlesCompanion.insert(
            id: id,
            articleId: articleId,
            title: title,
            description: description,
            url: url,
            imageUrl: imageUrl,
            source: source,
            category: category,
            sentiment: sentiment,
            relatedTickers: relatedTickers,
            publishedAt: publishedAt,
            fetchedAt: fetchedAt,
            isRead: isRead,
            isSaved: isSaved,
            isDismissed: isDismissed,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ArticlesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ArticlesTable,
    Article,
    $$ArticlesTableFilterComposer,
    $$ArticlesTableOrderingComposer,
    $$ArticlesTableAnnotationComposer,
    $$ArticlesTableCreateCompanionBuilder,
    $$ArticlesTableUpdateCompanionBuilder,
    (Article, BaseReferences<_$AppDatabase, $ArticlesTable, Article>),
    Article,
    PrefetchHooks Function()>;
typedef $$MarketSnapshotsTableCreateCompanionBuilder = MarketSnapshotsCompanion
    Function({
  Value<int> id,
  required String symbol,
  required String name,
  required double price,
  required double change,
  required double changePercent,
  required int snapshotAt,
});
typedef $$MarketSnapshotsTableUpdateCompanionBuilder = MarketSnapshotsCompanion
    Function({
  Value<int> id,
  Value<String> symbol,
  Value<String> name,
  Value<double> price,
  Value<double> change,
  Value<double> changePercent,
  Value<int> snapshotAt,
});

class $$MarketSnapshotsTableFilterComposer
    extends Composer<_$AppDatabase, $MarketSnapshotsTable> {
  $$MarketSnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get change => $composableBuilder(
      column: $table.change, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get changePercent => $composableBuilder(
      column: $table.changePercent, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get snapshotAt => $composableBuilder(
      column: $table.snapshotAt, builder: (column) => ColumnFilters(column));
}

class $$MarketSnapshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $MarketSnapshotsTable> {
  $$MarketSnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get symbol => $composableBuilder(
      column: $table.symbol, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get change => $composableBuilder(
      column: $table.change, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get changePercent => $composableBuilder(
      column: $table.changePercent,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get snapshotAt => $composableBuilder(
      column: $table.snapshotAt, builder: (column) => ColumnOrderings(column));
}

class $$MarketSnapshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MarketSnapshotsTable> {
  $$MarketSnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get symbol =>
      $composableBuilder(column: $table.symbol, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<double> get change =>
      $composableBuilder(column: $table.change, builder: (column) => column);

  GeneratedColumn<double> get changePercent => $composableBuilder(
      column: $table.changePercent, builder: (column) => column);

  GeneratedColumn<int> get snapshotAt => $composableBuilder(
      column: $table.snapshotAt, builder: (column) => column);
}

class $$MarketSnapshotsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MarketSnapshotsTable,
    MarketSnapshot,
    $$MarketSnapshotsTableFilterComposer,
    $$MarketSnapshotsTableOrderingComposer,
    $$MarketSnapshotsTableAnnotationComposer,
    $$MarketSnapshotsTableCreateCompanionBuilder,
    $$MarketSnapshotsTableUpdateCompanionBuilder,
    (
      MarketSnapshot,
      BaseReferences<_$AppDatabase, $MarketSnapshotsTable, MarketSnapshot>
    ),
    MarketSnapshot,
    PrefetchHooks Function()> {
  $$MarketSnapshotsTableTableManager(
      _$AppDatabase db, $MarketSnapshotsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MarketSnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MarketSnapshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MarketSnapshotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> symbol = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<double> change = const Value.absent(),
            Value<double> changePercent = const Value.absent(),
            Value<int> snapshotAt = const Value.absent(),
          }) =>
              MarketSnapshotsCompanion(
            id: id,
            symbol: symbol,
            name: name,
            price: price,
            change: change,
            changePercent: changePercent,
            snapshotAt: snapshotAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String symbol,
            required String name,
            required double price,
            required double change,
            required double changePercent,
            required int snapshotAt,
          }) =>
              MarketSnapshotsCompanion.insert(
            id: id,
            symbol: symbol,
            name: name,
            price: price,
            change: change,
            changePercent: changePercent,
            snapshotAt: snapshotAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MarketSnapshotsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MarketSnapshotsTable,
    MarketSnapshot,
    $$MarketSnapshotsTableFilterComposer,
    $$MarketSnapshotsTableOrderingComposer,
    $$MarketSnapshotsTableAnnotationComposer,
    $$MarketSnapshotsTableCreateCompanionBuilder,
    $$MarketSnapshotsTableUpdateCompanionBuilder,
    (
      MarketSnapshot,
      BaseReferences<_$AppDatabase, $MarketSnapshotsTable, MarketSnapshot>
    ),
    MarketSnapshot,
    PrefetchHooks Function()>;
typedef $$UserPreferencesTableCreateCompanionBuilder = UserPreferencesCompanion
    Function({
  Value<int> id,
  required String key,
  required String value,
});
typedef $$UserPreferencesTableUpdateCompanionBuilder = UserPreferencesCompanion
    Function({
  Value<int> id,
  Value<String> key,
  Value<String> value,
});

class $$UserPreferencesTableFilterComposer
    extends Composer<_$AppDatabase, $UserPreferencesTable> {
  $$UserPreferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnFilters(column));
}

class $$UserPreferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserPreferencesTable> {
  $$UserPreferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get key => $composableBuilder(
      column: $table.key, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get value => $composableBuilder(
      column: $table.value, builder: (column) => ColumnOrderings(column));
}

class $$UserPreferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserPreferencesTable> {
  $$UserPreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$UserPreferencesTableTableManager extends RootTableManager<
    _$AppDatabase,
    $UserPreferencesTable,
    UserPreference,
    $$UserPreferencesTableFilterComposer,
    $$UserPreferencesTableOrderingComposer,
    $$UserPreferencesTableAnnotationComposer,
    $$UserPreferencesTableCreateCompanionBuilder,
    $$UserPreferencesTableUpdateCompanionBuilder,
    (
      UserPreference,
      BaseReferences<_$AppDatabase, $UserPreferencesTable, UserPreference>
    ),
    UserPreference,
    PrefetchHooks Function()> {
  $$UserPreferencesTableTableManager(
      _$AppDatabase db, $UserPreferencesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserPreferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserPreferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserPreferencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
          }) =>
              UserPreferencesCompanion(
            id: id,
            key: key,
            value: value,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String key,
            required String value,
          }) =>
              UserPreferencesCompanion.insert(
            id: id,
            key: key,
            value: value,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$UserPreferencesTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $UserPreferencesTable,
    UserPreference,
    $$UserPreferencesTableFilterComposer,
    $$UserPreferencesTableOrderingComposer,
    $$UserPreferencesTableAnnotationComposer,
    $$UserPreferencesTableCreateCompanionBuilder,
    $$UserPreferencesTableUpdateCompanionBuilder,
    (
      UserPreference,
      BaseReferences<_$AppDatabase, $UserPreferencesTable, UserPreference>
    ),
    UserPreference,
    PrefetchHooks Function()>;
typedef $$ReadHistoryTableCreateCompanionBuilder = ReadHistoryCompanion
    Function({
  Value<int> id,
  required String articleId,
  required int readAt,
});
typedef $$ReadHistoryTableUpdateCompanionBuilder = ReadHistoryCompanion
    Function({
  Value<int> id,
  Value<String> articleId,
  Value<int> readAt,
});

class $$ReadHistoryTableFilterComposer
    extends Composer<_$AppDatabase, $ReadHistoryTable> {
  $$ReadHistoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get articleId => $composableBuilder(
      column: $table.articleId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get readAt => $composableBuilder(
      column: $table.readAt, builder: (column) => ColumnFilters(column));
}

class $$ReadHistoryTableOrderingComposer
    extends Composer<_$AppDatabase, $ReadHistoryTable> {
  $$ReadHistoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get articleId => $composableBuilder(
      column: $table.articleId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get readAt => $composableBuilder(
      column: $table.readAt, builder: (column) => ColumnOrderings(column));
}

class $$ReadHistoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReadHistoryTable> {
  $$ReadHistoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get articleId =>
      $composableBuilder(column: $table.articleId, builder: (column) => column);

  GeneratedColumn<int> get readAt =>
      $composableBuilder(column: $table.readAt, builder: (column) => column);
}

class $$ReadHistoryTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ReadHistoryTable,
    ReadHistoryData,
    $$ReadHistoryTableFilterComposer,
    $$ReadHistoryTableOrderingComposer,
    $$ReadHistoryTableAnnotationComposer,
    $$ReadHistoryTableCreateCompanionBuilder,
    $$ReadHistoryTableUpdateCompanionBuilder,
    (
      ReadHistoryData,
      BaseReferences<_$AppDatabase, $ReadHistoryTable, ReadHistoryData>
    ),
    ReadHistoryData,
    PrefetchHooks Function()> {
  $$ReadHistoryTableTableManager(_$AppDatabase db, $ReadHistoryTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReadHistoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReadHistoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReadHistoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> articleId = const Value.absent(),
            Value<int> readAt = const Value.absent(),
          }) =>
              ReadHistoryCompanion(
            id: id,
            articleId: articleId,
            readAt: readAt,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String articleId,
            required int readAt,
          }) =>
              ReadHistoryCompanion.insert(
            id: id,
            articleId: articleId,
            readAt: readAt,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ReadHistoryTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ReadHistoryTable,
    ReadHistoryData,
    $$ReadHistoryTableFilterComposer,
    $$ReadHistoryTableOrderingComposer,
    $$ReadHistoryTableAnnotationComposer,
    $$ReadHistoryTableCreateCompanionBuilder,
    $$ReadHistoryTableUpdateCompanionBuilder,
    (
      ReadHistoryData,
      BaseReferences<_$AppDatabase, $ReadHistoryTable, ReadHistoryData>
    ),
    ReadHistoryData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ArticlesTableTableManager get articles =>
      $$ArticlesTableTableManager(_db, _db.articles);
  $$MarketSnapshotsTableTableManager get marketSnapshots =>
      $$MarketSnapshotsTableTableManager(_db, _db.marketSnapshots);
  $$UserPreferencesTableTableManager get userPreferences =>
      $$UserPreferencesTableTableManager(_db, _db.userPreferences);
  $$ReadHistoryTableTableManager get readHistory =>
      $$ReadHistoryTableTableManager(_db, _db.readHistory);
}
