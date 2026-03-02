import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/features/auth/presentation/widgets/profile_avatar_widget.dart';

Widget buildAvatar({
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

void main() {
  testWidgets('shows person icon by default', (tester) async {
    await tester.pumpWidget(buildAvatar());

    expect(find.byIcon(Icons.person), findsOneWidget);
  });

  testWidgets('shows camera_alt icon always', (tester) async {
    await tester.pumpWidget(buildAvatar());

    expect(find.byIcon(Icons.camera_alt), findsOneWidget);
  });

  testWidgets('shows CircleAvatar', (tester) async {
    await tester.pumpWidget(buildAvatar());

    expect(find.byType(CircleAvatar), findsOneWidget);
  });

  testWidgets('shows Image widget when network url given', (tester) async {
    await tester.pumpWidget(
      buildAvatar(networkImageUrl: 'https://example.com/photo.jpg'),
    );
    await tester.pump();

    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('shows Image widget when file given', (tester) async {
    await tester.pumpWidget(
      buildAvatar(selectedImage: File('/fake/image.jpg')),
    );
    await tester.pump();

    expect(find.byType(Image), findsOneWidget);
  });

  testWidgets('calls onTap when camera tapped', (tester) async {
    bool tapped = false;
    await tester.pumpWidget(buildAvatar(onTap: () => tapped = true));

    await tester.tap(find.byIcon(Icons.camera_alt));
    await tester.pump();

    expect(tapped, isTrue);
  });
}
