import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/profile_avatar_widget.dart';
import 'package:flutter_test/flutter_test.dart';

// import 'package:your_app/profile_avatar_widget.dart';

void main() {
  Widget buildWidget({
    File? selectedImage,
    String? networkImageUrl,
    VoidCallback? onTap,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: ProfileAvatarWidget(
          selectedImage: selectedImage,
          networkImageUrl: networkImageUrl,
          onTap: onTap ?? () {},
        ),
      ),
    );
  }

  // ─── 1. Rendering ─────────────────────────────────────────────────────────

  group('Rendering', () {
    testWidgets('renders CircleAvatar', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.byType(CircleAvatar), findsOneWidget);
    });

    testWidgets('renders camera icon button', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.byIcon(Icons.camera_alt), findsOneWidget);
    });

    testWidgets('renders Stack with bottomRight alignment', (tester) async {
      await tester.pumpWidget(buildWidget());

      final stacks = tester.widgetList<Stack>(find.byType(Stack));
      final avatarStack = stacks.firstWhere(
        (s) => s.alignment == Alignment.bottomRight,
      );

      expect(avatarStack.alignment, Alignment.bottomRight);
    });
  });

  // ─── 2. Default state (no image) ──────────────────────────────────────────

  group('Default state', () {
    testWidgets('shows person icon when no image provided', (tester) async {
      await tester.pumpWidget(buildWidget());

      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.byType(Image), findsNothing);
    });

    testWidgets('shows person icon when networkImageUrl is empty string', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget(networkImageUrl: ''));

      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.byType(Image), findsNothing);
    });

    testWidgets('shows person icon when networkImageUrl is whitespace', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget(networkImageUrl: '   '));

      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.byType(Image), findsNothing);
    });
  });

  // ─── 3. Network image ─────────────────────────────────────────────────────

  group('Network image', () {
    testWidgets('shows Image widget when networkImageUrl is provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildWidget(networkImageUrl: 'https://example.com/avatar.jpg'),
      );
      await tester.pump();

      expect(find.byType(Image), findsOneWidget);
    });

    // ✅ FIXED: test env always fires errorBuilder for network images
    // so we verify the NetworkImage type instead of absence of person icon
    testWidgets('uses NetworkImage when valid URL provided', (tester) async {
      await tester.pumpWidget(
        buildWidget(networkImageUrl: 'https://example.com/avatar.jpg'),
      );
      await tester.pump();

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.image, isA<NetworkImage>());
    });

    testWidgets('Image.network has loadingBuilder configured', (tester) async {
      await tester.pumpWidget(
        buildWidget(networkImageUrl: 'https://example.com/avatar.jpg'),
      );
      await tester.pump();

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.loadingBuilder, isNotNull);
    });

    testWidgets('Image.network has errorBuilder configured', (tester) async {
      await tester.pumpWidget(
        buildWidget(networkImageUrl: 'https://example.com/avatar.jpg'),
      );
      await tester.pump();

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.errorBuilder, isNotNull);
    });

    testWidgets('wraps network image in ClipOval', (tester) async {
      await tester.pumpWidget(
        buildWidget(networkImageUrl: 'https://example.com/avatar.jpg'),
      );
      await tester.pump();

      expect(find.byType(ClipOval), findsWidgets);
    });
  });

  // ─── 4. Local file image ──────────────────────────────────────────────────

  group('Local file image', () {
    late File tempFile;

    setUp(() async {
      tempFile = File('${Directory.systemTemp.path}/test_avatar.jpg');
      await tempFile.writeAsBytes([0xFF, 0xD8, 0xFF, 0xD9]);
    });

    tearDown(() async {
      if (await tempFile.exists()) await tempFile.delete();
    });

    testWidgets('shows Image.file when selectedImage is provided', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget(selectedImage: tempFile));
      await tester.pump();

      expect(find.byType(Image), findsOneWidget);

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.image, isA<FileImage>());
    });

    testWidgets('selectedImage takes priority over networkImageUrl', (
      tester,
    ) async {
      await tester.pumpWidget(
        buildWidget(
          selectedImage: tempFile,
          networkImageUrl: 'https://example.com/avatar.jpg',
        ),
      );
      await tester.pump();

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.image, isA<FileImage>());
    });

    testWidgets('Image.file has errorBuilder configured', (tester) async {
      await tester.pumpWidget(buildWidget(selectedImage: tempFile));
      await tester.pump();

      final image = tester.widget<Image>(find.byType(Image));
      expect(image.errorBuilder, isNotNull);
    });

    testWidgets('wraps file image in ClipOval', (tester) async {
      await tester.pumpWidget(buildWidget(selectedImage: tempFile));
      await tester.pump();

      expect(find.byType(ClipOval), findsWidgets);
    });
  });

  // ─── 5. onTap callback ────────────────────────────────────────────────────

  group('onTap callback', () {
    testWidgets('calls onTap when camera button is tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(buildWidget(onTap: () => tapped = true));

      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('calls onTap multiple times correctly', (tester) async {
      int tapCount = 0;
      await tester.pumpWidget(buildWidget(onTap: () => tapCount++));

      await tester.tap(find.byType(GestureDetector));
      await tester.tap(find.byType(GestureDetector));
      await tester.tap(find.byType(GestureDetector));
      await tester.pump();

      expect(tapCount, 3);
    });
  });

  // ─── 6. CircleAvatar ──────────────────────────────────────────────────────

  group('CircleAvatar', () {
    testWidgets('has radius of 70', (tester) async {
      await tester.pumpWidget(buildWidget());

      final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
      expect(avatar.radius, 70);
    });

    testWidgets('has correct background color', (tester) async {
      await tester.pumpWidget(buildWidget());

      final avatar = tester.widget<CircleAvatar>(find.byType(CircleAvatar));
      expect(avatar.backgroundColor, Colors.blue.shade700);
    });
  });
}
