import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lumina/app/app.dart';
import 'package:lumina/features/home/presentation/home_page.dart';

void main() {
  testWidgets('LuminaApp shows the HomePage', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: LuminaApp()));
    await tester.pumpAndSettle();

    expect(find.byType(HomePage), findsOneWidget);
    expect(find.text('Lumina'), findsOneWidget);
    expect(find.text('Welcome to Lumina'), findsOneWidget);
  });
}
