import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/pages/choix_organisme_explaination_page.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/font_sizes.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/launcher_utils.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/primary_rounded_bottom_background.dart';

class ChoixOrganismePage extends StatelessWidget {
  static const noOrganismeLink = "https://www.1jeune1solution.gouv.fr/contrat-engagement-jeune";

  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => ChoixOrganismePage());
  }

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.choixOrganisme,
      child: Scaffold(
        body: Stack(
          children: [
            PrimaryRoundedBottomBackground(),
            SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _backButton(context),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(Margins.spacing_m, Margins.spacing_m, Margins.spacing_m, 0),
                            child: DecoratedBox(
                              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                              child: Padding(
                                padding: const EdgeInsets.all(Margins.spacing_m),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      Strings.interestedInCej,
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontFamily: 'Marianne',
                                        fontSize: FontSizes.semi,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(height: Margins.spacing_xl),
                                    Text(
                                      Strings.whichOrganisme,
                                      style: TextStyles.textMRegular,
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: Margins.spacing_xl),
                                    PrimaryActionButton(
                                      label: Strings.loginPoleEmploi,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          ChoixOrganismeExplainationPage.materialPageRoute(isPoleEmploi: true),
                                        );
                                      },
                                    ),
                                    SizedBox(height: Margins.spacing_l),
                                    PrimaryActionButton(
                                      label: Strings.loginMissionLocale,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          ChoixOrganismeExplainationPage.materialPageRoute(isPoleEmploi: false),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: Margins.spacing_s),
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                PassEmploiMatomoTracker.instance.trackOutlink(noOrganismeLink);
                                launchExternalUrl(noOrganismeLink);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(Margins.spacing_s),
                                child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: Strings.noOrganisme,
                                        style:
                                            TextStyles.textBaseRegular.copyWith(decoration: TextDecoration.underline),
                                      ),
                                      WidgetSpan(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.symmetric(vertical: 2, horizontal: Margins.spacing_xs),
                                          child:
                                              SvgPicture.asset(Drawables.icRedirection, color: AppColors.contentColor),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _backButton(BuildContext context) {
    return IconButton(
      icon: SvgPicture.asset(
        Drawables.icChevronLeft,
        color: Colors.white,
        height: Margins.spacing_xl,
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
  }
}
