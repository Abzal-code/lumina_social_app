import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:lumina/features/comments/presentation/widgets/comment_card.dart';
import 'package:lumina/features/posts/presentation/widgets/post_card.dart';
import 'package:lumina/features/users/presentation/widgets/user_card.dart';
import 'package:lumina/main.dart' as app;

/// Walks the main screens against the live API and hands one screenshot per
/// screen to the driver, which stores them under docs/screenshots/.
///
/// Run with:
///
///     flutter drive --driver=test_driver/integration_test.dart \
///       --target=integration_test/screenshots.dart -d <device>
///
void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('captures README screenshots', (tester) async {
    app.main();

    await _pumpUntilFound(tester, find.text('Welcome to Lumina'));
    await binding.takeScreenshot('home');

    await tester.tap(find.text('Posts'));
    await _pumpUntilFound(tester, find.byType(PostCard));
    await binding.takeScreenshot('posts');

    // Bookmark the first two posts so the Favorites tab has content.
    await tester.tap(find.byIcon(Icons.bookmark_outline).first);
    await _pumpUntilFound(tester, find.byIcon(Icons.bookmark));
    await tester.tap(find.byIcon(Icons.bookmark_outline).first);
    await _pumpUntilFound(tester, find.byIcon(Icons.bookmark), count: 2);

    await tester.tap(find.byType(PostCard).first);
    await _pumpUntilFound(tester, find.byType(CommentCard));
    await binding.takeScreenshot('post_details');
    await tester.pageBack();
    await _pumpUntilFound(tester, find.byType(PostCard));

    await tester.tap(find.text('Users'));
    await _pumpUntilFound(tester, find.byType(UserCard));
    await binding.takeScreenshot('users');

    await tester.tap(find.byType(UserCard).first);
    await _pumpUntilFound(tester, find.byType(PostCard));
    await binding.takeScreenshot('user_profile');
    await tester.pageBack();
    await _pumpUntilFound(tester, find.byType(UserCard));

    await tester.tap(find.text('Favorites'));
    await _pumpUntilFound(tester, find.byType(PostCard));
    await binding.takeScreenshot('favorites');
  });
}

/// [WidgetTester.pumpAndSettle] never settles while loading skeletons
/// animate, so poll for [count] matches of a marker widget instead.
Future<void> _pumpUntilFound(
  WidgetTester tester,
  Finder finder, {
  int count = 1,
  Duration timeout = const Duration(seconds: 30),
}) async {
  final deadline = DateTime.now().add(timeout);
  while (finder.evaluate().length < count) {
    if (DateTime.now().isAfter(deadline)) {
      throw TimeoutException('Timed out waiting for $finder');
    }
    await tester.pump(const Duration(milliseconds: 250));
  }
  await tester.pump(const Duration(milliseconds: 400));
}
