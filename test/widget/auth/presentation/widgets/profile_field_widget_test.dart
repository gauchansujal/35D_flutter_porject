import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/profile_field_widget.dart';
import 'package:flutter_test/flutter_test.dart';

// ── Helper ────────────────────────────────────────────────────────
Widget buildField({
  String label = 'Full Name',
  TextEditingController? controller,
  IconData icon = Icons.person,
  bool enabled = true,
  bool obscureText = false,
  TextInputType? keyboardType,
  Widget? suffixIcon,
}) {
  return MaterialApp(
    home: Scaffold(
      body: ProfileFieldWidget(
        label: label,
        controller: controller ?? TextEditingController(),
        icon: icon,
        enabled: enabled,
        obscureText: obscureText,
        keyboardType: keyboardType,
        suffixIcon: suffixIcon,
      ),
    ),
  );
}

// ── Tests ─────────────────────────────────────────────────────────
void main() {
  // ── Basic Rendering ─────────────────────────────────────────────
  group('basic rendering', () {
    testWidgets('shows label text', (tester) async {
      await tester.pumpWidget(buildField(label: 'Full Name'));

      expect(find.text('Full Name'), findsOneWidget);
    });

    testWidgets('shows prefix icon', (tester) async {
      await tester.pumpWidget(buildField(icon: Icons.person));

      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('renders TextField', (tester) async {
      await tester.pumpWidget(buildField());

      expect(find.byType(TextField), findsOneWidget);
    });
  });

  // ── Text Input ──────────────────────────────────────────────────
  group('text input', () {
    testWidgets('shows typed text', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(buildField(controller: controller));

      await tester.enterText(find.byType(TextField), 'John Doe');
      await tester.pump();

      expect(find.text('John Doe'), findsOneWidget);
    });

    testWidgets('controller reflects typed text', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(buildField(controller: controller));

      await tester.enterText(find.byType(TextField), 'Hello');
      await tester.pump();

      expect(controller.text, 'Hello'); // ← checks controller value
    });
  });

  // ── Enabled / Disabled ──────────────────────────────────────────
  group('enabled and disabled state', () {
    testWidgets('field is enabled by default', (tester) async {
      await tester.pumpWidget(buildField(enabled: true));

      final tf = tester.widget<TextField>(find.byType(TextField));
      expect(tf.enabled, isTrue);
    });

    testWidgets('field is disabled when enabled is false', (tester) async {
      await tester.pumpWidget(buildField(enabled: false));

      final tf = tester.widget<TextField>(find.byType(TextField));
      expect(tf.enabled, isFalse);
    });

    testWidgets('cannot type when disabled', (tester) async {
      final controller = TextEditingController();
      await tester.pumpWidget(
        buildField(controller: controller, enabled: false),
      );

      await tester.enterText(find.byType(TextField), 'Hello');
      await tester.pump();

      expect(controller.text, ''); // ← nothing typed
    });
  });

  // ── Obscure Text ────────────────────────────────────────────────
  group('obscure text', () {
    testWidgets('obscureText is false by default', (tester) async {
      await tester.pumpWidget(buildField());

      final tf = tester.widget<TextField>(find.byType(TextField));
      expect(tf.obscureText, isFalse);
    });

    testWidgets('obscureText is true when set', (tester) async {
      await tester.pumpWidget(buildField(obscureText: true));

      final tf = tester.widget<TextField>(find.byType(TextField));
      expect(tf.obscureText, isTrue);
    });
  });

  // ── Suffix Icon ─────────────────────────────────────────────────
  group('suffix icon', () {
    testWidgets('shows suffix icon when provided', (tester) async {
      await tester.pumpWidget(
        buildField(suffixIcon: const Icon(Icons.visibility)),
      );

      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('no suffix icon by default', (tester) async {
      await tester.pumpWidget(buildField());

      expect(find.byIcon(Icons.visibility), findsNothing);
    });
  });
}
