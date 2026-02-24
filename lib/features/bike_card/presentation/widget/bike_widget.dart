import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/Booking/domain/entites/booking_enitities.dart';
import 'package:flutter_application_1/features/Booking/presentation/providers/state/booking_state.dart';
import 'package:flutter_application_1/features/Booking/presentation/view_models/booking_viewmodel.dart';
import 'package:flutter_application_1/features/bike_card/domain/entites/bike_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BikeCard extends ConsumerWidget {
  // ← ConsumerWidget to access ref
  final BikeEntity bike;
  final VoidCallback? onTap;

  const BikeCard({super.key, required this.bike, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ← WidgetRef ref

    // Listen to booking state for loading/error/success
    ref.listen<BookingState>(bookingViewModelProvider, (previous, next) {
      if (next.status == BookingStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Bike booked successfully!'),
            backgroundColor: Color(0xFF2ECC71),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      if (next.status == BookingStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ ${next.errorMessage ?? 'Booking failed'}'),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    });

    final bookingState = ref.watch(bookingViewModelProvider);
    final isBooking = bookingState.isCreating;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1E2A),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image + Badges ──────────────────────────────────────
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                  child: SizedBox(
                    height: 180,
                    width: double.infinity,
                    child:
                        bike.fullImageUrl.isNotEmpty
                            ? Image.network(
                              bike.fullImageUrl,
                              fit: BoxFit.cover,
                              loadingBuilder: (
                                context,
                                child,
                                loadingProgress,
                              ) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFFE91E8C),
                                    strokeWidth: 3,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return _placeholder();
                              },
                            )
                            : _placeholder(),
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: _Badge(
                    label: bike.brand,
                    color: const Color(0xFFE91E8C),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: _Badge(
                    label: bike.isAvailable ? '✓ Available' : 'Unavailable',
                    color:
                        bike.isAvailable
                            ? const Color(0xFF2ECC71)
                            : const Color(0xFFE74C3C),
                  ),
                ),
              ],
            ),

            // ── Card Content ─────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    bike.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _PriceColumn(label: 'Per Hour', price: bike.price),
                      _PriceColumn(
                        label: 'Per Day',
                        price: _calculatePerDay(bike.price),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Divider(color: Colors.white.withOpacity(0.08), height: 1),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(
                        Icons.local_gas_station,
                        size: 16,
                        color: Color(0xFF8A8FA8),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Petrol',
                        style: TextStyle(
                          color: Color(0xFF8A8FA8),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.speed,
                        size: 16,
                        color: Color(0xFF8A8FA8),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        bike.milage,
                        style: const TextStyle(
                          color: Color(0xFF8A8FA8),
                          fontSize: 13,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2A2D3E),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${bike.engineCC}cc',
                          style: const TextStyle(
                            color: Color(0xFF8A8FA8),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // ── Book Now Button ─────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            bike.isAvailable
                                ? const Color(0xFFE91E8C)
                                : Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed:
                          bike.isAvailable && !isBooking
                              ? () => _onBookNow(context, ref)
                              : null,
                      child:
                          isBooking
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : Text(
                                bike.isAvailable ? 'Book Now' : 'Unavailable',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Book Now Handler ──────────────────────────────────────────────────────
  void _onBookNow(BuildContext context, WidgetRef ref) {
    final booking = BookingEnitities(
      bikeId: bike.id,
      bookingDate: DateTime.now(),
      returnDate: DateTime.now().add(const Duration(hours: 1)), // default 1hr
    );

    ref.read(bookingViewModelProvider.notifier).createBooking(booking);
  }

  String _calculatePerDay(String hourlyPrice) {
    final cleanPrice = hourlyPrice.replaceAll(RegExp(r'[^0-9]'), '');
    final price = int.tryParse(cleanPrice) ?? 0;
    return '\$${price * 8}';
  }

  Widget _placeholder() {
    return Container(
      height: 180,
      width: double.infinity,
      color: const Color(0xFF2A2D3E),
      child: const Icon(Icons.two_wheeler, size: 72, color: Color(0xFF3A3D4E)),
    );
  }
}

// ── Badge Widget ──────────────────────────────────────────────────────────────
class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

// ── Price Column Widget ───────────────────────────────────────────────────────
class _PriceColumn extends StatelessWidget {
  final String label;
  final String price;

  const _PriceColumn({required this.label, required this.price});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF8A8FA8), fontSize: 12),
        ),
        const SizedBox(height: 2),
        Text(
          price,
          style: const TextStyle(
            color: Color(0xFFE91E8C),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
