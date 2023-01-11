import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';

class NotUpToDateMessage extends StatelessWidget {
  final String message;
  final void Function() onRefresh;
  const NotUpToDateMessage({super.key, required this.message, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    const contentColor = Colors.white;
    return Container(
      padding: EdgeInsets.all(Margins.spacing_base),
      decoration: BoxDecoration(
        color: AppColors.bluePurple,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info, color: contentColor),
              SizedBox(width: Margins.spacing_base),
              Expanded(child: Text(message, style: TextStyles.textBaseRegular.copyWith(color: contentColor))),
            ],
          ),
          SizedBox(height: Margins.spacing_base),
          SizedBox(
            width: double.infinity,
            child: PrimaryActionButton(
              label: Strings.reloadPage,
              onPressed: onRefresh,
              drawableRes: Drawables.icRefresh,
              backgroundColor: Colors.white,
              textColor: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
