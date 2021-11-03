import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class UnselectedMenuItem extends StatelessWidget {
  final String drawableRes;
  final String label;
  final Color color;

  const UnselectedMenuItem({
    required this.drawableRes,
    required this.label,
    this.color = AppColors.bluePurple,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(child: SvgPicture.asset(drawableRes, color: color), height: Dimens.bottomNavigationBarItemHeight),
        SizedBox(height: 6.0),
        Text(label, style: TextStyles.textMenuRegular(color)),
      ],
    );
  }
}
