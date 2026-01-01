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
        const SizedBox(height: 10),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            GestureDetector(
              onTap: () {
                // action for Description button
                print("Description tapped");
              },
              child: const IconBox(
                icon: Icons.description,
                color: Colors.orange,
              ),
            ),
            GestureDetector(
              onTap: () {
                // action for Notifications button
                print("Notifications tapped");
              },
              child: const IconBox(
                icon: Icons.notifications,
                color: Colors.indigo,
              ),
            ),
            GestureDetector(
              onTap: () {
                // action for Wallet button
                print("Wallet tapped");
              },
              child: const IconBox(icon: Icons.wallet, color: Colors.red),
            ),
          ],
        ),
      ],
    );
  }
}
