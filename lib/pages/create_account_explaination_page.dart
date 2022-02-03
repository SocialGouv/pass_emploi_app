import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/onboarding_background.dart';
import 'package:pass_emploi_app/widgets/secondary_button.dart';

class CreateAccountExplainationPage extends TraceableStatelessWidget {
  final bool isPoleEmploi;

  const CreateAccountExplainationPage(this.isPoleEmploi)
      : super(
          name: isPoleEmploi ? AnalyticsScreenNames.choixOrganismePE : AnalyticsScreenNames.choixOrganismeMilo,
        );

  static MaterialPageRoute materialPageRoute({required bool isPoleEmploi}) {
    return MaterialPageRoute(builder: (context) => CreateAccountExplainationPage(isPoleEmploi));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          OnboardingBackground(),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
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
                          SvgPicture.asset(Drawables.conversation),
                          Text(
                            "Prenez rendez-vous avec votre conseiller Pôle emploi qui procédera à la création de votre compte.",
                            style: TextStyles.textMRegular,
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Text(
                  "Vous avez un compte pass emploi ?",
                  style: TextStyles.textBaseRegular,
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.all(Margins.spacing_m),
                  child: SecondaryButton(label: "Se connecter", onPressed: () {}),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
