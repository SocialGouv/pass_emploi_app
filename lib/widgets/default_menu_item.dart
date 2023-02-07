import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class DefaultMenuItem extends StatelessWidget {
  final String drawableRes;
  final String label;
  final bool isActive;
  final bool withBadge;

  const DefaultMenuItem({
    required this.drawableRes,
    required this.label,
    required this.isActive,
    required this.withBadge,
  }) : super();

  @override
  Widget build(BuildContext context) {
    final Color color = _itemColor(isActive);

    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              height: Dimens.bottomNavigationBarItemHeight,
              child: SvgPicture.asset(drawableRes, color: color),
            ),
            if (withBadge) Positioned(top: -1, left: 12, child: SvgPicture.asset(Drawables.badge)),
          ],
        ),
        SizedBox(height: Margins.spacing_s),
        Text(label, style: TextStyles.textMenuRegular(color).copyWith(fontWeight: isActive ? FontWeight.bold : null)),
      ],
    );
  }
}

Color _itemColor(bool isActive) {
  return isActive ? AppColors.primary : AppColors.grey800;
}
