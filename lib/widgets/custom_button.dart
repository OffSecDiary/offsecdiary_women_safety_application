import 'package:flutter/material.dart';

import '../core/theme/theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double height;
  final double borderRadius;
  final bool isFullWidth;

  const CustomButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.backgroundColor = AppTheme.primaryRed,
    this.textColor = Colors.white,
    this.height = 58,
    this.borderRadius = 16,
    this.isFullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    final buttonChild = icon != null
        ? ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: textColor,
      ),
      label: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: _buttonStyle(),
    )
        : ElevatedButton(
      onPressed: onPressed,
      style: _buttonStyle(),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height,
      child: buttonChild,
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      disabledBackgroundColor: Colors.grey,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      elevation: 2,
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 14,
      ),
    );
  }
}