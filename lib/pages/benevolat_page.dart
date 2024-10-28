import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/benevolat_assets.dart';
import 'package:pass_emploi_app/ui/external_links.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/launcher_utils.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/a11y/string_a11y_extensions.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class BenevolatPage extends StatelessWidget {
  static MaterialPageRoute<void> materialPageRoute() => MaterialPageRoute(builder: (context) => BenevolatPage());

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.benevolat,
      child: Scaffold(
        appBar: SecondaryAppBar(title: BenevolatAssets.title),
        floatingActionButton: _Button(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Margins.spacing_base),
            child: Column(
              children: [
                _InformationCard(
                  imagePath: BenevolatAssets.imageCard1Path,
                  title: BenevolatAssets.card1Title,
                  spans: [
                    TextSpan(
                      text: BenevolatAssets.card1Part1,
                      semanticsLabel: BenevolatAssets.card1Part1.removeIconsForScreenReaders(),
                      style: TextStyles.textBaseRegular,
                    ),
                    TextSpan(
                      text: BenevolatAssets.link,
                      style: TextStyles.textBaseRegular.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    TextSpan(
                      text: BenevolatAssets.card1Part2,
                      semanticsLabel: BenevolatAssets.card1Part2.removeIconsForScreenReaders(),
                      style: TextStyles.textBaseRegular,
                    ),
                  ],
                ),
                SizedBox(height: Margins.spacing_m),
                _VerbatimCard(),
                SizedBox(height: Margins.spacing_m),
                _InformationCard(
                  imagePath: BenevolatAssets.imageCard3Path,
                  title: BenevolatAssets.card2Title,
                  spans: [
                    TextSpan(
                      text: BenevolatAssets.card2Part1,
                      semanticsLabel: BenevolatAssets.card2Part1.removeIconsForScreenReaders(),
                      style: TextStyles.textBaseRegular,
                    ),
                    TextSpan(
                      text: BenevolatAssets.link,
                      style: TextStyles.textBaseRegular.copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    TextSpan(
                      text: BenevolatAssets.card2Part2,
                      semanticsLabel: BenevolatAssets.card2Part2.removeIconsForScreenReaders(),
                      style: TextStyles.textBaseRegular,
                    ),
                  ],
                ),
                SizedBox(height: Margins.spacing_m),
                _InformationCard(
                  imagePath: BenevolatAssets.imageCard4Path,
                  title: BenevolatAssets.card3Title,
                  spans: [
                    TextSpan(
                      text: BenevolatAssets.card3Part1,
                      semanticsLabel: BenevolatAssets.card3Part1.removeIconsForScreenReaders(),
                      style: TextStyles.textBaseRegular,
                    ),
                    TextSpan(
                      text: BenevolatAssets.card3Part2,
                      semanticsLabel: BenevolatAssets.card3Part2.removeIconsForScreenReaders(),
                      style: TextStyles.textBaseMediumBold().copyWith(
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: Margins.spacing_x_huge),
              ],
            ),
          ),
        ),
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
    return Focus(
      child: Semantics(
        link: true,
        child: GestureDetector(
          onTap: () => _launchExternalRedirect(),
          child: CardContainer(
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
          ),
        ),
      ),
    );
  }
}

class _VerbatimCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Focus(
      child: Semantics(
        link: true,
        child: GestureDetector(
          onTap: () => _launchExternalRedirect(),
          child: CardContainer(
            padding: EdgeInsets.zero,
            backgroundColor: Color(0xFF0A0E93),
            child: Column(
              children: [
                SizedBox(height: Margins.spacing_m),
                Image.asset(BenevolatAssets.imageVerbatimPath, width: 64, excludeFromSemantics: true),
                SizedBox(height: Margins.spacing_base),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
                  child: Text(
                    BenevolatAssets.verbatimPart1,
                    style: TextStyles.textMRegular.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: Margins.spacing_s),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_base),
                  child: Text.rich(
                    textAlign: TextAlign.center,
                    TextSpan(
                      children: [
                        TextSpan(
                          text: BenevolatAssets.verbatimPart2,
                          semanticsLabel: BenevolatAssets.verbatimPart2.removeIconsForScreenReaders(),
                          style: TextStyles.textBaseRegular.copyWith(color: Colors.white),
                        ),
                        TextSpan(
                          text: BenevolatAssets.link,
                          style: TextStyles.textBaseRegular.copyWith(
                            color: Colors.white,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: Margins.spacing_m),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Margins.spacing_base),
      child: PrimaryActionButton(
        label: BenevolatAssets.cta,
        underlined: true,
        widthPadding: Margins.spacing_xl,
        icon: AppIcons.open_in_new_rounded,
        iconLabel: Strings.link,
        onPressed: () => _launchExternalRedirect(),
      ),
    );
  }
}

void _launchExternalRedirect() {
  PassEmploiMatomoTracker.instance.trackOutlink(ExternalLinks.boiteAOutilsBenevolat);
  launchExternalUrl(ExternalLinks.boiteAOutilsBenevolat);
}
