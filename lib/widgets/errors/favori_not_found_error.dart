import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';

class FavoriNotFoundError extends StatelessWidget {
  const FavoriNotFoundError({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        color: AppColors.warningLighten,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(
                Strings.offreNotFoundError,
                style: TextStyles.textSBoldWithColor(
                  AppColors.warning,
                ),
              ),
              SizedBox(height: 8),
              Text(
                Strings.offreNotFoundExplaination,
                style: TextStyles.textSmRegular(color: AppColors.warning),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
