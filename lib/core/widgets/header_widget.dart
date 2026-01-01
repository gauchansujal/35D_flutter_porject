import 'package:flutter/material.dart';

// ignore: camel_case_types
class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF3B4EFF), Color(0xFF1B2B8F)],
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.pedal_bike, color: Colors.white, size: 28),
              SizedBox(height: 6),
              Text(
                "Bike Rental",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
          CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
