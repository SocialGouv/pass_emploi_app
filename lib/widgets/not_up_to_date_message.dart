import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';

class NotUpToDateMessage extends StatelessWidget {
  final String message;
  final void Function()? onRefresh;
  final EdgeInsets? margin;

  const NotUpToDateMessage({super.key, required this.message, this.onRefresh, this.margin});

  @override
  Widget build(BuildContext context) {
    const contentColor = Colors.white;
    return Container(
      margin: margin,
      padding: EdgeInsets.all(Margins.spacing_base),
      color: AppColors.disabled,
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(AppIcons.event_repeat_rounded, color: contentColor),
              SizedBox(width: Margins.spacing_base),
              Expanded(child: Text(message, style: TextStyles.textXsRegular(color: contentColor))),
            ],
          ),
          if (onRefresh != null) ...[
            SizedBox(height: Margins.spacing_base),
            SizedBox(
              width: double.infinity,
              child: SecondaryButton(
                label: Strings.reloadPage,
                onPressed: onRefresh,
                icon: AppIcons.refresh_rounded,
                backgroundColor: Colors.white,
              ),
            ),
          ]
        ],
      ),
    );
  }
}
