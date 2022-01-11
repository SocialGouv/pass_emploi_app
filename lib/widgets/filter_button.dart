import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';

class PrimaryActionButton extends StatelessWidget {

  final Row child;
  final Color backgroundColor;
  final Color disabledBackgroundColor;
  final Color textColor;
  final Color? rippleColor;
  final String? drawableRes;
  final VoidCallback? onPressed;

  PrimaryActionButton.simple({
    Key? key,
    required String label,
    this.drawableRes,
    this.backgroundColor = AppColors.primary,
    this.disabledBackgroundColor = AppColors.primaryWithAlpha50,
    this.textColor = Colors.white,
    this.rippleColor = AppColors.primaryDarken,
    this.onPressed,
    required this.child,
  })


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }}
