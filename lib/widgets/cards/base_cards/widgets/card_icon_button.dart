import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';

class CardIconButton extends StatelessWidget {
  const CardIconButton(
    this.icon, {
    this.color,
    required this.onPressed,
  });
  final IconData icon;
  final Color? color;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon, color: color ?? AppColors.primary),
      onPressed: onPressed,
    );
  }
}
