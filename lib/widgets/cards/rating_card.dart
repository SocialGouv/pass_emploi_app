import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class RatingCard extends StatelessWidget {
  final String emoji;
  final String description;
  final Function() onClick;

  RatingCard({required this.emoji, required this.description, required this.onClick});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: description,
      child: InkWell(
        onTap: onClick,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(emoji, style: TextStyle(fontSize: 32)),
              Padding(
                padding: const EdgeInsets.only(right: 80),
                child: Text(description, style: TextStyles.textSRegular()),
              ),
              Icon(
                AppIcons.chevron_right_rounded,
                semanticLabel: Strings.openInNewTab,
                color: AppColors.contentColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
