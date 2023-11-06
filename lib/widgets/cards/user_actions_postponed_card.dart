import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';

class UserActionsPostponedCard extends StatelessWidget {
  final int userActionsPostponedCount;

  const UserActionsPostponedCard({super.key, required this.userActionsPostponedCount});

  @override
  Widget build(BuildContext context) {
    final message = userActionsPostponedCount > 1
        ? Strings.pendingActionCreationPlural(userActionsPostponedCount)
        : Strings.pendingActionCreationSingular;
    return CardContainer(
      backgroundColor: AppColors.disabled,
      child: Row(
        children: [
          Icon(AppIcons.error_rounded, color: Colors.white),
          SizedBox(width: Margins.spacing_s),
          Text(message, style: TextStyles.textSRegularWithColor(Colors.white)),
        ],
      ),
    );
  }
}
