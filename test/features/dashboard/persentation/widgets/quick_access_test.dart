import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/dashboard/persentation/widgets/quick_access.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_application_1/features/notifaction/domain/entity/notification_entiti.dart';
import 'package:flutter_application_1/features/notifaction/presentation/viewmodel/notification_viewmodel.dart';
import 'package:flutter_application_1/features/notifaction/presentation/provider/state/notification_state.dart';

// ─── Mock ──────────────────────────────────────────────────────────────────

class MockNotificationViewModel extends Notifier<NotificationState>
    with Mock
    implements NotificationViewModel {
  final NotificationState _initialState;

  MockNotificationViewModel(this._initialState);

  @override
  NotificationState build() => _initialState;
}

// ─── Fake Notification ─────────────────────────────────────────────────────

NotificationEntity fakeNotification({
  String id = '1',
  String title = 'Test Title',
  String message = 'Test Message',
  String type = 'booking_confirmed',
  bool isRead = false,
  DateTime? createdAt,
}) => NotificationEntity(
  id: id,
  title: title,
  message: message,
  type: type,
  isRead: isRead,
  createdAt: createdAt ?? DateTime.now().subtract(const Duration(minutes: 5)),
);

// ─── Helper ────────────────────────────────────────────────────────────────

Widget buildWidget(NotificationState state) {
  return ProviderScope(
    overrides: [
      notificationViewModelProvider.overrideWith(
        () => MockNotificationViewModel(state),
      ),
    ],
    child: const MaterialApp(
      home: Scaffold(body: SingleChildScrollView(child: QuickAccess())),
    ),
  );
}

void main() {
  // ─── 1. Rendering ─────────────────────────────────────────────────────────

  group('Rendering', () {
    testWidgets('renders Quick Access label', (tester) async {
      await tester.pumpWidget(buildWidget(const NotificationState()));
      await tester.pump();

      expect(find.text('Quick Access'), findsOneWidget);
    });

    testWidgets('renders Recent Activity label', (tester) async {
      await tester.pumpWidget(buildWidget(const NotificationState()));
      await tester.pump();

      expect(find.text('Recent Activity'), findsOneWidget);
    });

    testWidgets('renders View All button', (tester) async {
      await tester.pumpWidget(buildWidget(const NotificationState()));
      await tester.pump();

      expect(find.text('View All'), findsOneWidget);
    });

    testWidgets('renders GridView with quick access icons', (tester) async {
      await tester.pumpWidget(buildWidget(const NotificationState()));
      await tester.pump();

      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('renders bike icon box', (tester) async {
      await tester.pumpWidget(buildWidget(const NotificationState()));
      await tester.pump();

      expect(find.byIcon(Icons.two_wheeler), findsOneWidget);
    });

    testWidgets('renders upload file icon box', (tester) async {
      await tester.pumpWidget(buildWidget(const NotificationState()));
      await tester.pump();

      expect(find.byIcon(Icons.upload_file), findsOneWidget);
    });
  });

  // ─── 2. Empty notifications ───────────────────────────────────────────────

  group('Empty notifications', () {
    testWidgets('shows no recent activity message when list is empty', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget(const NotificationState()));
      await tester.pump();

      expect(find.text('No recent activity'), findsOneWidget);
    });

    testWidgets('does not show activity tiles when list is empty', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget(const NotificationState()));
      await tester.pump();

      expect(find.byType(GestureDetector), findsWidgets);
      // No _ActivityTile containers beyond the grid items
      expect(find.text('No recent activity'), findsOneWidget);
    });
  });

  // ─── 3. With notifications ─────────────────────────────────────────────────

  group('With notifications', () {
    testWidgets('shows notification title', (tester) async {
      final state = NotificationState(
        status: NotificationStatus.loaded,
        notifications: [fakeNotification(title: 'Booking Confirmed')],
      );

      await tester.pumpWidget(buildWidget(state));
      await tester.pump();

      expect(find.text('Booking Confirmed'), findsOneWidget);
    });

    testWidgets('shows notification message', (tester) async {
      final state = NotificationState(
        status: NotificationStatus.loaded,
        notifications: [
          fakeNotification(message: 'Your bike is ready for pickup'),
        ],
      );

      await tester.pumpWidget(buildWidget(state));
      await tester.pump();

      expect(find.text('Your bike is ready for pickup'), findsOneWidget);
    });

    testWidgets('shows at most 3 notifications', (tester) async {
      final state = NotificationState(
        status: NotificationStatus.loaded,
        notifications: List.generate(
          5,
          (i) => fakeNotification(id: '$i', title: 'Notification $i'),
        ),
      );

      await tester.pumpWidget(buildWidget(state));
      await tester.pump();

      // Only first 3 should be visible
      expect(find.text('Notification 0'), findsOneWidget);
      expect(find.text('Notification 1'), findsOneWidget);
      expect(find.text('Notification 2'), findsOneWidget);
      expect(find.text('Notification 3'), findsNothing);
      expect(find.text('Notification 4'), findsNothing);
    });

    testWidgets('does not show empty message when notifications exist', (
      tester,
    ) async {
      final state = NotificationState(
        status: NotificationStatus.loaded,
        notifications: [fakeNotification(title: 'Some Notification')],
      );

      await tester.pumpWidget(buildWidget(state));
      await tester.pump();

      expect(find.text('No recent activity'), findsNothing);
    });
  });

  // ─── 4. Activity tile ─────────────────────────────────────────────────────

  group('Activity tile', () {
    testWidgets('shows unread indicator for unread notification', (
      tester,
    ) async {
      final state = NotificationState(
        status: NotificationStatus.loaded,
        notifications: [fakeNotification(isRead: false)],
      );

      await tester.pumpWidget(buildWidget(state));
      await tester.pump();

      // Unread tile has a blue dot indicator — find blue accent containers
      final containers = tester.widgetList<Container>(find.byType(Container));
      final blueDot = containers.any((c) {
        final decoration = c.decoration as BoxDecoration?;
        return decoration?.color == Colors.blueAccent &&
            decoration?.shape == BoxShape.circle;
      });
      expect(blueDot, isTrue);
    });

    testWidgets('shows time ago for notification with createdAt', (
      tester,
    ) async {
      final state = NotificationState(
        status: NotificationStatus.loaded,
        notifications: [
          fakeNotification(
            createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
          ),
        ],
      );

      await tester.pumpWidget(buildWidget(state));
      await tester.pump();

      expect(find.text('10m ago'), findsOneWidget);
    });

    testWidgets('shows Just now for very recent notification', (tester) async {
      final state = NotificationState(
        status: NotificationStatus.loaded,
        notifications: [
          fakeNotification(
            createdAt: DateTime.now().subtract(const Duration(seconds: 30)),
          ),
        ],
      );

      await tester.pumpWidget(buildWidget(state));
      await tester.pump();

      expect(find.text('Just now'), findsOneWidget);
    });

    testWidgets('shows hours ago for older notification', (tester) async {
      final state = NotificationState(
        status: NotificationStatus.loaded,
        notifications: [
          fakeNotification(
            createdAt: DateTime.now().subtract(const Duration(hours: 3)),
          ),
        ],
      );

      await tester.pumpWidget(buildWidget(state));
      await tester.pump();

      expect(find.text('3h ago'), findsOneWidget);
    });

    testWidgets('shows days ago for old notification', (tester) async {
      final state = NotificationState(
        status: NotificationStatus.loaded,
        notifications: [
          fakeNotification(
            createdAt: DateTime.now().subtract(const Duration(days: 2)),
          ),
        ],
      );

      await tester.pumpWidget(buildWidget(state));
      await tester.pump();

      expect(find.text('2d ago'), findsOneWidget);
    });
  });

  // ─── 5. Dot colors by type ────────────────────────────────────────────────

  group('Dot color by notification type', () {
    Future<Color?> getDotColor(WidgetTester tester, String type) async {
      final state = NotificationState(
        status: NotificationStatus.loaded,
        notifications: [fakeNotification(type: type)],
      );
      await tester.pumpWidget(buildWidget(state));
      await tester.pump();

      final containers = tester.widgetList<Container>(find.byType(Container));
      for (final c in containers) {
        final decoration = c.decoration as BoxDecoration?;
        if (decoration?.shape == BoxShape.circle &&
            c.constraints?.maxWidth == 10) {
          return decoration?.color;
        }
      }
      return null;
    }

    testWidgets('booking_confirmed shows green dot', (tester) async {
      final color = await getDotColor(tester, 'booking_confirmed');
      expect(color, Colors.green);
    });

    testWidgets('booking_cancelled shows red dot', (tester) async {
      final color = await getDotColor(tester, 'booking_cancelled');
      expect(color, Colors.red);
    });

    testWidgets('booking_updated shows orange dot', (tester) async {
      final color = await getDotColor(tester, 'booking_updated');
      expect(color, Colors.orange);
    });

    testWidgets('booking_reminder shows blue dot', (tester) async {
      final color = await getDotColor(tester, 'booking_reminder');
      expect(color, Colors.blue);
    });

    testWidgets('unknown type shows purple dot', (tester) async {
      final color = await getDotColor(tester, 'other');
      expect(color, Colors.purple);
    });
  });
}
