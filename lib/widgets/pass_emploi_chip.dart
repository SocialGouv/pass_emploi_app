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
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _CustomChip(
          label: label,
          bgColor: isSelected ? AppColors.primaryDarken : Colors.white,
          onSelected: () => isSelected ? onTagDeleted?.call() : onTagSelected(value),
          textstyle: isSelected ? TextStyles.textSBold.copyWith(color: Colors.white) : TextStyles.textSMedium(),
          borderColor: isSelected ? AppColors.primaryDarken : AppColors.grey700,
        ),
        if (isSelected)
          Positioned(
            top: -0,
            right: -0,
            child: SizedBox(
              width: 0,
              height: 0,
              child: OverflowBox(
                maxHeight: double.infinity,
                maxWidth: double.infinity,
                child: IconButton(
                  onPressed: onTagDeleted,
                  icon: Container(
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Icon(
                      Icons.cancel_outlined,
                      size: Dimens.icon_size_base,
                      color: AppColors.primaryDarken,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
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
  });

  final String label;
  final Color bgColor;
  final Color borderColor;
  final TextStyle textstyle;
  final void Function()? onSelected;

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
          child: Text(
            label,
            style: textstyle,
          ),
        ),
      ),
    );
  }
}
