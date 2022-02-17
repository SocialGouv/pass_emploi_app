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

  static final List<String> _widgetAlreadyBuildForLabelList = [];

  @override
  Widget build(BuildContext context) {
    final alreadyBuilt = _widgetAlreadyBuildForLabelList.contains(label);
    if (!alreadyBuilt) _widgetAlreadyBuildForLabelList.add(label);
    Color color = AppColors.grey800;
    if (isActive) color = AppColors.secondary;
    return Stack(
      alignment: Alignment.center,
      clipBehavior: Clip.none,
      children: [
        Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  child: SvgPicture.asset(drawableRes, color: color),
                  height: Dimens.bottomNavigationBarItemHeight,
                ),
                if (withBadge) Positioned(child: SvgPicture.asset(Drawables.icBadge), top: -1, left: 12),
              ],
            ),
            SizedBox(height: Margins.spacing_s),
            Text(label, style: TextStyles.textMenuRegular(color)),
          ],
        ),
        TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: _beginTweenValue(), end: _endTweenValue()),
          // When the widget is built for the first time, we don't want any animation => duration is set to 0.
          duration: Duration(milliseconds: alreadyBuilt ? 800 : 0),
          curve: Curves.fastLinearToSlowEaseIn,
          builder: (context, value, child) {
            return Positioned(
                bottom: value,
                child: Center(
                    child: SvgPicture.asset(
                  Drawables.icMenuSelectedBullet,
                  color: AppColors.secondary,
                )));
          },
        )
      ],
    );
  }

  double _beginTweenValue() => isActive ? -20 : -6;

  double _endTweenValue() => isActive ? -6 : -20;
}
