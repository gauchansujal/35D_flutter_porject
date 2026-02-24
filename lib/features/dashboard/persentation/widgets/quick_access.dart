import 'package:flutter/material.dart';

import 'package:flutter_application_1/features/bike_card/presentation/pages/bike_page.dart';
import 'package:flutter_application_1/features/uplodedocument/presentation/pages/uplod_document.dart';
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
                // ✅ Navigate to BikeListPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BikeListPage()),
                );
              },
              child: const IconBox(
                icon: Icons.two_wheeler, // ✅ bike icon makes more sense
                color: Colors.orange,
              ),
            ),
            GestureDetector(
              onTap: () {
                print("Notifications tapped");
              },
              child: const IconBox(
                icon: Icons.notifications,
                color: Colors.indigo,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => UploadDocumentPage()),
                );
              },
              child: const IconBox(icon: Icons.upload_file, color: Colors.red),
            ),
          ],
        ),
      ],
    );
  }
}
