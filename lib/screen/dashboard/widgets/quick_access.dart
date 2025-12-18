import 'package:flutter/material.dart';
import 'icon_box.dart';

class QuickAccess extends StatelessWidget {
  const QuickAccess({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Quick Access", style: TextStyle(color: Colors.white70)),
        const SizedBox(height: 12),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            IconBox(icon: Icons.description, color: Colors.orange),
            IconBox(icon: Icons.notifications, color: Colors.indigo),
            IconBox(icon: Icons.wallet, color: Colors.red),
          ],
        ),
      ],
    );
  }
}
