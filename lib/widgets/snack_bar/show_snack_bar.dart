import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';

final GlobalKey<ScaffoldMessengerState> snackbarKey = GlobalKey<ScaffoldMessengerState>();

void showSuccessfulSnackBar(BuildContext context, String label) {
  _showSnackBar(context, label, success: true);
}

void showFailedSnackBar(BuildContext context, String label) {
  _showSnackBar(context, label, success: false);
}

void _showSnackBar(BuildContext context, String label, {required bool success}) {
  _clearAllSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base, vertical: Margins.spacing_s),
      duration: Duration(days: 365),
      backgroundColor: success ? AppColors.secondaryLighten : AppColors.warningLight,
      content: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          SvgPicture.asset(
            success ? Drawables.icDoneCircle : Drawables.icImportant,
            color: success ? AppColors.secondary : AppColors.warning,
          ),
          SizedBox(width: Margins.spacing_s),
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: success ? AppColors.secondary : AppColors.warning),
            ),
          ),
          IconButton(
            onPressed: () => _clearAllSnackBars(),
            icon: SvgPicture.asset(
              Drawables.icClose,
              color: success ? AppColors.secondary : AppColors.warning,
            ),
          ),
        ],
      ),
    ),
  );
}

void _clearAllSnackBars() => snackbarKey.currentState?.clearSnackBars();
