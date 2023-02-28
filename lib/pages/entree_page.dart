import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/pages/cej_information_page.dart';
import 'package:pass_emploi_app/pages/login_page.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/shadows.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/launcher_utils.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/entree_biseau_background.dart';
import 'package:pass_emploi_app/widgets/hidden_menu.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';

class EntreePage extends StatelessWidget {
  static const minimum_height_to_see_jeune_face = 656;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return Tracker(
      tracking: AnalyticsScreenNames.entree,
      child: Scaffold(
        body: Stack(
          children: [
            const EntreeBiseauBackground(),
            SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 16),
                  SvgPicture.asset(Drawables.unJeuneUneSolutionIllustration, width: screenWidth * 0.25),
                  SizedBox(height: 32),
                  HiddenMenuGesture(
                    child: SvgPicture.asset(Drawables.cejAppLogo, width: screenWidth * 0.6),
                  ),
                  SizedBox(height: 16),
                  Expanded(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: screenHeight >= minimum_height_to_see_jeune_face
                          ? Image.asset(Drawables.jeuneEntree, alignment: Alignment.bottomCenter)
                          : Container(),
                    ),
                  ),
                ],
              ),
            ),
            SafeArea(
              bottom: false,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(Margins.spacing_m),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [Shadows.radius_base],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: Margins.spacing_base,
                        right: Margins.spacing_base,
                        top: Margins.spacing_base,
                      ),
                      child: _buttonCard(context),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column _buttonCard(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        PrimaryActionButton(
          label: Strings.loginAction,
          onPressed: () => Navigator.push(context, LoginPage.materialPageRoute()),
        ),
        SizedBox(height: Margins.spacing_base),
        SecondaryButton(
          label: Strings.askAccount,
          onPressed: () => Navigator.push(context, CejInformationPage.materialPageRoute()),
        ),
        SepLine(Margins.spacing_base, 0),
        Theme(
          data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: EdgeInsets.zero,
            title: Text(Strings.legalInformation, style: TextStyles.textBaseRegular),
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            expandedAlignment: Alignment.topLeft,
            children: [
              SizedBox(height: Margins.spacing_s),
              Link(Strings.legalNoticeLabel, Strings.legalNoticeUrl),
              SizedBox(height: Margins.spacing_m),
              Link(Strings.privacyPolicyLabel, Strings.privacyPolicyUrl),
              SizedBox(height: Margins.spacing_m),
              Link(Strings.termsOfServiceLabel, Strings.termsOfServiceUrl),
              SizedBox(height: Margins.spacing_m),
              Link(Strings.accessibilityLevelLabel, Strings.accessibilityUrl),
              SizedBox(height: Margins.spacing_m),
            ],
          ),
        )
      ],
    );
  }
}

class Link extends StatelessWidget {
  final String label;
  final String link;

  const Link(this.label, this.link, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          PassEmploiMatomoTracker.instance.trackOutlink(link);
          launchExternalUrl(link);
        },
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.end,
          children: [
            Text(label, style: TextStyles.internalLink),
            SizedBox(width: Margins.spacing_s),
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Icon(AppIcons.open_in_new_rounded, color: AppColors.primary),
            )
          ],
        ),
      ),
    );
  }
}
