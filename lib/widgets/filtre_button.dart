import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/font_sizes.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class FiltreButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final int? filtresCount;
  final bool primary;

  FiltreButton.primary({Key? key, this.onPressed, this.filtresCount, this.primary = true});

  FiltreButton.secondary({Key? key, this.onPressed, this.filtresCount, this.primary = false});

  @override
  Widget build(BuildContext context) => primary ? _buildAsPrimary() : _buildAsSecondary();

  Widget _buildAsPrimary() {
    return TextButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Colors.white),
        textStyle: MaterialStateProperty.all(TextStyles.textPrimaryButton),
        backgroundColor: MaterialStateProperty.resolveWith<Color?>(
          (states) => states.contains(MaterialState.disabled) ? AppColors.primaryWithAlpha50 : AppColors.primary,
        ),
        elevation: MaterialStateProperty.all(10),
        alignment: Alignment.center,
        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(200)))),
        overlayColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.pressed) ? AppColors.primaryDarken : null,
        ),
      ),
      onPressed: onPressed,
      child: Padding(padding: EdgeInsets.fromLTRB(12, 6, 0, 6), child: _buildRow()),
    );
  }

  Widget _buildAsSecondary() {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        shape: StadiumBorder(),
        backgroundColor: Colors.white,
        side: BorderSide(color: AppColors.primary, width: 2),
      ),
      onPressed: onPressed,
      child: Padding(padding: EdgeInsets.fromLTRB(12, 6, 0, 6), child: _buildRow()),
    );
  }

  Row _buildRow() {
    final accentColor = primary ? Colors.white : AppColors.primary;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          Strings.filtrer,
          style: TextStyles.textPrimaryButton.copyWith(fontSize: FontSizes.medium, color: accentColor),
        ),
        SizedBox(width: Margins.spacing_base),
        SvgPicture.asset(Drawables.icFilter, height: 18, width: 18, color: accentColor),
        SizedBox(width: Margins.spacing_base),
        if (filtresCount != null)
          Padding(
            padding: const EdgeInsets.only(right: Margins.spacing_s),
            child: Container(
              decoration: BoxDecoration(shape: BoxShape.circle, color: accentColor),
              width: Margins.spacing_m,
              height: Margins.spacing_m,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(
                filtresCount!.toString(),
                style: TextStyles.textSBoldWithColor(primary ? Colors.black : Colors.white),
              ),
            ),
          ),
      ],
    );
  }
}
