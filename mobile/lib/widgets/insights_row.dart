import 'package:flutter/material.dart';

class InsightsRow extends StatelessWidget {
  final int count;
  final VoidCallback onTap;

  const InsightsRow({
    super.key,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (count == 0) return const SizedBox.shrink();

    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.lightbulb_outline, color: Colors.blue),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Insights • $count recommendations',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
