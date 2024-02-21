import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';

class SepLine extends StatelessWidget {
  final double spaceBefore;
  final double spaceAfter;
  final Color color;

  const SepLine(
    this.spaceBefore,
    this.spaceAfter, {
    this.color = AppColors.primaryLighten,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: spaceBefore),
        Container(height: 1, color: color),
        SizedBox(height: spaceAfter),
      ],
    );
  }
}
