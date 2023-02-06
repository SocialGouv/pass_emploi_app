import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

final GlobalKey<ScaffoldMessengerState> snackbarKey = GlobalKey<ScaffoldMessengerState>();

void showSuccessfulSnackBar(BuildContext context, String label, [VoidCallback? onSeeDetailTap]) {
  _showSnackBar(context, label, onSeeDetailTap, success: true);
}

void showFailedSnackBar(BuildContext context, String label, [VoidCallback? onSeeDetailTap]) {
  _showSnackBar(context, label, onSeeDetailTap, success: false);
}

void _showSnackBar(BuildContext context, String label, VoidCallback? onSeeDetailTap, {required bool success}) {
  _clearAllSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      padding: EdgeInsets.symmetric(
        horizontal: Margins.spacing_base,
        vertical: onSeeDetailTap != null ? Margins.spacing_s : Margins.spacing_base,
      ),
      duration: Duration(days: 365),
      backgroundColor: success ? AppColors.secondaryLighten : AppColors.warningLighten,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              SvgPicture.asset(
                success ? Drawables.icDoneCircle : Drawables.icImportant,
                color: success ? AppColors.secondary : AppColors.warning,
              ),
              SizedBox(width: Margins.spacing_s),
              Expanded(child: Text(label, style: TextStyle(color: success ? AppColors.secondary : AppColors.warning))),
              SizedBox(width: Margins.spacing_s),
              SizedBox(
                height: 30,
                child: IconButton(
                  onPressed: () => _clearAllSnackBars(),
                  icon: OverflowBox(
                    maxHeight: 50,
                    maxWidth: 50,
                    child: Icon(
                      Icons.close_rounded,
                      size: 24,
                      color: success ? AppColors.secondary : AppColors.warning,
                    ),
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
                  _clearAllSnackBars();
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

void _clearAllSnackBars() => snackbarKey.currentState?.clearSnackBars();
