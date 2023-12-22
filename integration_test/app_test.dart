import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pokedex/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end to end testing', () {
    testWidgets('load more pokemon after scrolling', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));

      final listFinder = find.byType(Scrollable);
      final itemFinder = find.byKey(const ValueKey('pokemon_16'));
      final itemLoadedFinder = find.byKey(const ValueKey('pokemon_21'));

      expect(itemLoadedFinder, findsNothing);

      await tester.scrollUntilVisible(itemFinder, 500.0, scrollable: listFinder);
      await tester.pumpAndSettle();

      await Future.delayed(const Duration(seconds: 3));
      await tester.scrollUntilVisible(find.byKey(const ValueKey('pokemon_20')), 500.0, scrollable: listFinder);
      await tester.pumpAndSettle();

      expect(itemLoadedFinder, findsOneWidget);
      await Future.delayed(const Duration(seconds: 2));
    });

    testWidgets('see pokemon details and cycle through pokemon', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));

      final itemFinder = find.byKey(const ValueKey('pokemon_3'));

      await tester.tap(itemFinder);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 3));

      final backArrow = find.byIcon(Icons.arrow_back_ios);
      final nextArrow = find.byIcon(Icons.arrow_forward_ios);

      await tester.tap(nextArrow);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 3));

      await tester.tap(nextArrow);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 3));

      await tester.tap(nextArrow);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 3));

      await tester.tap(backArrow);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await Future.delayed(const Duration(seconds: 5));

      expect(find.text('Charizard'), findsAny);
      await Future.delayed(const Duration(seconds: 3));
    });

    testWidgets('search for a pokemon', (tester) async {
      app.main();
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 2));

      final itemFinder = find.byIcon(Icons.search);

      await tester.tap(itemFinder);
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 3));

      await tester.enterText(find.byType(TextField), "94");
      await Future.delayed(const Duration(seconds: 3));

      await tester.tap(find.text("SEARCH"));
      await tester.pumpAndSettle(const Duration(seconds: 2));
      await Future.delayed(const Duration(seconds: 3));

      expect(find.text('Gengar'), findsAny);
      await Future.delayed(const Duration(seconds: 3));
    });
  });
}
