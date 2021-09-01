import 'package:flutter/material.dart';
import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class UserActionCard extends StatelessWidget {
  final UserAction action;
  final GestureTapCallback onTap;

  UserActionCard({required this.action, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
      child: InkWell(
        onTap: onTap,
        splashColor: AppColors.bluePurple,
        child: Padding(
          padding: const EdgeInsets.all(Margins.medium),
          child: Text(action.content, style: TextStyles.textSmRegular(color: AppColors.nightBlue)),
        ),
      ),
    );
  }
}
