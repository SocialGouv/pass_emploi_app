import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/shadows.dart';

class CardContainer extends StatelessWidget {
  const CardContainer({super.key, required this.child, this.onTap});
  final Widget child;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    const Color cardBackgroundColor = Colors.white;
    final BorderRadius cardBorderRadius = BorderRadius.circular(16);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: cardBorderRadius,
        boxShadow: [
          Shadows.boxShadow,
        ],
      ),
      child: Material(
          color: cardBackgroundColor,
          borderRadius: cardBorderRadius,
          child: InkWell(
            borderRadius: cardBorderRadius,
            onTap: onTap,
            splashColor: AppColors.primaryLighten,
            child: Padding(
              padding: EdgeInsets.all(Margins.spacing_base),
              child: child,
            ),
          )),
    );
  }
}
