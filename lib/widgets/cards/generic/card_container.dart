import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/shadows.dart';

class CardContainer extends StatelessWidget {
  const CardContainer({
    super.key,
    required this.child,
    this.onTap,
    this.cardBackgroundColor = Colors.white,
  });

  final Color cardBackgroundColor;
  final Widget child;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final BorderRadius cardBorderRadius = BorderRadius.circular(Dimens.radius_s);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: cardBackgroundColor,
        borderRadius: cardBorderRadius,
        boxShadow: [Shadows.boxShadow],
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
