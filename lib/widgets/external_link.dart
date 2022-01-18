import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

class ExternalLink extends StatelessWidget {
  final String label;
  final String url;

  const ExternalLink({
    Key? key,
    required this.label,
    required this.url,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => launch(url),
      splashColor: AppColors.primaryLighten,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: TextStyles.externalLink),
            SizedBox(
              width: 10,
            ),
            SvgPicture.asset(
              Drawables.icLaunch,
              color: AppColors.primary,
              width: 16,
            )
          ],
        ),
      ),
    );
  }
}
