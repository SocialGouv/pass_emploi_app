import 'package:flutter/material.dart';
import 'package:pass_emploi_app/presentation/user_action_view_model.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class UserActionCard extends StatelessWidget {
  final UserActionViewModel action;
  final GestureTapCallback onTap;

  UserActionCard({required this.action, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.bluePurple,
        child: Padding(
          padding: const EdgeInsets.all(Margins.medium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(action.content, style: TextStyles.textSmRegular(color: AppColors.nightBlue)),
              if (action.withComment)
                Padding(
                  padding: const EdgeInsets.only(top: 4, bottom: 4),
                  child: Text(action.comment, style: TextStyles.textXsRegular(color: AppColors.nightBlue)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
