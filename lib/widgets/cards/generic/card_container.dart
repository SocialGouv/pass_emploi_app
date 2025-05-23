import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/shadows.dart';

class CardContainer extends StatelessWidget {
  final Widget child;
  final void Function()? onTap;
  final void Function()? onLongPress;
  final Color backgroundColor;
  final Color? splashColor;
  final EdgeInsets padding;
  final bool withShadow;
  final DecorationImage? image;

  CardContainer({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.backgroundColor = Colors.white,
    Color? splashColor,
    this.padding = const EdgeInsets.all(Margins.spacing_base),
    this.withShadow = true,
    this.image,
  }) : splashColor = splashColor ?? AppColors.primary.withOpacity(0.2);

  @override
  Widget build(BuildContext context) {
    final BorderRadius cardBorderRadius = BorderRadius.circular(Dimens.radius_base);

    // a11y 10.2 : to avoid useless tap trigger we should remove inkwell
    final childWithPadding = Padding(
      padding: padding,
      child: child,
    );
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: cardBorderRadius,
        boxShadow: withShadow ? [Shadows.radius_base] : [],
        image: image,
      ),
      child: (onTap == null && onLongPress == null)
          ? childWithPadding
          : Material(
              clipBehavior: Clip.hardEdge,
              color: backgroundColor,
              borderRadius: cardBorderRadius,
              child: InkWell(
                borderRadius: cardBorderRadius,
                onTap: onTap,
                onLongPress: onLongPress != null
                    ? () {
                        HapticFeedback.heavyImpact();
                        onLongPress!.call();
                      }
                    : null,
                splashColor: splashColor,
                child: childWithPadding,
              ),
            ),
    );
  }
}
