import 'package:flutter_test/flutter_test.dart';
import 'package:lumina/core/error/app_exception.dart';
import 'package:lumina/core/error/app_failure.dart';
import 'package:lumina/features/favorites/data/datasources/favorites_local_data_source.dart';
import 'package:lumina/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class _MockFavoritesLocalDataSource extends Mock
    implements FavoritesLocalDataSource {}

void main() {
  late _MockFavoritesLocalDataSource dataSource;
  late FavoritesRepositoryImpl repository;

  setUp(() {
    dataSource = _MockFavoritesLocalDataSource();
    repository = FavoritesRepositoryImpl(dataSource);
  });

  group('getFavoritePostIds', () {
    test('returns the IDs from the data source', () async {
      when(
        () => dataSource.getFavoritePostIds(),
      ).thenAnswer((_) async => {1, 3});

      expect(await repository.getFavoritePostIds(), {1, 3});
    });

    test('maps ParsingException to DataParsingFailure', () {
      when(
        () => dataSource.getFavoritePostIds(),
      ).thenThrow(const ParsingException());

      expect(
        repository.getFavoritePostIds(),
        throwsA(isA<DataParsingFailure>()),
      );
    });
  });

  group('addFavorite', () {
    test('delegates to the data source', () async {
      when(() => dataSource.addFavorite(5)).thenAnswer((_) async {});

      await repository.addFavorite(5);

      verify(() => dataSource.addFavorite(5)).called(1);
    });

    test('maps UnexpectedException to UnexpectedFailure', () {
      when(
        () => dataSource.addFavorite(5),
      ).thenThrow(const UnexpectedException());

      expect(repository.addFavorite(5), throwsA(isA<UnexpectedFailure>()));
    });

    test('maps the invalid-ID exception to NotFoundFailure', () {
      when(
        () => dataSource.addFavorite(0),
      ).thenThrow(const NotFoundException('Invalid post id: 0'));

      expect(repository.addFavorite(0), throwsA(isA<NotFoundFailure>()));
    });
  });

  group('removeFavorite', () {
    test('delegates to the data source', () async {
      when(() => dataSource.removeFavorite(5)).thenAnswer((_) async {});

      await repository.removeFavorite(5);

      verify(() => dataSource.removeFavorite(5)).called(1);
    });

    test('maps UnexpectedException to UnexpectedFailure', () {
      when(
        () => dataSource.removeFavorite(5),
      ).thenThrow(const UnexpectedException());

      expect(repository.removeFavorite(5), throwsA(isA<UnexpectedFailure>()));
    });
  });
}
