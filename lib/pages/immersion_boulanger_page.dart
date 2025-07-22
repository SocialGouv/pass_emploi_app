import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/external_links.dart';
import 'package:pass_emploi_app/ui/immersion_boulanger_assets.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/launcher_utils.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class ImmersionBoulangerPage extends StatelessWidget {
  const ImmersionBoulangerPage({super.key});

  static Route<void> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => const ImmersionBoulangerPage());
  }

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.immersionBoulanger,
      child: Scaffold(
        appBar: SecondaryAppBar(title: ImmersionBoulangerAssets.text_0),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(Margins.spacing_base),
          child: PrimaryActionButton(
            label: ImmersionBoulangerAssets.textButton,
            underlined: true,
            widthPadding: Margins.spacing_xl,
            icon: AppIcons.open_in_new_rounded,
            semanticsRoleLink: true,
            onPressed: () {
              PassEmploiMatomoTracker.instance.trackOutlink(ExternalLinks.immersionBoulangerLink);
              launchExternalUrl(ExternalLinks.immersionBoulangerLink);
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
                  title: ImmersionBoulangerAssets.text_1,
                  imagePath: ImmersionBoulangerAssets.illustration_0,
                  spans: [
                    TextSpan(
                      text: ImmersionBoulangerAssets.text_2,
                      style: TextStyles.textBaseRegular,
                    ),
                  ],
                ),
                SizedBox(height: Margins.spacing_m),
                _VerbatimCard(),
                SizedBox(height: Margins.spacing_m),
                _InformationCard(
                  title: ImmersionBoulangerAssets.text_5,
                  imagePath: ImmersionBoulangerAssets.illustration_1,
                  spans: [
                    TextSpan(
                      text: ImmersionBoulangerAssets.text_6_1,
                      style: TextStyles.textBaseBold,
                    ),
                    TextSpan(
                      text: ImmersionBoulangerAssets.text_6_2,
                      style: TextStyles.textBaseRegular,
                    ),
                    TextSpan(
                      text: ImmersionBoulangerAssets.text_6_3,
                      style: TextStyles.textBaseBold,
                    ),
                    TextSpan(
                      text: ImmersionBoulangerAssets.text_6_4,
                      style: TextStyles.textBaseBold,
                    ),
                    TextSpan(
                      text: ImmersionBoulangerAssets.text_6_5,
                      style: TextStyles.textBaseRegular,
                    ),
                    TextSpan(
                      text: ImmersionBoulangerAssets.text_6_6,
                      style: TextStyles.textBaseBold,
                    ),
                    TextSpan(
                      text: ImmersionBoulangerAssets.text_6_7,
                      style: TextStyles.textBaseRegular,
                    ),
                    TextSpan(
                      text: ImmersionBoulangerAssets.text_6_8,
                      style: TextStyles.textBaseBold,
                    ),
                    TextSpan(
                      text: ImmersionBoulangerAssets.text_6_9,
                      style: TextStyles.textBaseRegular,
                    ),
                    TextSpan(
                      text: ImmersionBoulangerAssets.text_6_10,
                      style: TextStyles.textBaseBold,
                    ),
                    TextSpan(
                      text: ImmersionBoulangerAssets.text_6_11,
                      style: TextStyles.textBaseRegular,
                    ),
                    TextSpan(
                      text: ImmersionBoulangerAssets.text_6_12,
                      style: TextStyles.textBaseRegular,
                    ),
                  ],
                ),
                SizedBox(height: Margins.spacing_m),
                _InformationCard(
                  title: ImmersionBoulangerAssets.text_6_13,
                  imagePath: ImmersionBoulangerAssets.illustration_2,
                  spans: [
                    TextSpan(
                      text: ImmersionBoulangerAssets.text_6_14,
                      style: TextStyles.textBaseBold,
                    ),
                    TextSpan(
                      text: ImmersionBoulangerAssets.text_6_15,
                      style: TextStyles.textBaseBold,
                    ),
                    TextSpan(
                      text: ImmersionBoulangerAssets.text_6_16,
                      style: TextStyles.textBaseRegular,
                    ),
                    TextSpan(
                      text: ImmersionBoulangerAssets.text_6_17,
                      style: TextStyles.textBaseBold,
                    ),
                    TextSpan(
                      text: ImmersionBoulangerAssets.text_6_18,
                      style: TextStyles.textBaseRegular,
                    ),
                    TextSpan(
                      text: ImmersionBoulangerAssets.text_6_19,
                      style: TextStyles.textBaseBold,
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
      backgroundColor: AppColors.primaryDarken,
      child: Column(
        children: [
          SizedBox(height: Margins.spacing_s),
          Image.asset(ImmersionBoulangerAssets.verbatim, width: 64, excludeFromSemantics: true),
          SizedBox(height: Margins.spacing_base),
          Text(
            ImmersionBoulangerAssets.text_3,
            style: TextStyles.textMRegular.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Margins.spacing_s),
          Text(
            ImmersionBoulangerAssets.text_4,
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
