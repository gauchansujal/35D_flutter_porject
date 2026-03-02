import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/uplodedocument/presentation/widgets/document_section_header_widget.dart';
import 'package:flutter_test/flutter_test.dart';

// ── Helper ────────────────────────────────────────────────────────
Widget buildHeader({
  String title = 'Personal Info',
  IconData icon = Icons.person,
}) {
  return MaterialApp(
    home: Scaffold(body: DocumentSectionHeader(title: title, icon: icon)),
  );
}

// ── Tests ─────────────────────────────────────────────────────────
void main() {
  testWidgets('shows title text', (tester) async {
    await tester.pumpWidget(buildHeader(title: 'Personal Info'));

    expect(find.text('Personal Info'), findsOneWidget);
  });

  testWidgets('shows correct icon', (tester) async {
    await tester.pumpWidget(buildHeader(icon: Icons.person));

    expect(find.byIcon(Icons.person), findsOneWidget);
  });

  testWidgets('shows divider', (tester) async {
    await tester.pumpWidget(buildHeader());

    expect(find.byType(Divider), findsOneWidget);
  });

  testWidgets('shows row layout', (tester) async {
    await tester.pumpWidget(buildHeader());

    expect(find.byType(Row), findsOneWidget);
  });

  testWidgets('renders with different title and icon', (tester) async {
    await tester.pumpWidget(
      buildHeader(title: 'Documents', icon: Icons.file_copy),
    );

    expect(find.text('Documents'), findsOneWidget);
    expect(find.byIcon(Icons.file_copy), findsOneWidget);
  });
}
