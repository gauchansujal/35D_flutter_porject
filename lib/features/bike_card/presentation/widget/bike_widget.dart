// lib/features/bike_card/presentation/widgets/bike_card.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/features/bike_card/domain/entites/bike_entity.dart';

class BikeCard extends StatelessWidget {
  final BikeEntity bike;
  final VoidCallback? onTap;

  const BikeCard({super.key, required this.bike, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF1C1E2A), // dark navy card
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
                // Bike Image
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
                                if (loadingProgress == null) {
                                  return child;
                                }
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: Color(0xFFE91E8C),
                                    strokeWidth: 3,
                                  ),
                                );
                              },
                              errorBuilder: (context, error, stackTrace) {
                                // Debug prints – very important for troubleshooting
                                debugPrint(
                                  'Image failed to load: ${bike.fullImageUrl}',
                                );
                                debugPrint('Error: $error');
                                debugPrint('Stack: $stackTrace');
                                return _placeholder();
                              },
                            )
                            : _placeholder(),
                  ),
                ),

                // Brand Badge (top left)
                Positioned(
                  top: 12,
                  left: 12,
                  child: _Badge(
                    label: bike.brand,
                    color: const Color(0xFFE91E8C), // pink
                  ),
                ),

                // Availability Badge (top right)
                Positioned(
                  top: 12,
                  right: 12,
                  child: _Badge(
                    label: bike.isAvailable ? '✓ Available' : 'Unavailable',
                    color:
                        bike.isAvailable
                            ? const Color(0xFF2ECC71) // green
                            : const Color(0xFFE74C3C), // red
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
                  // Bike Name
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

                  // Price Row
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

                  // Divider
                  Divider(color: Colors.white.withOpacity(0.08), height: 1),
                  const SizedBox(height: 12),

                  // Stats Row — fuel type + mileage
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
                      // Engine CC badge
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Simple per day calculation (improved parsing)
  String _calculatePerDay(String hourlyPrice) {
    // Remove non-numeric characters and parse
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
