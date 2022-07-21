import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';

class PrimaryRoundedBottomBackground extends StatelessWidget {
  const PrimaryRoundedBottomBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalHeight = MediaQuery.of(context).size.height;
    final totalWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        Container(color: Color(0xFFE5E5E5)),
        SizedBox(
          width: totalWidth,
          height: totalHeight / 2 + 48,
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
