// lib/data/datasources/local/database.dart
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'daos/articles_dao.dart';
import 'daos/market_dao.dart';
import 'daos/preferences_dao.dart';

part 'database.g.dart';

// ─────────────────────── Table Definitions ───────────────────────

class Articles extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get articleId => text().unique()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  TextColumn get url => text()();
  TextColumn get imageUrl => text().nullable()();
  TextColumn get source => text()();
  TextColumn get category => text()();
  TextColumn get sentiment => text()(); // bull | bear | neutral
  TextColumn get relatedTickers => text().nullable()(); // JSON array
  IntColumn get publishedAt => integer()(); // unix timestamp
  IntColumn get fetchedAt => integer()(); // unix timestamp
  BoolColumn get isRead =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isSaved =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get isDismissed =>
      boolean().withDefault(const Constant(false))();
}

class MarketSnapshots extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get symbol => text()();
  TextColumn get name => text()();
  RealColumn get price => real()();
  RealColumn get change => real()();
  RealColumn get changePercent => real()();
  IntColumn get snapshotAt => integer()(); // unix timestamp
}

class UserPreferences extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get key => text().unique()();
  TextColumn get value => text()();
}

class ReadHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get articleId => text().unique()();
  IntColumn get readAt => integer()(); // unix timestamp
}

// ─────────────────────── Database ───────────────────────

@DriftDatabase(
  tables: [Articles, MarketSnapshots, UserPreferences, ReadHistory],
  daos: [ArticlesDao, MarketDao, PreferencesDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'stockswipe.db'));
      return NativeDatabase.createInBackground(file);
    });
  }
}
