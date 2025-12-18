import 'package:flutter/material.dart';

class BikeCard extends StatelessWidget {
  const BikeCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF0F2027), Color(0xFF203A43)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// IMAGE SECTION
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Image.asset(
                  'assets/images/royal_enfield.jpg',

                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              /// CATEGORY
              _chip("Sports", Colors.pink, left: 12),

              /// STATUS
              _chip("Available", Colors.green, right: 12, icon: Icons.check),
            ],
          ),

          /// DETAILS
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Yamaha R15 V4",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 12),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    _Price(title: "Per Hour", price: "\$8"),
                    _Price(title: "Per Day", price: "\$45"),
                  ],
                ),

                const SizedBox(height: 12),

                const Row(
                  children: [
                    Icon(
                      Icons.local_gas_station,
                      color: Colors.white70,
                      size: 18,
                    ),
                    SizedBox(width: 6),
                    Text("Petrol", style: TextStyle(color: Colors.white70)),
                    SizedBox(width: 16),
                    Icon(Icons.speed, color: Colors.white70, size: 18),
                    SizedBox(width: 6),
                    Text("40 km/l", style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// CHIP WIDGET
  Widget _chip(
    String text,
    Color color, {
    double? left,
    double? right,
    IconData? icon,
  }) {
    return Positioned(
      top: 12,
      left: left,
      right: right,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: Colors.white),
              const SizedBox(width: 4),
            ],
            Text(text, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

/// PRICE WIDGET
class _Price extends StatelessWidget {
  final String title;
  final String price;

  const _Price({required this.title, required this.price});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.white70)),
        const SizedBox(height: 4),
        Text(
          price,
          style: const TextStyle(
            color: Colors.pinkAccent,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
