import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';

class FiltreButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final int? filtresCount;

  const FiltreButton({super.key, this.onPressed, this.filtresCount});

  @override
  Widget build(BuildContext context) {
    return PrimaryActionButton(
      label: Strings.filtrer,
      icon: AppIcons.tune_rounded,
      iconSize: Dimens.icon_size_base,
      onPressed: onPressed,
      suffix: filtresCount != null && filtresCount! > 0
          ? SizedBox.shrink(
              child: OverflowBox(
                maxWidth: double.infinity,
                maxHeight: double.infinity,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(Margins.spacing_xs),
                  child: Text(
                    filtresCount.toString(),
                    style: TextStyles.textBaseBoldWithColor(AppColors.primary),
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
