import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocktail/mocktail.dart';

import 'package:flutter_application_1/features/bike_card/domain/entites/bike_entity.dart';
import 'package:flutter_application_1/features/Booking/domain/entites/booking_enitities.dart';
import 'package:flutter_application_1/features/Booking/presentation/view_models/booking_viewmodel.dart';
import 'package:flutter_application_1/features/Booking/presentation/providers/state/booking_state.dart';
import 'package:flutter_application_1/features/bike_card/presentation/widget/bike_widget.dart';

// ─── Fake ──────────────────────────────────────────────────────────────────

class FakeBookingEnitities extends Fake implements BookingEnitities {}

// ─── Mock ──────────────────────────────────────────────────────────────────

class MockBookingViewModel extends Notifier<BookingState>
    with Mock
    implements BookingViewModel {
  @override
  BookingState build() => const BookingState();
}

// ─── Fake Bike ─────────────────────────────────────────────────────────────

BikeEntity fakeBike({bool isAvailable = true}) => BikeEntity(
  id: 'bike_001',
  name: 'Yamaha R15',
  brand: 'Yamaha',
  price: '10',
  milage: '40 kmpl',
  engineCC: 155,
  isAvailable: isAvailable,
  imageUrl: null,
);

// ─── Helper ────────────────────────────────────────────────────────────────

Widget buildWidget({required BikeEntity bike, VoidCallback? onTap}) {
  return ProviderScope(
    overrides: [
      bookingViewModelProvider.overrideWith(() {
        final notifier = MockBookingViewModel();
        when(() => notifier.createBooking(any())).thenAnswer((_) async {});
        return notifier;
      }),
    ],
    child: MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(child: BikeCard(bike: bike, onTap: onTap)),
      ),
    ),
  );
}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeBookingEnitities());
  });

  // ─── 1. Rendering ─────────────────────────────────────────────────────────

  group('Rendering', () {
    testWidgets('renders bike name', (tester) async {
      await tester.pumpWidget(buildWidget(bike: fakeBike()));
      await tester.pump();

      expect(find.text('Yamaha R15'), findsOneWidget);
    });

    testWidgets('renders brand badge', (tester) async {
      await tester.pumpWidget(buildWidget(bike: fakeBike()));
      await tester.pump();

      expect(find.text('Yamaha'), findsOneWidget);
    });

    testWidgets('renders available badge when bike is available', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget(bike: fakeBike(isAvailable: true)));
      await tester.pump();

      expect(find.text('✓ Available'), findsOneWidget);
    });

    testWidgets('renders unavailable badge when bike is not available', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget(bike: fakeBike(isAvailable: false)));
      await tester.pump();

      expect(find.text('Unavailable'), findsWidgets);
    });

    testWidgets('renders mileage', (tester) async {
      await tester.pumpWidget(buildWidget(bike: fakeBike()));
      await tester.pump();

      expect(find.text('40 kmpl'), findsOneWidget);
    });

    testWidgets('renders engine CC', (tester) async {
      await tester.pumpWidget(buildWidget(bike: fakeBike()));
      await tester.pump();

      expect(find.text('155cc'), findsOneWidget);
    });

    testWidgets('renders petrol label', (tester) async {
      await tester.pumpWidget(buildWidget(bike: fakeBike()));
      await tester.pump();

      expect(find.text('Petrol'), findsOneWidget);
    });

    testWidgets('renders Per Hour and Per Day labels', (tester) async {
      await tester.pumpWidget(buildWidget(bike: fakeBike()));
      await tester.pump();

      expect(find.text('Per Hour'), findsOneWidget);
      expect(find.text('Per Day'), findsOneWidget);
    });

    testWidgets('renders placeholder when imageUrl is null', (tester) async {
      await tester.pumpWidget(buildWidget(bike: fakeBike()));
      await tester.pump();

      expect(find.byIcon(Icons.two_wheeler), findsOneWidget);
      expect(find.byType(Image), findsNothing);
    });

    testWidgets('renders Image.network when imageUrl is provided', (
      tester,
    ) async {
      final bike = BikeEntity(
        id: '1',
        name: 'Test Bike',
        brand: 'Brand',
        price: '10',
        milage: '30 kmpl',
        engineCC: 100,
        isAvailable: true,
        imageUrl: 'https://example.com/bike.jpg',
      );

      await tester.pumpWidget(buildWidget(bike: bike));
      await tester.pump();

      expect(find.byType(Image), findsOneWidget);
      final image = tester.widget<Image>(find.byType(Image));
      expect(image.image, isA<NetworkImage>());
    });
  });

  // ─── 2. Book Now Button ───────────────────────────────────────────────────

  group('Book Now button', () {
    testWidgets('shows Book Now when bike is available', (tester) async {
      await tester.pumpWidget(buildWidget(bike: fakeBike(isAvailable: true)));
      await tester.pump();

      expect(find.text('Book Now'), findsOneWidget);
    });

    testWidgets('shows Unavailable when bike is not available', (tester) async {
      await tester.pumpWidget(buildWidget(bike: fakeBike(isAvailable: false)));
      await tester.pump();

      expect(find.text('Unavailable'), findsWidgets);
    });

    testWidgets('Book Now button is enabled when bike is available', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget(bike: fakeBike(isAvailable: true)));
      await tester.pump();

      final button = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Book Now'),
      );
      expect(button.onPressed, isNotNull);
    });

    testWidgets('button is disabled when bike is unavailable', (tester) async {
      await tester.pumpWidget(buildWidget(bike: fakeBike(isAvailable: false)));
      await tester.pump();

      final buttons = tester.widgetList<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      for (final btn in buttons) {
        expect(btn.onPressed, isNull);
      }
    });
  });

  // ─── 3. onTap callback ────────────────────────────────────────────────────

  group('onTap callback', () {
    testWidgets('calls onTap when card is tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(
        buildWidget(bike: fakeBike(), onTap: () => tapped = true),
      );
      await tester.pump();

      await tester.tap(find.byType(GestureDetector).first);
      await tester.pump();

      expect(tapped, isTrue);
    });
  });

  // ─── 4. Booking Bottom Sheet ──────────────────────────────────────────────

  group('Booking bottom sheet', () {
    testWidgets('opens when Book Now is tapped', (tester) async {
      await tester.pumpWidget(buildWidget(bike: fakeBike(isAvailable: true)));
      await tester.pump();

      await tester.tap(find.text('Book Now'));
      await tester.pumpAndSettle();

      expect(find.text('Book Yamaha R15'), findsOneWidget);
    });

    testWidgets('shows Booking Date and Return Date labels', (tester) async {
      await tester.pumpWidget(buildWidget(bike: fakeBike()));
      await tester.pump();

      await tester.tap(find.text('Book Now'));
      await tester.pumpAndSettle();

      expect(find.text('Booking Date'), findsOneWidget);
      expect(find.text('Return Date'), findsOneWidget);
    });

    testWidgets('shows hint text in date fields initially', (tester) async {
      await tester.pumpWidget(buildWidget(bike: fakeBike()));
      await tester.pump();

      await tester.tap(find.text('Book Now'));
      await tester.pumpAndSettle();

      expect(find.text('Select start date'), findsOneWidget);
      expect(find.text('Select return date'), findsOneWidget);
    });

    testWidgets('Confirm Booking button is disabled with no dates', (
      tester,
    ) async {
      await tester.pumpWidget(buildWidget(bike: fakeBike()));
      await tester.pump();

      await tester.tap(find.text('Book Now'));
      await tester.pumpAndSettle();

      final confirmButton = tester.widget<ElevatedButton>(
        find.widgetWithText(ElevatedButton, 'Confirm Booking'),
      );
      expect(confirmButton.onPressed, isNull);
    });

    testWidgets('shows calendar icons in date fields', (tester) async {
      await tester.pumpWidget(buildWidget(bike: fakeBike()));
      await tester.pump();

      await tester.tap(find.text('Book Now'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.calendar_today), findsWidgets);
    });

    testWidgets('shows bike price in bottom sheet', (tester) async {
      await tester.pumpWidget(buildWidget(bike: fakeBike()));
      await tester.pump();

      await tester.tap(find.text('Book Now'));
      await tester.pumpAndSettle();

      expect(find.text('10'), findsWidgets);
    });

    testWidgets('bottom sheet closes when navigator pops', (tester) async {
      await tester.pumpWidget(buildWidget(bike: fakeBike()));
      await tester.pump();

      await tester.tap(find.text('Book Now'));
      await tester.pumpAndSettle();

      expect(find.text('Book Yamaha R15'), findsOneWidget);

      final NavigatorState navigator = tester.state(find.byType(Navigator));
      navigator.pop();
      await tester.pumpAndSettle();

      expect(find.text('Book Yamaha R15'), findsNothing);
    });
  });

  // ─── 5. Price Calculation ─────────────────────────────────────────────────

  group('Price calculation', () {
    testWidgets('per day price is 8x hourly price', (tester) async {
      final bike = BikeEntity(
        id: '1',
        name: 'Test Bike',
        brand: 'Brand',
        price: '10',
        milage: '30 kmpl',
        engineCC: 100,
        isAvailable: true,
        imageUrl: null,
      );

      await tester.pumpWidget(buildWidget(bike: bike));
      await tester.pump();

      // 10 * 8 = $80
      expect(find.text('\$80'), findsOneWidget);
    });
  });
}
