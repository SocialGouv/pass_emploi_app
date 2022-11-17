import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class RendezvousTag extends StatelessWidget {
  const RendezvousTag(this.tag, this.isGreenTag, {Key? key}) : super(key: key);

  final String tag;
  final bool isGreenTag;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(40)),
        color: isGreenTag ? AppColors.accent3Lighten : AppColors.accent2Lighten,
        border: Border.all(color: isGreenTag ? AppColors.accent3 : AppColors.accent2),
      ),
      padding: const EdgeInsets.symmetric(vertical: Margins.spacing_xs, horizontal: Margins.spacing_base),
      child: Text(
        tag,
        style: TextStyles.textSRegularWithColor(isGreenTag ? AppColors.accent3 : AppColors.accent2),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}