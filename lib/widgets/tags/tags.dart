import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class IconWithSemantics {
  final IconData icon;
  final String label;

  IconWithSemantics(this.icon, this.label);
}

class DataTag extends StatelessWidget {
  final String label;
  final IconWithSemantics? iconSemantics;
  final Color contentColor;
  final Color backgroundColor;

  DataTag({
    super.key,
    required this.label,
    this.iconSemantics,
    Color? contentColor,
    this.backgroundColor = AppColors.primaryLighten,
  }) : contentColor = contentColor ?? AppColors.primary;

  factory DataTag.location(String location) {
    return DataTag(
      label: location,
      iconSemantics: IconWithSemantics(AppIcons.place_outlined, Strings.iconAlternativeLocation),
    );
  }

  factory DataTag.contractType(String contractType) {
    return DataTag(
      label: contractType,
      iconSemantics: IconWithSemantics(AppIcons.description_rounded, Strings.iconAlternativeContractType),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.all(Radius.circular(Dimens.radius_base)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_s, vertical: Margins.spacing_xs),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (iconSemantics != null)
              Padding(
                padding: const EdgeInsets.only(right: 6),
                child: Icon(
                  iconSemantics!.icon,
                  semanticLabel: iconSemantics!.label,
                  color: contentColor,
                  size: Dimens.icon_size_base,
                ),
              ),
            Flexible(child: Text(label, style: TextStyles.textXsBold().copyWith(color: contentColor))),
          ],
        ),
      ),
    );
  }
}
