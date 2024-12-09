import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/a11y/auto_focus.dart';

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
      duration: Duration(minutes: 60),
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor,
      content: AutoFocusA11y(
        // a11y : 11.1 - bloquant: Pour s'assurer que le focus reste sur la snackbar même en cas de changement d'écran
        duration: Duration(milliseconds: 500),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: textColor),
            SizedBox(width: Margins.spacing_s),
            Expanded(
              child: Text(label, style: TextStyles.textSMedium(color: textColor)),
            ),
            SizedBox(width: Margins.spacing_s),
            if (onActionTap == null)
              IconButton(
                icon: Icon(
                  AppIcons.close_rounded,
                  color: textColor,
                  semanticLabel: Strings.closeInformationMessage,
                ),
                onPressed: () => clearAllSnackBars(),
                alignment: Alignment.topRight,
                padding: EdgeInsets.zero,
              ),
          ],
        ),
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
