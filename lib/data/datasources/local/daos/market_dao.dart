// lib/data/datasources/local/daos/market_dao.dart
import 'package:drift/drift.dart';
import '../database.dart';

part 'market_dao.g.dart';

@DriftAccessor(tables: [MarketSnapshots])
class MarketDao extends DatabaseAccessor<AppDatabase> with _$MarketDaoMixin {
  MarketDao(super.db);

  Future<void> upsertSnapshot(MarketSnapshotsCompanion snapshot) async {
    await into(marketSnapshots).insertOnConflictUpdate(snapshot);
  }

  Future<void> upsertSnapshots(List<MarketSnapshotsCompanion> rows) async {
    await batch((b) {
      for (final row in rows) {
        b.insert(marketSnapshots, row, mode: InsertMode.insertOrReplace);
      }
    });
  }

  Future<List<MarketSnapshot>> getAllSnapshots() =>
      (select(marketSnapshots)
            ..orderBy([(m) => OrderingTerm.desc(m.snapshotAt)]))
          .get();

  Future<MarketSnapshot?> getSnapshotBySymbol(String symbol) =>
      (select(marketSnapshots)..where((m) => m.symbol.equals(symbol)))
          .getSingleOrNull();

  Future<void> clearSnapshots() => delete(marketSnapshots).go();
}
