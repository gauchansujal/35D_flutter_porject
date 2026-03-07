import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/profile_field_widget.dart';
import 'package:flutter_test/flutter_test.dart';

// ─── Copy your widget here or import it ───────────────────────────────────────
// import 'package:your_app/profile_field_widget.dart';

void main() {
  late TextEditingController controller;

  setUp(() {
    controller = TextEditingController();
  });

  tearDown(() {
    controller.dispose();
  });

  Widget buildWidget({
    String label = 'Email',
    IconData icon = Icons.email,
    bool enabled = true,
    bool obscureText = false,
    TextInputType? keyboardType,
    Widget? suffixIcon,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: ProfileFieldWidget(
          label: label,
          controller: controller,
          icon: icon,
          enabled: enabled,
          obscureText: obscureText,
          keyboardType: keyboardType,
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }

  // ─── 1. Rendering ─────────────────────────────────────────────────────────

  group('Rendering', () {
    testWidgets('renders label correctly', (tester) async {
      await tester.pumpWidget(buildWidget(label: 'Username'));

      expect(find.text('Username'), findsOneWidget);
    });

    testWidgets('renders prefix icon', (tester) async {
      await tester.pumpWidget(buildWidget(icon: Icons.person));

      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('renders suffix icon when provided', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          suffixIcon: const Icon(Icons.visibility, key: Key('suffix_icon')),
        ),
      );

      expect(find.byKey(const Key('suffix_icon')), findsOneWidget);
    });

    testWidgets('does not render suffix icon when not provided', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget(icon: Icons.email));

      // only prefix icon — no extra icon
      expect(find.byIcon(Icons.visibility), findsNothing);
    });

    testWidgets('TextField is present', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.byType(TextField), findsOneWidget);
    });
  });

  // ─── 2. Text Input ────────────────────────────────────────────────────────

  group('Text input', () {
    testWidgets('accepts typed text and updates controller', (tester) async {
      await tester.pumpWidget(buildWidget());

      await tester.enterText(find.byType(TextField), 'hello@test.com');

      expect(controller.text, 'hello@test.com');
    });

    testWidgets('displays pre-filled controller text', (tester) async {
      controller.text = 'prefilled value';
      await tester.pumpWidget(buildWidget());

      expect(find.text('prefilled value'), findsOneWidget);
    });

    testWidgets('updates UI when controller text changes', (tester) async {
      await tester.pumpWidget(buildWidget());

      controller.text = 'new value';
      await tester.pump();

      expect(find.text('new value'), findsOneWidget);
    });

    testWidgets('clears text when controller is cleared', (tester) async {
      controller.text = 'some text';
      await tester.pumpWidget(buildWidget());

      controller.clear();
      await tester.pump();

      expect(find.text('some text'), findsNothing);
    });
  });

  // ─── 3. Enabled / Disabled ────────────────────────────────────────────────

  group('Enabled state', () {
    testWidgets('is enabled by default', (tester) async {
      await tester.pumpWidget(buildWidget());

      final tf = tester.widget<TextField>(find.byType(TextField));
      expect(tf.enabled, isTrue);
    });

    testWidgets('is disabled when enabled=false', (tester) async {
      await tester.pumpWidget(buildWidget(enabled: false));

      final tf = tester.widget<TextField>(find.byType(TextField));
      expect(tf.enabled, isFalse);
    });

    testWidgets('disabled field does not accept input', (tester) async {
      await tester.pumpWidget(buildWidget(enabled: false));

      await tester.enterText(find.byType(TextField), 'should not appear');

      expect(controller.text, isEmpty);
    });
  });

  // ─── 4. obscureText ───────────────────────────────────────────────────────

  group('obscureText', () {
    testWidgets('obscureText is false by default', (tester) async {
      await tester.pumpWidget(buildWidget());

      final tf = tester.widget<TextField>(find.byType(TextField));
      expect(tf.obscureText, isFalse);
    });

    testWidgets('obscureText=true hides the text', (tester) async {
      await tester.pumpWidget(buildWidget(obscureText: true));

      final tf = tester.widget<TextField>(find.byType(TextField));
      expect(tf.obscureText, isTrue);
    });
  });

  // ─── 5. Keyboard Type ─────────────────────────────────────────────────────

  group('Keyboard type', () {
    testWidgets('keyboardType is null by default', (tester) async {
      await tester.pumpWidget(buildWidget());

      final tf = tester.widget<TextField>(find.byType(TextField));
      expect(tf.keyboardType, isNull);
    });

    testWidgets('sets email keyboard type', (tester) async {
      await tester.pumpWidget(
        buildWidget(keyboardType: TextInputType.emailAddress),
      );

      final tf = tester.widget<TextField>(find.byType(TextField));
      expect(tf.keyboardType, TextInputType.emailAddress);
    });

    testWidgets('sets number keyboard type', (tester) async {
      await tester.pumpWidget(buildWidget(keyboardType: TextInputType.number));

      final tf = tester.widget<TextField>(find.byType(TextField));
      expect(tf.keyboardType, TextInputType.number);
    });
  });

  // ─── 6. Decoration ────────────────────────────────────────────────────────

  group('Decoration', () {
    testWidgets('fillColor is white12 when enabled', (tester) async {
      await tester.pumpWidget(buildWidget(enabled: true));

      final tf = tester.widget<TextField>(find.byType(TextField));
      expect(tf.decoration!.fillColor, Colors.white12);
    });

    testWidgets('fillColor is white10 when disabled', (tester) async {
      await tester.pumpWidget(buildWidget(enabled: false));

      final tf = tester.widget<TextField>(find.byType(TextField));
      expect(tf.decoration!.fillColor, Colors.white10);
    });

    testWidgets('filled is true', (tester) async {
      await tester.pumpWidget(buildWidget());

      final tf = tester.widget<TextField>(find.byType(TextField));
      expect(tf.decoration!.filled, isTrue);
    });
  });
}
