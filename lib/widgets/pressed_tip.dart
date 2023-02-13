import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class PressedTip extends StatelessWidget {
  final String tip;
  const PressedTip(this.tip);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            tip,
            style: TextStyles.textSMedium(color: Colors.black),
            textAlign: TextAlign.end,
          ),
        ),
        SizedBox(width: Margins.spacing_xs),
        Icon(AppIcons.chevron_right_rounded, color: Colors.black, size: Dimens.icon_size_m),
      ],
    );
  }
}
