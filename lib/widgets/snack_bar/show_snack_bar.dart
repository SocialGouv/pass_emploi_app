import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

final GlobalKey<ScaffoldMessengerState> snackBarKey = GlobalKey<ScaffoldMessengerState>();
final GlobalKey<ScaffoldMessengerState> modeDemoSnackBarKey = GlobalKey<ScaffoldMessengerState>();

void showSnackBarWithSuccess(BuildContext context, String label, [VoidCallback? onActionTap]) {
  _showSnackBar(
    context: context,
    label: label,
    backgroundColor: AppColors.successLighten,
    textColor: AppColors.success,
    onActionTap: onActionTap,
  );
}

void showSnackBarWithInformation(BuildContext context, String label) {
  _showSnackBar(
    context: context,
    label: label,
    backgroundColor: AppColors.primaryLighten,
    textColor: AppColors.primary,
    onActionTap: null,
  );
}

void showSnackBarWithSystemError(BuildContext context, [String? label]) {
  _showSnackBar(
    context: context,
    label: label ?? Strings.miscellaneousErrorRetry,
    backgroundColor: AppColors.disabled,
    textColor: Colors.white,
    onActionTap: null,
  );
}

void showSnackBarWithUserError(BuildContext context, String label) {
  _showSnackBar(
    context: context,
    label: label,
    backgroundColor: AppColors.warningLighten,
    textColor: AppColors.warning,
    onActionTap: null,
  );
}

void _showSnackBar({
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

void clearAllSnackBars() {
  snackBarKey.currentState?.clearSnackBars();
  modeDemoSnackBarKey.currentState?.clearSnackBars();
}
