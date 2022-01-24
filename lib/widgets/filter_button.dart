import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/font_sizes.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class FilterButton extends StatelessWidget {

  final Color backgroundColor;
  final Color disabledBackgroundColor;
  final Color textColor;
  final Color? rippleColor;
  final String? drawableRes;
  final VoidCallback? onPressed;
  final int? filtresCount;

  FilterButton({
    Key? key,
    this.drawableRes,
    this.backgroundColor = AppColors.primary,
    this.disabledBackgroundColor = AppColors.primaryWithAlpha50,
    this.textColor = Colors.white,
    this.rippleColor = AppColors.primaryDarken,
    this.onPressed,
    this.filtresCount,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(textColor),
        textStyle: MaterialStateProperty.all(TextStyles.textPrimaryButton),
        backgroundColor: MaterialStateProperty.resolveWith<Color?>((Set<MaterialState> states) {
          return states.contains(MaterialState.disabled) ? disabledBackgroundColor : backgroundColor;
        }),
        elevation: MaterialStateProperty.all(10),
        alignment: Alignment.center,
        shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(200))
        )),
        overlayColor: MaterialStateProperty.resolveWith(
              (states) {
            return states.contains(MaterialState.pressed) ? rippleColor : null;
          },
        ),
      ),
      onPressed: onPressed,
      child: Padding(padding: EdgeInsets.fromLTRB(12, 6, 0, 6), child: _buildRow()),
    );
  }

  Row _buildRow() {
    return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
        Text(
          Strings.filtrer,
          style: TextStyles.textPrimaryButton.copyWith(fontSize: FontSizes.medium),
        ),
        SizedBox(width: Margins.spacing_base),
        SvgPicture.asset(
          Drawables.icFilter,
          height: 18,
          width: 18,
        ),
        SizedBox(width: Margins.spacing_base),
        if (filtresCount != null)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Container(
              decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.white),
              width: Margins.spacing_m,
              height: Margins.spacing_m,
              alignment: Alignment.center,
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(
                filtresCount!.toString(),
                style: TextStyles.textSBoldWithColor(Colors.black),
              ),
            ),
        ),
    ],
  );
  }
}
