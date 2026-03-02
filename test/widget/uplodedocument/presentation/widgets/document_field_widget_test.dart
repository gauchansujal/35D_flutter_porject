import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/uplodedocument/presentation/widgets/document_field_widget.dart';
import 'package:flutter_test/flutter_test.dart';

// ── Helper ────────────────────────────────────────────────────────
Widget buildField({
  TextEditingController? controller,
  String label = 'Full Name',
  String hint = 'Enter your name',
  String? Function(String?)? validator,
  IconData prefixIcon = Icons.person,
  TextInputType keyboardType = TextInputType.text,
}) {
  return MaterialApp(
    home: Scaffold(
      body: Form(
        // ← needed for validator to work
        child: DocumentFormField(
          controller: controller ?? TextEditingController(),
          label: label,
          hint: hint,
          validator: validator ?? (value) => null,
          prefixIcon: prefixIcon,
          keyboardType: keyboardType,
        ),
      ),
    ),
  );
}

// ── Tests ─────────────────────────────────────────────────────────
void main() {
  testWidgets('shows label text', (tester) async {
    await tester.pumpWidget(buildField(label: 'Full Name'));

    expect(find.text('Full Name'), findsOneWidget);
  });

  testWidgets('shows hint text', (tester) async {
    await tester.pumpWidget(buildField(hint: 'Enter your name'));

    expect(find.text('Enter your name'), findsOneWidget);
  });

  testWidgets('shows prefix icon', (tester) async {
    await tester.pumpWidget(buildField(prefixIcon: Icons.person));

    expect(find.byIcon(Icons.person), findsOneWidget);
  });

  testWidgets('shows typed text in field', (tester) async {
    final controller = TextEditingController();
    await tester.pumpWidget(buildField(controller: controller));

    await tester.enterText(find.byType(TextFormField), 'John Doe');
    await tester.pump();

    expect(find.text('John Doe'), findsOneWidget);
  });

  testWidgets('shows error message when validator fails', (tester) async {
    await tester.pumpWidget(
      buildField(validator: (value) => 'This field is required'),
    );

    // trigger validation
    final formState = tester.state<FormState>(find.byType(Form));
    formState.validate();
    await tester.pump();

    expect(find.text('This field is required'), findsOneWidget);
  });

  testWidgets('shows no error when validator passes', (tester) async {
    await tester.pumpWidget(
      buildField(validator: (value) => null), // null = no error
    );

    final formState = tester.state<FormState>(find.byType(Form));
    formState.validate();
    await tester.pump();

    expect(find.text('This field is required'), findsNothing);
  });

  testWidgets('renders TextFormField', (tester) async {
    await tester.pumpWidget(buildField());

    expect(find.byType(TextFormField), findsOneWidget);
  });
}
