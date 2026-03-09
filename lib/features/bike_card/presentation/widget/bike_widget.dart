import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/Booking/domain/entites/booking_enitities.dart';
import 'package:flutter_application_1/features/Booking/presentation/providers/state/booking_state.dart';
import 'package:flutter_application_1/features/Booking/presentation/view_models/booking_viewmodel.dart';
import 'package:flutter_application_1/features/bike_card/domain/entites/bike_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BikeCard extends ConsumerWidget {
  final BikeEntity bike;
  final VoidCallback? onTap;

  const BikeCard({super.key, required this.bike, this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                              errorBuilder:
                                  (context, error, stackTrace) =>
                                      _placeholder(),
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
                              ? () => _showBookingSheet(
                                context,
                                ref,
                              ) // ✅ show date picker
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

  // ── Date Picker Bottom Sheet ──────────────────────────────────────────────
  void _showBookingSheet(BuildContext context, WidgetRef ref) {
    DateTime? bookingDate;
    DateTime? returnDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1C1E2A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final canBook = bookingDate != null && returnDate != null;
            final days =
                canBook ? returnDate!.difference(bookingDate!).inDays : 0;

            return Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                20,
                20,
                MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Handle bar
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Text(
                    'Book ${bike.name}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    bike.price,
                    style: const TextStyle(
                      color: Color(0xFFE91E8C),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // ── Booking Date ──────────────────────────────────
                  const Text(
                    'Booking Date',
                    style: TextStyle(color: Color(0xFF8A8FA8), fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        builder:
                            (context, child) => Theme(
                              data: ThemeData.dark().copyWith(
                                colorScheme: const ColorScheme.dark(
                                  primary: Color(0xFFE91E8C),
                                  surface: Color(0xFF1C1E2A),
                                ),
                              ),
                              child: child!,
                            ),
                      );
                      if (picked != null) {
                        setSheetState(() {
                          bookingDate = picked;
                          // reset returnDate if before bookingDate
                          if (returnDate != null &&
                              returnDate!.isBefore(picked)) {
                            returnDate = null;
                          }
                        });
                      }
                    },
                    child: _DateField(
                      date: bookingDate,
                      hint: 'Select start date',
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ── Return Date ───────────────────────────────────
                  const Text(
                    'Return Date',
                    style: TextStyle(color: Color(0xFF8A8FA8), fontSize: 13),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate:
                            bookingDate != null
                                ? bookingDate!.add(const Duration(days: 1))
                                : DateTime.now().add(const Duration(days: 1)),
                        firstDate:
                            bookingDate != null
                                ? bookingDate!.add(const Duration(days: 1))
                                : DateTime.now().add(const Duration(days: 1)),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        builder:
                            (context, child) => Theme(
                              data: ThemeData.dark().copyWith(
                                colorScheme: const ColorScheme.dark(
                                  primary: Color(0xFFE91E8C),
                                  surface: Color(0xFF1C1E2A),
                                ),
                              ),
                              child: child!,
                            ),
                      );
                      if (picked != null) {
                        setSheetState(() => returnDate = picked);
                      }
                    },
                    child: _DateField(
                      date: returnDate,
                      hint: 'Select return date',
                    ),
                  ),

                  // ── Summary ───────────────────────────────────────
                  if (canBook && days > 0) ...[
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2A2D3E),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$days day${days > 1 ? 's' : ''}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            _totalPrice(days),
                            style: const TextStyle(
                              color: Color(0xFFE91E8C),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  // ── Confirm Button ────────────────────────────────
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            canBook ? const Color(0xFFE91E8C) : Colors.grey,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed:
                          canBook
                              ? () {
                                Navigator.pop(context);
                                final booking = BookingEnitities(
                                  bikeId: bike.id,
                                  bookingDate: bookingDate!,
                                  returnDate: returnDate!,
                                );
                                ref
                                    .read(bookingViewModelProvider.notifier)
                                    .createBooking(booking);
                              }
                              : null,
                      child: const Text(
                        'Confirm Booking',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  String _totalPrice(int days) {
    final clean = bike.price.replaceAll(RegExp(r'[^0-9]'), '');
    final hourly = int.tryParse(clean) ?? 0;
    return '\$${hourly * 8 * days}';
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

// ── Date Field Widget ─────────────────────────────────────────────────────────
class _DateField extends StatelessWidget {
  final DateTime? date;
  final String hint;

  const _DateField({required this.date, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2D3E),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              date != null
                  ? const Color(0xFFE91E8C).withOpacity(0.5)
                  : Colors.white12,
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.calendar_today, color: Color(0xFFE91E8C), size: 18),
          const SizedBox(width: 12),
          Text(
            date != null ? '${date!.day}/${date!.month}/${date!.year}' : hint,
            style: TextStyle(
              color: date != null ? Colors.white : const Color(0xFF8A8FA8),
              fontSize: 14,
            ),
          ),
        ],
      ),
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
