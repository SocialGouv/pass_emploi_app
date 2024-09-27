import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class RatingCard extends StatelessWidget {
  final String emoji;
  final String description;
  final Function() onClick;

  RatingCard({required this.emoji, required this.description, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: Tooltip(
        message: description,
        excludeFromSemantics: true,
        child: InkWell(
          onTap: onClick,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(emoji, style: TextStyle(fontSize: 32)),
                SizedBox(width: Margins.spacing_base),
                Expanded(
                  child: Text(description, style: TextStyles.textSRegular()),
                ),
                Icon(
                  AppIcons.chevron_right_rounded,
                  color: AppColors.contentColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
