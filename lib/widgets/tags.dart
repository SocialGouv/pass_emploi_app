import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class Tag extends StatelessWidget {
  final String label;
  final SvgPicture? icon;
  final Color backgroundColor;
  final TextStyle? textStyle;
  final double borderRadius;
  final EdgeInsets padding;

  const Tag({
    Key? key,
    required this.label,
    this.icon,
    this.textStyle,
    this.backgroundColor: AppColors.lightBlue,
    this.borderRadius: 8,
    this.padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      ),
      child: Padding(
        padding: padding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) Padding(padding: const EdgeInsets.only(right: 6), child: icon),
            Flexible(child: Text(label, style: textStyle ?? TextStyles.textSmRegular())),
          ],
        ),
      ),
    );
  }
}
