import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/external_links.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/ressource_formation_assets.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/launcher_utils.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class RessourceFormationPage extends StatelessWidget {
  const RessourceFormationPage({super.key});

  static Route<void> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => const RessourceFormationPage());
  }

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.ressourceFormation,
      child: Scaffold(
        appBar: SecondaryAppBar(title: RessourceFormationAssets.text_0),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(Margins.spacing_base),
          child: PrimaryActionButton(
            label: RessourceFormationAssets.text_7,
            underlined: true,
            widthPadding: Margins.spacing_xl,
            icon: AppIcons.open_in_new_rounded,
            semanticsRoleLink: true,
            onPressed: () {
              PassEmploiMatomoTracker.instance.trackOutlink(ExternalLinks.ressourceFormationLink);
              launchExternalUrl(ExternalLinks.ressourceFormationLink);
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Margins.spacing_base),
            child: Column(
              children: [
                _InformationCard(
                  title: RessourceFormationAssets.text_1,
                  imagePath: RessourceFormationAssets.illustration_0,
                  spans: [
                    TextSpan(
                      text: RessourceFormationAssets.text_2,
                      style: TextStyles.textBaseRegular,
                    ),
                  ],
                ),
                SizedBox(height: Margins.spacing_m),
                _VerbatimCard(),
                SizedBox(height: Margins.spacing_m),
                _InformationCard(
                  title: RessourceFormationAssets.text_5,
                  imagePath: RessourceFormationAssets.illustration_2,
                  spans: [
                    TextSpan(
                      text: RessourceFormationAssets.text_6,
                      style: TextStyles.textBaseRegular,
                    ),
                  ],
                ),
                SizedBox(height: Margins.spacing_xx_huge),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _VerbatimCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CardContainer(
      backgroundColor: AppColors.disabled,
      child: Column(
        children: [
          SizedBox(height: Margins.spacing_s),
          Image.asset(RessourceFormationAssets.illustration_1, width: 64, excludeFromSemantics: true),
          SizedBox(height: Margins.spacing_base),
          Text(
            RessourceFormationAssets.text_3,
            style: TextStyles.textMRegular.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Margins.spacing_s),
          Text(
            RessourceFormationAssets.text_4,
            style: TextStyles.textSRegular().copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Margins.spacing_s),
        ],
      ),
    );
  }
}

class _InformationCard extends StatelessWidget {
  final String imagePath;
  final String title;
  final List<InlineSpan> spans;

  _InformationCard({
    required this.imagePath,
    required this.title,
    required this.spans,
  });

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: double.infinity,
            child: Image.asset(
              imagePath,
              fit: BoxFit.fitWidth,
              excludeFromSemantics: true,
            ),
          ),
          SizedBox(height: Margins.spacing_m),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
            child: Text(title, style: TextStyles.textBaseBold),
          ),
          SizedBox(height: Margins.spacing_s),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
            child: Text.rich(TextSpan(children: spans)),
          ),
          SizedBox(height: Margins.spacing_m),
        ],
      ),
    );
  }
}
