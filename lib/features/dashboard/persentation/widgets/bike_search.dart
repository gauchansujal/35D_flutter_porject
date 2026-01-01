import 'package:flutter/material.dart';

class BikeSearch extends StatefulWidget {
  const BikeSearch({super.key});

  @override
  State<BikeSearch> createState() => _BikeSearchState();
}

class _BikeSearchState extends State<BikeSearch> {
  bool showFilters = false; // toggle filter visibility

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1B1F38),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Filter button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Find Your Bike",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  setState(() {
                    showFilters = !showFilters;
                  });
                },
                icon: const Icon(Icons.filter_list, color: Colors.white),
                label: const Text(
                  "Filters",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Search bar
          TextField(
            decoration: InputDecoration(
              hintText: "Search bikes...",
              hintStyle: const TextStyle(color: Colors.white54),
              prefixIcon: const Icon(Icons.search, color: Colors.white54),
              filled: true,
              fillColor: const Color(0xFF2A2E43),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            style: const TextStyle(color: Colors.white),
          ),

          const SizedBox(height: 12),

          // Filters (shown only when showFilters == true)
          if (showFilters) ...[
            const Text("Bike Type", style: TextStyle(color: Colors.white70)),
            DropdownButton<String>(
              value: "All Types",
              dropdownColor: const Color(0xFF2A2E43),
              items:
                  ["All Types", "Mountain", "Road", "Electric"]
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                      .toList(),
              onChanged: (_) {},
            ),
            const SizedBox(height: 12),

            const Text("Availability", style: TextStyle(color: Colors.white70)),
            DropdownButton<String>(
              value: "All Bikes",
              dropdownColor: const Color(0xFF2A2E43),
              items:
                  ["All Bikes", "Available", "Booked"]
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                      .toList(),
              onChanged: (_) {},
            ),
            const SizedBox(height: 12),

            const Text(
              "Price Range (Per Day)",
              style: TextStyle(color: Colors.white70),
            ),
            DropdownButton<String>(
              value: "All Prices",
              dropdownColor: const Color(0xFF2A2E43),
              items:
                  ["All Prices", "< \$20", "\$20 - \$50", "> \$50"]
                      .map(
                        (e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            e,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      )
                      .toList(),
              onChanged: (_) {},
            ),
          ],
        ],
      ),
    );
  }
}
