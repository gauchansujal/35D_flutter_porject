import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.blue,
            child: Icon(Icons.person, size: 40, color: Colors.white),
          ),
          SizedBox(height: 12),
          Text("sujal", style: TextStyle(color: Colors.white, fontSize: 18)),
          SizedBox(height: 6),
          Text("john@example.com", style: TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}
