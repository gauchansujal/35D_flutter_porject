import 'package:flutter/material.dart';

class DocumentSectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const DocumentSectionHeader({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14, top: 6),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFE91E8C), size: 18),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Divider(color: Colors.white.withOpacity(0.08), height: 1),
          ),
        ],
      ),
    );
  }
}
