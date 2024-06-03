import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class AlertMessage extends StatelessWidget {
  const AlertMessage({required this.message, this.onRetry, this.retryMessage});
  final String message;
  final String? retryMessage;
  final void Function()? onRetry;

  @override
  Widget build(BuildContext context) {
    const contentColor = AppColors.warning;
    return Container(
      padding: EdgeInsets.all(Margins.spacing_base),
      decoration: BoxDecoration(
        color: AppColors.warningLighten,
        borderRadius: BorderRadius.circular(Margins.spacing_s),
      ),
      child: Row(
        children: [
          Icon(AppIcons.error_rounded, color: contentColor),
          SizedBox(width: Margins.spacing_s),
          Expanded(child: Text(message, style: TextStyles.textSRegular(color: contentColor))),
          if (onRetry != null) ...[
            SizedBox(width: Margins.spacing_s),
            TextButton(
              onPressed: onRetry,
              child: Text(retryMessage ?? Strings.retry, style: TextStyles.textSBoldWithColor(contentColor)),
            ),
          ]
        ],
      ),
    );
  }
}
