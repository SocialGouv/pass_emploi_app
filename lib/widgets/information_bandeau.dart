import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class InformationBandeau extends StatelessWidget {
  final IconData icon;
  final String text;

  const InformationBandeau({super.key, required this.text, required this.icon});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.disabled,
      child: Padding(
        padding: EdgeInsets.all(Margins.spacing_xs),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: Dimens.icon_size_base),
            SizedBox(width: Margins.spacing_s),
            Expanded(child: Text(text, style: TextStyles.textSRegular(color: Colors.white))),
          ],
        ),
      ),
    );
  }
}
