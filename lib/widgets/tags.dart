import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/font_sizes.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class DataTag extends StatelessWidget {

  final String? drawableRes;
  final String label;

  const DataTag({
    Key? key,
    this.drawableRes,
    required this.label,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.primaryLighten,
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (drawableRes != null) Padding(padding: const EdgeInsets.only(right: 6), child: SvgPicture.asset(drawableRes!)),
            Flexible(child: Text(label, style: TextStyle(
              color: AppColors.primary,
              fontFamily: 'Marianne',
              fontSize: FontSizes.normal,
              fontWeight: FontWeight.w400,
            ))),
          ],
        ),
      ),
    );
  }

}

Widget lightBlueTag({required String label, SvgPicture? icon}) {
  return Container(
    decoration: BoxDecoration(
      color: AppColors.lightBlue,
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Padding(padding: const EdgeInsets.only(right: 6), child: icon),
          Flexible(child: Text(label, style: TextStyles.textSmRegular())),
        ],
      ),
    ),
  );
}
