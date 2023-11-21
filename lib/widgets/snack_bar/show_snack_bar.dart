import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

final GlobalKey<ScaffoldMessengerState> snackBarKey = GlobalKey<ScaffoldMessengerState>();
final GlobalKey<ScaffoldMessengerState> modeDemoSnackBarKey = GlobalKey<ScaffoldMessengerState>();

void showSuccessfulSnackBar(BuildContext context, String label, [VoidCallback? onSeeDetailTap]) {
  _showSnackBar(context, label, onSeeDetailTap, success: true);
}

void showFailedSnackBar(BuildContext context, String label, [VoidCallback? onSeeDetailTap]) {
  _showSnackBar(context, label, onSeeDetailTap, success: false);
}

void showSnackBarWithSuccess(BuildContext context, String label, [VoidCallback? onActionTap]) {
  _showSnackBarV2(
    context: context,
    label: label,
    backgroundColor: AppColors.secondaryLighten,
    textColor: AppColors.secondary,
    onActionTap: onActionTap,
  );
}

void showSnackBarWithInformation(BuildContext context, String label) {
  _showSnackBarV2(
    context: context,
    label: label,
    backgroundColor: AppColors.primaryLighten,
    textColor: AppColors.primary,
    onActionTap: null,
  );
}

void showSnackBarWithSystemError(BuildContext context, String label) {
  _showSnackBarV2(
    context: context,
    label: label,
    backgroundColor: AppColors.disabled,
    textColor: Colors.white,
    onActionTap: null,
  );
}

void showSnackBarWithUserError(BuildContext context, String label) {
  _showSnackBarV2(
    context: context,
    label: label,
    backgroundColor: AppColors.warningLighten,
    textColor: AppColors.warning,
    onActionTap: null,
  );
}

void _showSnackBarV2({
  required BuildContext context,
  required String label,
  required Color backgroundColor,
  required Color textColor,
  required VoidCallback? onActionTap,
}) {
  clearAllSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(seconds: 5),
      backgroundColor: backgroundColor,
      content: Text(label, style: TextStyles.textSRegular(color: textColor)),
      action: onActionTap != null
          ? SnackBarAction(
              label: Strings.consulter,
              textColor: textColor,
              onPressed: () {
                clearAllSnackBars();
                onActionTap.call();
              },
            )
          : null,
    ),
  );
}

void _showSnackBar(BuildContext context, String label, VoidCallback? onSeeDetailTap, {required bool success}) {
  clearAllSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      padding: EdgeInsets.symmetric(
        horizontal: Margins.spacing_base,
        vertical: onSeeDetailTap != null ? Margins.spacing_s : Margins.spacing_base,
      ),
      duration: Duration(seconds: 5),
      backgroundColor: success ? AppColors.secondaryLighten : AppColors.warningLighten,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(
                success ? AppIcons.check_circle_rounded : AppIcons.error_rounded,
                color: success ? AppColors.secondary : AppColors.warning,
              ),
              SizedBox(width: Margins.spacing_s),
              Expanded(child: Text(label, style: TextStyle(color: success ? AppColors.secondary : AppColors.warning))),
              SizedBox(width: Margins.spacing_s),
              SizedBox(
                height: 30,
                child: IconButton(
                  onPressed: () => clearAllSnackBars(),
                  icon: Icon(
                    Icons.close_rounded,
                    size: 24,
                    color: success ? AppColors.secondary : AppColors.warning,
                  ),
                ),
              )
            ],
          ),
          if (onSeeDetailTap != null)
            SizedBox(
              height: 30,
              child: TextButton(
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                onPressed: () {
                  clearAllSnackBars();
                  onSeeDetailTap();
                },
                child: Text(Strings.seeDetail, style: TextStyles.textSRegular(color: AppColors.secondary)),
              ),
            ),
        ],
      ),
    ),
  );
}

void clearAllSnackBars() {
  snackBarKey.currentState?.clearSnackBars();
  modeDemoSnackBarKey.currentState?.clearSnackBars();
}
