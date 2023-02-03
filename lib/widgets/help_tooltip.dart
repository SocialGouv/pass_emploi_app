import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class HelpTooltip extends StatelessWidget {
  final String message;
  final String iconRes;

  const HelpTooltip({
    Key? key,
    required this.message,
    required this.iconRes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: message,
      triggerMode: TooltipTriggerMode.tap,
      showDuration: Duration(seconds: 3),
      textStyle: TextStyles.textSRegular(),
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        border: Border.all(
          color: AppColors.primary,
        ),
      ),
      child: SvgPicture.asset(
        iconRes,
        color: AppColors.primary,
      ),
    );
  }
}
