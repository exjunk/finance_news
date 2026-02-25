// lib/data/datasources/local/daos/preferences_dao.dart
import 'package:drift/drift.dart';
import '../database.dart';

part 'preferences_dao.g.dart';

@DriftAccessor(tables: [UserPreferences])
class PreferencesDao extends DatabaseAccessor<AppDatabase>
    with _$PreferencesDaoMixin {
  PreferencesDao(super.db);

  Future<void> setPreference(String key, String value) async {
    await into(userPreferences).insertOnConflictUpdate(
      UserPreferencesCompanion(key: Value(key), value: Value(value)),
    );
  }

  Future<String?> getPreference(String key) async {
    final row = await (select(userPreferences)
          ..where((p) => p.key.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  Future<void> deletePreference(String key) async {
    await (delete(userPreferences)..where((p) => p.key.equals(key))).go();
  }

  Future<Map<String, String>> getAllPreferences() async {
    final rows = await select(userPreferences).get();
    return {for (final row in rows) row.key: row.value};
  }
}
