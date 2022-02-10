import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../ui/app_colors.dart';
import '../../ui/drawables.dart';

final GlobalKey<ScaffoldMessengerState> snackbarKey = GlobalKey<ScaffoldMessengerState>();

void showSuccessfulSnackBar(BuildContext context, String label) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: AppColors.secondaryLighten,
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          SvgPicture.asset(
            Drawables.icDone,
            color: AppColors.secondary,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                label,
                style: TextStyle(color: AppColors.secondary),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => snackbarKey.currentState?.hideCurrentSnackBar(),
            child: SvgPicture.asset(
              Drawables.icClose,
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    ),
  );
}

void showSnackBarError(BuildContext context, String label) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: AppColors.warningLight,
      content: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          SvgPicture.asset(
            Drawables.icImportant,
            color: AppColors.warning,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                label,
                style: TextStyle(color: AppColors.warning),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => snackbarKey.currentState?.hideCurrentSnackBar(),
            child: SvgPicture.asset(
              Drawables.icClose,
              color: AppColors.warning,
            ),
          ),
        ],
      ),
    ),
  );
}