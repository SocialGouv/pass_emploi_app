import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class CarouselButton extends StatelessWidget {
  final String label;
  final bool isActive;
  final VoidCallback onPressed;

  const CarouselButton({
    Key? key,
    required this.label,
    required this.isActive,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(isActive ? AppColors.primaryLighten : Colors.transparent),
        shape: MaterialStateProperty.all(StadiumBorder()),
        side: MaterialStateProperty.all(BorderSide(color: isActive ? AppColors.primary : AppColors.grey800, width: 1)),
      ),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
        child: Row(
          children: [
            if (isActive) ...[
              Icon(AppIcons.check_rounded, size: Dimens.icon_size_base),
              SizedBox(width: 8),
            ],
            Text(label, style: TextStyles.textSBold.copyWith(color: isActive ? AppColors.primary : AppColors.grey800)),
          ],
        ),
      ),
    );
  }
}
