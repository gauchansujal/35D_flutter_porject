import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/dashboard/persentation/widgets/icon_box.dart';
import 'package:flutter_test/flutter_test.dart';

// import 'package:your_app/icon_box.dart';

void main() {
  // ─── Helper ────────────────────────────────────────────────────────────────

  Widget buildWidget({IconData icon = Icons.star, Color color = Colors.blue}) {
    return MaterialApp(home: Scaffold(body: IconBox(icon: icon, color: color)));
  }

  // ─── 1. Rendering ─────────────────────────────────────────────────────────

  group('Rendering', () {
    testWidgets('renders the icon', (tester) async {
      await tester.pumpWidget(buildWidget(icon: Icons.star));

      expect(find.byIcon(Icons.star), findsOneWidget);
    });

    testWidgets('renders Container', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('renders Icon widget', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.byType(Icon), findsOneWidget);
    });

    testWidgets('renders different icons correctly', (tester) async {
      await tester.pumpWidget(buildWidget(icon: Icons.home));
      expect(find.byIcon(Icons.home), findsOneWidget);

      await tester.pumpWidget(buildWidget(icon: Icons.settings));
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });
  });

  // ─── 2. Icon properties ───────────────────────────────────────────────────

  group('Icon properties', () {
    testWidgets('icon has white color', (tester) async {
      await tester.pumpWidget(buildWidget(icon: Icons.star));

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.color, Colors.white);
    });

    testWidgets('icon has size 40', (tester) async {
      await tester.pumpWidget(buildWidget(icon: Icons.star));

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.size, 40);
    });

    testWidgets('icon data matches provided icon', (tester) async {
      await tester.pumpWidget(buildWidget(icon: Icons.favorite));

      final icon = tester.widget<Icon>(find.byType(Icon));
      expect(icon.icon, Icons.favorite);
    });
  });

  // ─── 3. Container decoration ──────────────────────────────────────────────

  group('Container decoration', () {
    testWidgets('container has correct background color', (tester) async {
      await tester.pumpWidget(buildWidget(color: Colors.red));

      final container = tester
          .widgetList<Container>(find.byType(Container))
          .firstWhere((c) => c.decoration != null);

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.red);
    });

    testWidgets('container has borderRadius of 20', (tester) async {
      await tester.pumpWidget(buildWidget(color: Colors.green));

      final container = tester
          .widgetList<Container>(find.byType(Container))
          .firstWhere((c) => c.decoration != null);

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(20));
    });

    testWidgets('container color changes with different color prop', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget(color: Colors.purple));

      final container = tester
          .widgetList<Container>(find.byType(Container))
          .firstWhere((c) => c.decoration != null);

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.purple);
    });
  });

  // ─── 4. Different color combinations ──────────────────────────────────────

  group('Color combinations', () {
    testWidgets('renders with blue color', (tester) async {
      await tester.pumpWidget(buildWidget(color: Colors.blue));

      final container = tester
          .widgetList<Container>(find.byType(Container))
          .firstWhere((c) => c.decoration != null);

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.blue);
    });

    testWidgets('renders with pink color', (tester) async {
      await tester.pumpWidget(buildWidget(color: Colors.pink));

      final container = tester
          .widgetList<Container>(find.byType(Container))
          .firstWhere((c) => c.decoration != null);

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.pink);
    });
  });
}
