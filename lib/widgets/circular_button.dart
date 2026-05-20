import 'package:flutter/material.dart';

Widget circularButton({
  required VoidCallback onTap,
  required IconData icon,
  required Offset shadowOffset,
  String label = '',
  Color color = const Color.fromRGBO(100, 181, 246, 1),
  double height = 100,
  double width = 100,
  double shadowSpreadRadius = 0,
}) {
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
