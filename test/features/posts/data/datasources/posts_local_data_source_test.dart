import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:lumina/core/error/app_exception.dart';
import 'package:lumina/features/posts/data/datasources/posts_local_data_source.dart';
import 'package:lumina/features/posts/domain/entities/post.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MockSharedPreferences extends Mock implements SharedPreferences {}

const _createdKey = 'post_changes_created';
const _updatedKey = 'post_changes_updated';
const _deletedKey = 'post_changes_deleted_ids';
const _nextLocalIdKey = 'post_changes_next_local_id';

Map<String, Object?> _postJson(
  int id, {
  int authorId = 1,
  String title = 'title',
  String body = 'body',
}) => {'id': id, 'authorId': authorId, 'title': title, 'body': body};

Post _post(int id, {int authorId = 1}) =>
    Post(id: id, authorId: authorId, title: 'title', body: 'body');

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  PostsLocalDataSource dataSourceWith(Map<String, Object> initialValues) {
    SharedPreferences.setMockInitialValues(initialValues);
    return SharedPreferencesPostsLocalDataSource(
      SharedPreferences.getInstance(),
    );
  }

  PostsLocalDataSource brokenDataSource() =>
      SharedPreferencesPostsLocalDataSource(
        Future<SharedPreferences>.error(Exception('storage unavailable')),
      );

  Future<SharedPreferences> preferences() => SharedPreferences.getInstance();

  group('getChanges', () {
    test('returns empty defaults when nothing is stored', () async {
      final dataSource = dataSourceWith({});

      final changes = await dataSource.getChanges();

      expect(changes.createdPosts, isEmpty);
      expect(changes.updatedPosts, isEmpty);
      expect(changes.deletedPostIds, isEmpty);
      expect(changes.nextLocalId, -1);
    });

    test('restores created posts in stored order', () async {
      final dataSource = dataSourceWith({
        _createdKey: jsonEncode([_postJson(-1), _postJson(-2)]),
      });

      final changes = await dataSource.getChanges();

      expect(changes.createdPosts, [_post(-1), _post(-2)]);
    });

    test('restores updated posts keyed by post ID', () async {
      final dataSource = dataSourceWith({
        _updatedKey: jsonEncode([_postJson(3), _postJson(7)]),
      });

      final changes = await dataSource.getChanges();

      expect(changes.updatedPosts, {3: _post(3), 7: _post(7)});
    });

    test('restores deleted post IDs', () async {
      final dataSource = dataSourceWith({
        _deletedKey: ['4', '9'],
      });

      final changes = await dataSource.getChanges();

      expect(changes.deletedPostIds, {4, 9});
    });

    test('restores the next local ID', () async {
      final dataSource = dataSourceWith({_nextLocalIdKey: -5});

      final changes = await dataSource.getChanges();

      expect(changes.nextLocalId, -5);
    });

    test('skips malformed created entries but keeps valid ones', () async {
      final dataSource = dataSourceWith({
        _createdKey: jsonEncode([
          _postJson(-1),
          'not-an-object',
          {'id': 'nan', 'authorId': 1, 'title': 't', 'body': 'b'},
          _postJson(5), // created posts must have negative IDs
          _postJson(-1), // duplicate ID
          _postJson(-2),
        ]),
      });

      final changes = await dataSource.getChanges();

      expect(changes.createdPosts, [_post(-1), _post(-2)]);
    });

    test('re-derives a corrupted next local ID below created IDs', () async {
      final dataSource = dataSourceWith({
        _createdKey: jsonEncode([_postJson(-1), _postJson(-3)]),
        _nextLocalIdKey: 12,
      });

      final changes = await dataSource.getChanges();

      expect(changes.nextLocalId, -4);
    });

    test('maps top-level corruption to ParsingException', () async {
      final dataSource = dataSourceWith({_createdKey: 'not json {'});

      await expectLater(
        dataSource.getChanges(),
        throwsA(isA<ParsingException>()),
      );
    });

    test('maps a storage read error to UnexpectedException', () async {
      await expectLater(
        brokenDataSource().getChanges(),
        throwsA(isA<UnexpectedException>()),
      );
    });
  });

  group('createLocalPost', () {
    test('allocates -1 first, then -2', () async {
      final dataSource = dataSourceWith({});

      final first = await dataSource.createLocalPost(
        authorId: 1,
        title: 'first',
        body: 'body one',
      );
      final second = await dataSource.createLocalPost(
        authorId: 2,
        title: 'second',
        body: 'body two',
      );

      expect(first.id, -1);
      expect(second.id, -2);
      expect(
        first,
        const Post(id: -1, authorId: 1, title: 'first', body: 'body one'),
      );
    });

    test('persists created posts and the counter deterministically', () async {
      final dataSource = dataSourceWith({});

      await dataSource.createLocalPost(authorId: 1, title: 't1', body: 'b1');
      await dataSource.createLocalPost(authorId: 2, title: 't2', body: 'b2');

      final stored = (await preferences()).getString(_createdKey);
      expect(
        stored,
        jsonEncode([
          _postJson(-1, authorId: 1, title: 't1', body: 'b1'),
          _postJson(-2, authorId: 2, title: 't2', body: 'b2'),
        ]),
      );
      expect((await preferences()).getInt(_nextLocalIdKey), -3);

      final restored = await dataSource.getChanges();
      expect(restored.createdPosts.map((post) => post.id), [-1, -2]);
      expect(restored.nextLocalId, -3);
    });

    test('rejects non-positive author IDs without writing', () async {
      final dataSource = dataSourceWith({});

      await expectLater(
        dataSource.createLocalPost(authorId: 0, title: 't', body: 'b'),
        throwsA(isA<NotFoundException>()),
      );
      expect((await preferences()).getString(_createdKey), isNull);
    });

    test('maps a storage write error to UnexpectedException', () async {
      await expectLater(
        brokenDataSource().createLocalPost(authorId: 1, title: 't', body: 'b'),
        throwsA(isA<UnexpectedException>()),
      );
    });

    test('maps a false write result to UnexpectedException', () async {
      final mockPreferences = _MockSharedPreferences();
      when(() => mockPreferences.getString(any())).thenReturn(null);
      when(() => mockPreferences.getStringList(any())).thenReturn(null);
      when(() => mockPreferences.getInt(any())).thenReturn(null);
      when(
        () => mockPreferences.setString(any(), any()),
      ).thenAnswer((_) async => false);
      final dataSource = SharedPreferencesPostsLocalDataSource(
        Future.value(mockPreferences),
      );

      await expectLater(
        dataSource.createLocalPost(authorId: 1, title: 't', body: 'b'),
        throwsA(isA<UnexpectedException>()),
      );
    });
  });

  group('saveUpdatedPost', () {
    test('replaces a locally created post inside createdPosts', () async {
      final dataSource = dataSourceWith({
        _createdKey: jsonEncode([_postJson(-1), _postJson(-2)]),
      });

      await dataSource.saveUpdatedPost(
        const Post(id: -1, authorId: 1, title: 'new', body: 'new body'),
      );

      final changes = await dataSource.getChanges();
      expect(changes.createdPosts, [
        const Post(id: -1, authorId: 1, title: 'new', body: 'new body'),
        _post(-2),
      ]);
      expect(changes.updatedPosts, isEmpty);
    });

    test('stores a remote post edit in updatedPosts', () async {
      final dataSource = dataSourceWith({});

      await dataSource.saveUpdatedPost(_post(7));

      final changes = await dataSource.getChanges();
      expect(changes.updatedPosts, {7: _post(7)});
      expect(changes.createdPosts, isEmpty);
    });

    test('rejects updates to deleted posts', () async {
      final dataSource = dataSourceWith({
        _deletedKey: ['7'],
      });

      await expectLater(
        dataSource.saveUpdatedPost(_post(7)),
        throwsA(isA<NotFoundException>()),
      );
    });

    test('rejects unknown locally created post IDs', () async {
      final dataSource = dataSourceWith({});

      await expectLater(
        dataSource.saveUpdatedPost(_post(-9)),
        throwsA(isA<NotFoundException>()),
      );
    });

    test('rejects invalid IDs', () async {
      final dataSource = dataSourceWith({});

      await expectLater(
        dataSource.saveUpdatedPost(_post(0)),
        throwsA(isA<NotFoundException>()),
      );
      await expectLater(
        dataSource.saveUpdatedPost(_post(3, authorId: 0)),
        throwsA(isA<NotFoundException>()),
      );
    });
  });

  group('saveDeletedPost', () {
    test('removes a locally created post from createdPosts', () async {
      final dataSource = dataSourceWith({
        _createdKey: jsonEncode([_postJson(-1), _postJson(-2)]),
      });

      await dataSource.saveDeletedPost(-1);

      final changes = await dataSource.getChanges();
      expect(changes.createdPosts, [_post(-2)]);
      expect(changes.deletedPostIds, isEmpty);
    });

    test('records a remote post ID and drops its stored update', () async {
      final dataSource = dataSourceWith({
        _updatedKey: jsonEncode([_postJson(7), _postJson(8)]),
      });

      await dataSource.saveDeletedPost(7);

      final changes = await dataSource.getChanges();
      expect(changes.deletedPostIds, {7});
      expect(changes.updatedPosts.keys, [8]);
    });

    test('persists deleted IDs in ascending order', () async {
      final dataSource = dataSourceWith({
        _deletedKey: ['9'],
      });

      await dataSource.saveDeletedPost(4);

      expect((await preferences()).getStringList(_deletedKey), ['4', '9']);
    });

    test('rejects an invalid ID', () async {
      final dataSource = dataSourceWith({});

      await expectLater(
        dataSource.saveDeletedPost(0),
        throwsA(isA<NotFoundException>()),
      );
    });

    test('maps a storage write error to UnexpectedException', () async {
      await expectLater(
        brokenDataSource().saveDeletedPost(3),
        throwsA(isA<UnexpectedException>()),
      );
    });
  });
}
