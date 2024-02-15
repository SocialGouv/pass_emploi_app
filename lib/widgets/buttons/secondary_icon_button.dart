import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/widgets/buttons/focused_border_builder.dart';

class SecondaryIconButton extends StatelessWidget {
  final IconData? icon;
  final VoidCallback? onTap;
  final Color iconColor;
  final Color? borderColor;
  final double iconSize;
  final String? tooltip;

  SecondaryIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    Color? iconColor,
    this.borderColor,
    this.iconSize = Dimens.icon_size_m,
    this.tooltip,
  }) : iconColor = iconColor ?? AppColors.primary;

  @override
  Widget build(BuildContext context) {
    const double width = 59;
    const double height = 59;

    return FocusedBorderBuilder(builder: (focusNode) {
      return Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: borderColor ?? iconColor),
        ),
        child: IconButton(
          tooltip: tooltip,
          focusNode: focusNode,
          onPressed: onTap,
          icon: Icon(icon, size: iconSize, color: iconColor),
          padding: EdgeInsets.all(0),
        ),
      );
    });
  }
}
