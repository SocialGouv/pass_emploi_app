import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class PassEmploiChip<T> extends StatelessWidget {
  const PassEmploiChip({
    super.key,
    required this.label,
    required this.value,
    required this.onTagSelected,
    required this.isSelected,
    this.isDisabled = false,
    this.onTagDeleted,
  });

  final String label;
  final T value;
  final void Function(T) onTagSelected;
  final bool isSelected;
  final bool isDisabled;
  final void Function()? onTagDeleted;

  @override
  Widget build(BuildContext context) {
    return _CustomChip(
      isSelected: isSelected,
      label: label,
      bgColor: isSelected ? AppColors.primaryDarken : Colors.white,
      onSelected: () => isSelected ? onTagDeleted?.call() : onTagSelected(value),
      textstyle: isSelected ? TextStyles.textSBold.copyWith(color: Colors.white) : TextStyles.textSMedium(),
      borderColor: isSelected ? AppColors.primaryDarken : AppColors.grey700,
    );
  }
}

class _CustomChip extends StatelessWidget {
  const _CustomChip({
    required this.label,
    required this.bgColor,
    required this.borderColor,
    required this.onSelected,
    required this.textstyle,
    required this.isSelected,
  });

  final String label;
  final Color bgColor;
  final Color borderColor;
  final TextStyle textstyle;
  final void Function()? onSelected;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(Dimens.radius_base),
      child: InkWell(
        borderRadius: BorderRadius.circular(Dimens.radius_base),
        onTap: onSelected,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Dimens.radius_base),
            border: Border.all(color: borderColor),
          ),
          padding: EdgeInsets.symmetric(horizontal: Margins.spacing_s, vertical: Margins.spacing_xs),
          child: Wrap(
            runAlignment: WrapAlignment.center,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                label,
                style: textstyle,
              ),
              if (isSelected) ...[
                SizedBox(width: Margins.spacing_s),
                Icon(
                  Icons.close_rounded,
                  size: Dimens.icon_size_base,
                  color: Colors.white,
                ),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
