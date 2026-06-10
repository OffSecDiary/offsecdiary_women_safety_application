import 'package:flutter/material.dart';

class QuickActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color iconColor;
  final Color textColor;
  final double radius;
  final double iconSize;
  final double fontSize;

  const QuickActionTile({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.backgroundColor = const Color(0xFFE53935),
    this.iconColor = Colors.white,
    this.textColor = Colors.white,
    this.radius = 28,
    this.iconSize = 26,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: radius,
            backgroundColor: backgroundColor,
            child: Icon(
              icon,
              color: iconColor,
              size: iconSize,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: fontSize,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}