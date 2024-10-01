import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

final GlobalKey<ScaffoldMessengerState> snackBarKey = GlobalKey<ScaffoldMessengerState>();
final GlobalKey<ScaffoldMessengerState> modeDemoSnackBarKey = GlobalKey<ScaffoldMessengerState>();

void showSnackBarWithSuccess(BuildContext context, String label, [VoidCallback? onActionTap]) {
  _showSnackBar(
    context: context,
    icon: AppIcons.check_circle_rounded,
    label: label,
    backgroundColor: AppColors.successLighten,
    textColor: AppColors.success,
    onActionTap: onActionTap,
  );
}

void showSnackBarWithInformation(BuildContext context, String label) {
  _showSnackBar(
    context: context,
    icon: AppIcons.info_rounded,
    label: label,
    backgroundColor: AppColors.primaryLighten,
    textColor: AppColors.primary,
    onActionTap: null,
  );
}

void showSnackBarWithSystemError(BuildContext context, [String? label]) {
  _showSnackBar(
    context: context,
    icon: AppIcons.highlight_off,
    label: label ?? Strings.miscellaneousErrorRetry,
    backgroundColor: AppColors.disabled,
    textColor: Colors.white,
    onActionTap: null,
  );
}

void showSnackBarWithUserError(BuildContext context, String label) {
  _showSnackBar(
    context: context,
    icon: AppIcons.error_rounded,
    label: label,
    backgroundColor: AppColors.warningLighten,
    textColor: AppColors.warning,
    onActionTap: null,
  );
}

void _showSnackBar({
  required BuildContext context,
  required IconData icon,
  required String label,
  required Color backgroundColor,
  required Color textColor,
  required VoidCallback? onActionTap,
}) {
  clearAllSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      // a11y : 11.1 - bloquant: Le message de succès disparaît automatiquement après quelques secondes
      duration: Duration(minutes: 1),
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor,
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: textColor),
          SizedBox(width: Margins.spacing_s),
          Expanded(
            child: Text(label, style: TextStyles.textSMedium(color: textColor)),
          ),
          SizedBox(width: Margins.spacing_s),
          if (onActionTap == null)
            Focus(
              child: GestureDetector(
                child: Icon(
                  AppIcons.close_rounded,
                  color: textColor,
                  semanticLabel: Strings.closeDialog,
                ),
                onTap: () => clearAllSnackBars(),
              ),
            ),
        ],
      ),
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
