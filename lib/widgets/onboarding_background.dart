import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';

class OnboardingBackground extends StatelessWidget {
  const OnboardingBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalHeight = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Container(color: Color(0xFFE5E5E5)),
        SizedBox(
          height: totalHeight / 2 + Dimens.appBarHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(200), bottomRight: Radius.circular(200)),
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
