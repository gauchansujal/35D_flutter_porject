import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/uplodedocument/presentation/widgets/document_image_picker_widget.dart';
import 'package:flutter_test/flutter_test.dart';

// ── Helper ────────────────────────────────────────────────────────
Widget buildCard({
  String label = 'Upload License',
  String? imagePath,
  VoidCallback? onTap,
}) {
  return MaterialApp(
    home: Scaffold(
      body: DocumentImagePickerCard(
        label: label,
        imagePath: imagePath,
        onTap: onTap ?? () {},
      ),
    ),
  );
}

// ── Tests ─────────────────────────────────────────────────────────
void main() {
  // ── No Image State ──────────────────────────────────────────────
  group('when imagePath is null', () {
    testWidgets('shows label text', (tester) async {
      await tester.pumpWidget(buildCard(label: 'Upload License'));

      expect(find.text('Upload License'), findsOneWidget);
    });

    testWidgets('shows Tap to browse text', (tester) async {
      await tester.pumpWidget(buildCard());

      expect(find.text('Tap to browse'), findsOneWidget);
    });

    testWidgets('shows upload icon', (tester) async {
      await tester.pumpWidget(buildCard());

      expect(find.byIcon(Icons.cloud_upload_outlined), findsOneWidget);
    });

    testWidgets('does NOT show Change badge', (tester) async {
      await tester.pumpWidget(buildCard());

      expect(find.text('Change'), findsNothing);
    });
  });

  // ── Has Image State ─────────────────────────────────────────────
  group('when imagePath is provided', () {
    // Note: Image.file won't load in tests (no real file system)
    // so we just check the UI elements around the image

    testWidgets('shows Change badge', (tester) async {
      await tester.pumpWidget(buildCard(imagePath: '/fake/path/image.jpg'));
      await tester.pump();

      expect(find.text('Change'), findsOneWidget);
    });

    testWidgets('shows edit icon in Change badge', (tester) async {
      await tester.pumpWidget(buildCard(imagePath: '/fake/path/image.jpg'));
      await tester.pump();

      expect(find.byIcon(Icons.edit), findsOneWidget);
    });

    testWidgets('does NOT show upload icon', (tester) async {
      await tester.pumpWidget(buildCard(imagePath: '/fake/path/image.jpg'));
      await tester.pump();

      expect(find.byIcon(Icons.cloud_upload_outlined), findsNothing);
    });

    testWidgets('does NOT show Tap to browse', (tester) async {
      await tester.pumpWidget(buildCard(imagePath: '/fake/path/image.jpg'));
      await tester.pump();

      expect(find.text('Tap to browse'), findsNothing);
    });
  });

  // ── Tap Behavior ────────────────────────────────────────────────
  group('tap behavior', () {
    testWidgets('calls onTap when tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(buildCard(onTap: () => tapped = true));

      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      expect(tapped, isTrue); // ← confirms onTap was called
    });

    testWidgets('calls onTap when tapped with image', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        buildCard(
          imagePath: '/fake/path/image.jpg',
          onTap: () => tapped = true,
        ),
      );

      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      expect(tapped, isTrue);
    });
  });
}
