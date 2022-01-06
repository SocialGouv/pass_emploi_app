import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class SecondaryButton extends StatelessWidget {
  final String label;
  final String? drawableRes;
  final VoidCallback? onPressed;

  const SecondaryButton({
    Key? key,
    required this.label,
    required this.onPressed,
    this.drawableRes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: double.infinity),
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          shape: StadiumBorder(),
          side: BorderSide(color: AppColors.nightBlue, width: 2),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (drawableRes != null)
                Padding(padding: const EdgeInsets.only(right: 12), child: SvgPicture.asset(drawableRes!)),
              Text(label, style: TextStyles.textSmMedium()),
            ],
          ),
        ),
      ),
    );
  }
}
