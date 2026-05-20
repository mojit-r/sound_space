import 'package:flutter/material.dart';

class CircularButton extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final Offset shadowOffset;
  final String label;
  final Color color;
  final double height;
  final double width;
  final double shadowSpreadRadius;

  const CircularButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.shadowOffset,
    this.label = '',
    this.color = const Color.fromRGBO(100, 181, 246, 1),
    this.height = 100,
    this.width = 100,
    this.shadowSpreadRadius = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color.withValues(alpha: 0.5),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.5),
              offset: shadowOffset,
              blurRadius: 16,
              blurStyle: BlurStyle.outer,
              spreadRadius: shadowSpreadRadius,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Icon(icon), if (label != '') Text(label)],
        ),
      ),
    );
  }
}
