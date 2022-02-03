import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/pages/create_account_explaination_page.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/font_sizes.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/onboarding_background.dart';
import 'package:pass_emploi_app/widgets/primary_action_button.dart';

class CreateAccountPage extends TraceableStatelessWidget {
  const CreateAccountPage() : super(name: AnalyticsScreenNames.choixOrganisme);

  static MaterialPageRoute materialPageRoute() {
    return MaterialPageRoute(builder: (context) => CreateAccountPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          OnboardingBackground(),
          SafeArea(
            child: Column(
              children: [
                SizedBox(height: Dimens.appBarHeight),
                Padding(
                  padding: const EdgeInsets.all(Margins.spacing_m),
                  child: Container(
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                    child: Padding(
                      padding: const EdgeInsets.all(Margins.spacing_m),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "Vous êtes intéressé et vous pensez être éligible au Contrat Engagement Jeune ?",
                            style: TextStyle(
                              color: AppColors.primary,
                              fontFamily: 'Marianne',
                              fontSize: FontSizes.semi,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: Margins.spacing_xl),
                          Text(
                            "De quel organisme dépend votre conseiller principal ?",
                            style: TextStyles.textMRegular,
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: Margins.spacing_xl),
                          PrimaryActionButton(
                            label: "Pôle emploi",
                            onPressed: () {
                              Navigator.push(
                                  context, CreateAccountExplainationPage.materialPageRoute(isPoleEmploi: true));
                            },
                          ),
                          SizedBox(height: Margins.spacing_l),
                          PrimaryActionButton(
                            label: "Mission Locale",
                            onPressed: () {
                              Navigator.push(
                                  context, CreateAccountExplainationPage.materialPageRoute(isPoleEmploi: false));
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
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.all(Margins.spacing_s),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Je ne suis inscrit à aucun de ces organismes",
                              style: TextStyles.textBaseRegular.copyWith(decoration: TextDecoration.underline),
                            ),
                            WidgetSpan(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: Margins.spacing_xs),
                                child: SvgPicture.asset(Drawables.icRedirection, color: AppColors.contentColor),
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
          )
        ],
      ),
    );
  }
}
