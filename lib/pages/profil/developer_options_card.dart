import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pass_emploi_app/pages/profil/matomo_logging_page.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/cards/profil_card.dart';

class DeveloperOptionsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: Margins.spacing_m),
      child: ProfilCard(
        padding: EdgeInsets.zero,
        child: InkWell(
          onTap: () => _showMatomoPage(context),
          child: Padding(
            padding: const EdgeInsets.all(Margins.spacing_base),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      child: Text(Strings.developerOptionMatomo, style: TextStyles.textBaseRegular),
                    ),
                    SizedBox(width: Margins.spacing_s),
                    SvgPicture.asset(Drawables.icChevronRight, color: AppColors.contentColor),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMatomoPage(BuildContext context) {
    // ignore: ban-name
    Navigator.push(context, MatomoLoggingPage.materialPageRoute());
  }
}
