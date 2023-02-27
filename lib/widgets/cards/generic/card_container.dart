import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/shadows.dart';

class CardContainer extends StatelessWidget {
  final Widget child;
  final void Function()? onTap;
  final Color backgroundColor;

  const CardContainer({super.key, required this.child, this.onTap, this.backgroundColor = Colors.white});

  @override
  Widget build(BuildContext context) {
    final BorderRadius cardBorderRadius = BorderRadius.circular(Dimens.radius_base);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: cardBorderRadius,
        boxShadow: [Shadows.radius_base],
      ),
      child: Material(
          color: backgroundColor,
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
