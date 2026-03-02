import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/bike_card/presentation/widget/bike_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_application_1/features/bike_card/domain/entites/bike_entity.dart';
import 'package:flutter_application_1/features/Booking/presentation/view_models/booking_viewmodel.dart';
import 'package:flutter_application_1/features/Booking/domain/entites/booking_enitities.dart';

// ── Fake ViewModel ────────────────────────────────────────────────
class FakeBookingViewModel extends BookingViewModel {
  @override
  Future<void> createBooking(BookingEnitities booking) async {}
}

// ── Helpers ───────────────────────────────────────────────────────
BikeEntity fakeBike({bool isAvailable = true}) => BikeEntity(
  id: '1',
  name: 'Test Bike',
  brand: 'Yamaha',
  price: '\$10',
  milage: '35 kmpl',
  engineCC: 150, // ← int not String
  imageUrl: '',
  isAvailable: isAvailable,
);

Widget buildCard(BikeEntity bike) => ProviderScope(
  overrides: [
    bookingViewModelProvider.overrideWith(() => FakeBookingViewModel()),
  ],
  child: MaterialApp(home: Scaffold(body: BikeCard(bike: bike))),
);

// ── Tests ─────────────────────────────────────────────────────────
void main() {
  testWidgets('shows bike name and brand', (tester) async {
    await tester.pumpWidget(buildCard(fakeBike()));

    expect(find.text('Test Bike'), findsOneWidget);
    expect(find.text('Yamaha'), findsOneWidget);
  });

  testWidgets('shows Book Now when available', (tester) async {
    await tester.pumpWidget(buildCard(fakeBike(isAvailable: true)));

    expect(find.text('Book Now'), findsOneWidget);
  });

  testWidgets('shows Unavailable when not available', (tester) async {
    await tester.pumpWidget(buildCard(fakeBike(isAvailable: false)));

    expect(find.text('Unavailable'), findsWidgets);
  });

  testWidgets('Book Now button is disabled when unavailable', (tester) async {
    await tester.pumpWidget(buildCard(fakeBike(isAvailable: false)));

    final btn = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(btn.onPressed, isNull);
  });

  testWidgets('shows placeholder icon when image URL is empty', (tester) async {
    await tester.pumpWidget(buildCard(fakeBike()));

    expect(find.byIcon(Icons.two_wheeler), findsOneWidget);
  });
}
