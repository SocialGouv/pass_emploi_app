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
    final Color color = currentColor(isActive);

    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  height: Dimens.bottomNavigationBarItemHeight,
                  child: SvgPicture.asset(drawableRes, color: color),
                ),
                if (withBadge) Positioned(top: -1, left: 12, child: SvgPicture.asset(Drawables.icBadge)),
              ],
            ),
            SizedBox(height: Margins.spacing_s),
            Text(label, style: TextStyles.textMenuRegular(color)),
          ],
        ),
        Builder(builder: (BuildContext context) {
          return _ActiveIndicator(
            isActive: isActive,
          );
        })
      ],
    );
  }

  static Color currentColor(bool isActive) {
    return isActive ? AppColors.secondary : AppColors.grey800;
  }
}

class _ActiveIndicator extends StatelessWidget {
  const _ActiveIndicator({required this.isActive});
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final bottomPosition = isActive ? -6.0 : -20.0;
    final opacity = isActive ? 1.0 : 0.0;
    final animationDuration = Duration(milliseconds: 800);
    return AnimatedPositioned(
      curve: Curves.fastLinearToSlowEaseIn,
      bottom: bottomPosition,
      duration: animationDuration,
      child: AnimatedOpacity(
        opacity: opacity,
        duration: animationDuration,
        curve: Curves.fastLinearToSlowEaseIn,
        child: SvgPicture.asset(
          Drawables.icMenuSelectedBullet,
          color: DefaultMenuItem.currentColor(isActive),
        ),
      ),
    );
  }
}
