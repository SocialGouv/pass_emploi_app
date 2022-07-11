import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';

final GlobalKey<ScaffoldMessengerState> snackbarKey = GlobalKey<ScaffoldMessengerState>();

void showSuccessfulSnackBar(BuildContext context, String label) {
  _showSnackBar(context, label, success: true);
}

void showFailedSnackBar(BuildContext context, String label) {
  _showSnackBar(context, label, success: false);
}

void _showSnackBar(BuildContext context, String label, {required bool success}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      padding: const EdgeInsets.only(left: 24, bottom: 14),
      duration: Duration(days: 365),
      backgroundColor: success ? AppColors.secondaryLighten : AppColors.warningLight,
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: SvgPicture.asset(
              success ? Drawables.icDoneCircle : Drawables.icImportant,
              color: success ? AppColors.secondary : AppColors.warning,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 8, top: 14),
              child: Text(
                label,
                style: TextStyle(color: success ? AppColors.secondary : AppColors.warning),
              ),
            ),
          ),
          InkWell(
            onTap: () => snackbarKey.currentState?.hideCurrentSnackBar(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 24, 16),
              child: SvgPicture.asset(
                Drawables.icClose,
                color: success ? AppColors.secondary : AppColors.warning,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
