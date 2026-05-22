import 'package:flutter/material.dart';

class RectangularButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final IconData icon;
  final Color color;
  final bool isEnabled;

  const RectangularButton({
    super.key,
    required this.onTap,
    required this.label,
    required this.icon,
    required this.color,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        width: 180,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(12),
          color: color,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 28),
                const SizedBox(height: 8),
                Icon(
                  Icons.circle,
                  size: 12,
                  color: isEnabled
                      ? Colors.green.shade300
                      : Colors.grey.shade300,
                  shadows: const [
                    Shadow(
                      blurRadius: 2.0,
                      color: Colors.black,
                      offset: Offset.zero,
                    ),

                    Shadow(
                      blurRadius: 2.0,
                      color: Colors.black,
                      offset: Offset.zero,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(width: 10),
            const VerticalDivider(color: Colors.black, indent: 8, endIndent: 8),
            const SizedBox(width: 10),
            Text(label),
          ],
        ),
      ),
    );
  }
}
