import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
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
      padding: const EdgeInsets.symmetric(vertical: Margins.spacing_s),
      duration: Duration(days: 365),
      backgroundColor: success ? AppColors.secondaryLighten : AppColors.warningLight,
      // Column is required to make stack height fit to children
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // required to keep close button height without impacting padding of See Detail button
          Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      Margins.spacing_base,
                      12, // required to center text and close icon
                      Margins.spacing_base,
                      0,
                    ),
                    child: Row(
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
                        SizedBox(width: kMinInteractiveDimension), // Take the width of the close icon button,
                      ],
                    ),
                  ),
                  if (onSeeDetailTap != null)
                    Row(
                      children: [
                        SizedBox(width: Margins.spacing_s),
                        InkWell(
                          borderRadius: BorderRadius.circular(Dimens.radius_l),
                          onTap: () {
                            _clearAllSnackBars();
                            onSeeDetailTap();
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(Margins.spacing_s),
                            child: Text(
                              Strings.seeDetail,
                              style: TextStyles.textSRegular(color: AppColors.secondary),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  onPressed: () => _clearAllSnackBars(),
                  icon: SvgPicture.asset(
                    Drawables.icClose,
                    color: success ? AppColors.secondary : AppColors.warning,
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    ),
  );
}

void _clearAllSnackBars() => snackbarKey.currentState?.clearSnackBars();
