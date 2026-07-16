import 'package:flutter_test/flutter_test.dart';
import 'package:lumina/core/error/app_exception.dart';
import 'package:lumina/features/favorites/data/datasources/favorites_local_data_source.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _storageKey = 'favorite_post_ids';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  FavoritesLocalDataSource dataSourceWith(List<String>? storedEntries) {
    SharedPreferences.setMockInitialValues({_storageKey: ?storedEntries});
    return SharedPreferencesFavoritesDataSource(
      SharedPreferences.getInstance(),
    );
  }

  Future<List<String>?> storedList() async =>
      (await SharedPreferences.getInstance()).getStringList(_storageKey);

  group('getFavoritePostIds', () {
    test('maps a storage read error to UnexpectedException', () async {
      final dataSource = SharedPreferencesFavoritesDataSource(
        Future<SharedPreferences>.error(Exception('storage unavailable')),
      );

      await expectLater(
        dataSource.getFavoritePostIds(),
        throwsA(isA<UnexpectedException>()),
      );
    });

    test('returns an empty set when nothing is stored', () async {
      final dataSource = dataSourceWith(null);

      expect(await dataSource.getFavoritePostIds(), <int>{});
    });

    test('restores stored IDs as integers', () async {
      final dataSource = dataSourceWith(['1', '2']);

      expect(await dataSource.getFavoritePostIds(), {1, 2});
    });

    test('collapses duplicate entries into a set', () async {
      final dataSource = dataSourceWith(['2', '2', '1']);

      expect(await dataSource.getFavoritePostIds(), {1, 2});
    });

    test('drops malformed and zero entries, keeping negative IDs', () async {
      final dataSource = dataSourceWith(['2', 'abc', '-1', '0', '1.5', '1']);

      expect(await dataSource.getFavoritePostIds(), {-1, 1, 2});
    });
  });

  group('addFavorite', () {
    test('maps a storage write error to UnexpectedException', () async {
      final dataSource = SharedPreferencesFavoritesDataSource(
        Future<SharedPreferences>.error(Exception('storage unavailable')),
      );

      await expectLater(
        dataSource.addFavorite(1),
        throwsA(isA<UnexpectedException>()),
      );
    });

    test('persists the new ID', () async {
      final dataSource = dataSourceWith(['1']);

      await dataSource.addFavorite(3);

      expect(await storedList(), ['1', '3']);
    });

    test('writes IDs in ascending order', () async {
      final dataSource = dataSourceWith(['3', '1']);

      await dataSource.addFavorite(2);

      expect(await storedList(), ['1', '2', '3']);
    });

    test('writes back the cleaned set, dropping malformed entries', () async {
      final dataSource = dataSourceWith(['2', 'abc', '0', '1']);

      await dataSource.addFavorite(3);

      expect(await storedList(), ['1', '2', '3']);
    });

    test('persists negative IDs of locally created posts', () async {
      final dataSource = dataSourceWith(['1']);

      await dataSource.addFavorite(-4);

      expect(await storedList(), ['-4', '1']);
    });

    test('rejects the zero sentinel without writing', () async {
      final dataSource = dataSourceWith(['1']);

      await expectLater(
        dataSource.addFavorite(0),
        throwsA(isA<NotFoundException>()),
      );
      expect(await storedList(), ['1']);
    });
  });

  group('removeFavorite', () {
    test('persists the removal', () async {
      final dataSource = dataSourceWith(['1', '2']);

      await dataSource.removeFavorite(2);

      expect(await storedList(), ['1']);
    });

    test('rejects the zero sentinel without writing', () async {
      final dataSource = dataSourceWith(['1']);

      await expectLater(
        dataSource.removeFavorite(0),
        throwsA(isA<NotFoundException>()),
      );
      expect(await storedList(), ['1']);
    });
  });
}
