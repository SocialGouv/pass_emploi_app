import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/shadows.dart';

class CardContainer extends StatelessWidget {
  final Widget child;
  final void Function()? onTap;
  final Color backgroundColor;
  final Color splashColor;
  final EdgeInsets padding;
  final bool withShadow;

  const CardContainer({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor = Colors.white,
    this.splashColor = AppColors.primaryLighten,
    this.padding = const EdgeInsets.all(Margins.spacing_base),
    this.withShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final BorderRadius cardBorderRadius = BorderRadius.circular(Dimens.radius_base);
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: cardBorderRadius,
        boxShadow: withShadow ? [Shadows.radius_base] : [],
      ),
      child: Material(
          color: backgroundColor,
          borderRadius: cardBorderRadius,
          child: InkWell(
            borderRadius: cardBorderRadius,
            onTap: onTap,
            splashColor: splashColor,
            child: Padding(
              padding: padding,
              child: child,
            ),
          )),
    );
  }
}
