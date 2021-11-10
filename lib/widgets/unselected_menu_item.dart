import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class UnselectedMenuItem extends StatelessWidget {
  final String drawableRes;
  final String label;
  final bool withBadge;

  const UnselectedMenuItem({
    required this.drawableRes,
    required this.label,
    required this.withBadge,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              child: SvgPicture.asset(drawableRes, color: AppColors.nightBlue),
              height: Dimens.bottomNavigationBarItemHeight,
            ),
            if (withBadge) Positioned(child: SvgPicture.asset(Drawables.icBadge), top: -1, left: 12),
          ],
        ),
        SizedBox(height: 6.0),
        Text(label, style: TextStyles.textMenuRegular(AppColors.nightBlue)),
      ],
    );
  }
}
