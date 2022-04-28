import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';

final GlobalKey<ScaffoldMessengerState> snackbarKey = GlobalKey<ScaffoldMessengerState>();

void showSuccessfulSnackBar(BuildContext context, String label) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      padding: const EdgeInsets.only(left: 24, bottom: 14),
      backgroundColor: AppColors.secondaryLighten,
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: SvgPicture.asset(
              Drawables.icDoneCircle,
              color: AppColors.secondary,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 8, top: 14),
              child: Text(
                label,
                style: TextStyle(color: AppColors.secondary),
              ),
            ),
          ),
          InkWell(
            onTap: () => snackbarKey.currentState?.hideCurrentSnackBar(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 24, 16),
              child: SvgPicture.asset(
                Drawables.icClose,
                color: AppColors.secondary,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}


void showFailedSnackBar(BuildContext context, String label) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      padding: const EdgeInsets.only(left: 24, bottom: 14),
      backgroundColor: AppColors.warningLight,
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 14),
            child: SvgPicture.asset(
              Drawables.icImportant,
              color: AppColors.warning,
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 8, top: 14),
              child: Text(
                label,
                style: TextStyle(color: AppColors.warning),
              ),
            ),
          ),
          InkWell(
            onTap: () => snackbarKey.currentState?.hideCurrentSnackBar(),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 24, 16),
              child: SvgPicture.asset(
                Drawables.icClose,
                color: AppColors.warning,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

