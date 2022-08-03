import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class RatingCard extends StatelessWidget {
  final String emoji;
  final String description;
  final Function() onClick;

  RatingCard({required this.emoji, required this.description, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
      child: InkWell(
        onTap: onClick,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(emoji),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 80, 0),
              child: Text(description, style: TextStyles.textSRegular()),
            ),
            SvgPicture.asset(Drawables.icChevronRight, color: AppColors.contentColor),
          ],
        ),
      ),
    );
  }
}
