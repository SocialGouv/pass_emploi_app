import 'package:flutter/material.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/launcher_utils.dart';

class ExternalLink extends StatelessWidget {
  final String label;
  final String url;

  const ExternalLink({
    super.key,
    required this.label,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => launchExternalUrl(url),
      splashColor: AppColors.primaryLighten,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              AppIcons.open_in_new_rounded,
              color: AppColors.primary,
              size: Dimens.icon_size_base,
            ),
            SizedBox(
              width: Margins.spacing_s,
            ),
            Text(label, style: TextStyles.externalLink),
            Semantics(label: Strings.link),
          ],
        ),
      ),
    );
  }
}
