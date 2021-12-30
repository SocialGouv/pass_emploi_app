import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
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
        foregroundColor: MaterialStateProperty.all(Colors.white),
        backgroundColor: MaterialStateProperty.all(isActive ? AppColors.nightBlue : Colors.transparent),
        shape: MaterialStateProperty.all(StadiumBorder()),
        side: MaterialStateProperty.all(BorderSide(color: AppColors.nightBlue, width: 1)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Text(label, style: TextStyles.textSmMedium(color: isActive ? Colors.white : AppColors.nightBlue)),
      ),
      onPressed: onPressed,
    );
  }
}
