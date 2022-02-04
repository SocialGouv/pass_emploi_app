import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/onboarding_background.dart';
import 'package:pass_emploi_app/widgets/primary_action_button.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../ui/strings.dart';
import 'choix_organisme_page.dart';

class CejInformationPage extends StatefulWidget {
  static MaterialPageRoute materialPageRoute() {
    return MaterialPageRoute(builder: (context) => CejInformationPage());
  }

  CejInformationPage({Key? key}) : super(key: key);

  @override
  State<CejInformationPage> createState() => _CejInformationPageState();
}

class _CejInformationPageState extends State<CejInformationPage> {
  final PageController _controller = PageController();
  int? _displayedPage;

  @override
  void initState() {
    _controller.addListener(() {
      final _controllerPage = _controller.page?.floor();
      if (_controllerPage != null && _controllerPage != _displayedPage) {
        _displayedPage = _controllerPage;
        MatomoTracker.trackScreenWithName(AnalyticsScreenNames.cejInformationPage(_controllerPage), "");
      }
    });
    super.initState();
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
                Material(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      _backButton(context),
                      Spacer(),
                      InkWell(
                        onTap: () => Navigator.push(context, ChoixOrganismePage.materialPageRoute()),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: Margins.spacing_s,
                            horizontal: Margins.spacing_base,
                          ),
                          child: Text(Strings.skip, style: TextStyles.textPrimaryButton.copyWith(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView(
                    controller: _controller,
                    children: [
                      _firstCard(),
                      _secondCard(),
                      _thirdCard(),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(Margins.spacing_m, 0, Margins.spacing_m, Margins.spacing_m),
                  child: PrimaryActionButton(
                    label: Strings.continueLabel,
                    onPressed: () {
                      final currentPage = _controller.page;
                      if (currentPage != null && currentPage < 2) {
                        _controller.animateToPage(
                          currentPage.floor() + 1,
                          duration: Duration(milliseconds: 600),
                          curve: Curves.linearToEaseOut,
                        );
                      } else {
                        Navigator.push(context, ChoixOrganismePage.materialPageRoute());
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(Margins.spacing_m, 0, Margins.spacing_m, Margins.spacing_m),
                  child: Center(
                    child: SmoothPageIndicator(
                      controller: _controller,
                      count: 3,
                      effect: WormEffect(
                        activeDotColor: AppColors.primary,
                        dotColor: AppColors.disabled,
                        dotHeight: 10,
                        dotWidth: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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

  Widget _contentCard(List<Widget> children) {
    return Padding(
      padding: const EdgeInsets.all(Margins.spacing_m),
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(Margins.spacing_m),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          ),
        ),
      ),
    );
  }

  Widget _firstCard() {
    return _contentCard(
      [
        Text(Strings.whatIsPassEmploi, style: TextStyles.textMBold.copyWith(color: AppColors.primary)),
        SizedBox(height: Margins.spacing_base),
        Text(Strings.whatIsPassEmploiDesc, style: TextStyles.textBaseRegular),
        SizedBox(height: Margins.spacing_m),
        _cardBulletPoint(Drawables.icDone, Strings.customService),
        SizedBox(height: Margins.spacing_s),
        Text(Strings.customServiceDesc, style: TextStyles.textBaseRegular),
        SizedBox(height: Margins.spacing_m),
        _cardBulletPoint(Drawables.icOnboardingChat, Strings.favoredContact),
        SizedBox(height: Margins.spacing_s),
        Text(Strings.favoredContactDesc, style: TextStyles.textBaseRegular),
        SizedBox(height: Margins.spacing_m),
        _cardBulletPoint(Drawables.icSearch, Strings.searchTool),
        SizedBox(height: Margins.spacing_s),
        Text(Strings.searchToolDesc, style: TextStyles.textBaseRegular),
      ],
    );
  }

  Widget _secondCard() {
    return _contentCard(
      [
        Text(Strings.whatIsCej, style: TextStyles.textMBold.copyWith(color: AppColors.primary)),
        SizedBox(height: Margins.spacing_m),
        _cardBulletPoint(Drawables.icFlash, Strings.customService),
        SizedBox(height: Margins.spacing_s),
        Text(Strings.customServiceCejDesc, style: TextStyles.textBaseRegular),
        SizedBox(height: Margins.spacing_m),
        _cardBulletPoint(Drawables.icPeople, Strings.uniqueReferent),
        SizedBox(height: Margins.spacing_s),
        Text(Strings.uniqueReferentDesc, style: TextStyles.textBaseRegular),
        SizedBox(height: Margins.spacing_m),
        _cardBulletPoint(Drawables.icEuro, Strings.financialHelp),
        SizedBox(height: Margins.spacing_s),
        Text(Strings.financialHelpDesc, style: TextStyles.textBaseRegular),
      ],
    );
  }

  Widget _thirdCard() {
    return _contentCard([
      Text(Strings.whoIsConcerned, style: TextStyles.textMBold.copyWith(color: AppColors.primary)),
      SizedBox(height: Margins.spacing_m),
      SvgPicture.asset(Drawables.puzzle),
      SizedBox(height: Margins.spacing_m),
      RichText(
        text: TextSpan(
          children: [
            TextSpan(text: Strings.whoIsConcernedFirstRichText[0], style: TextStyles.textBaseRegular),
            TextSpan(text: Strings.whoIsConcernedFirstRichText[1], style: TextStyles.textBaseBold),
            TextSpan(text: Strings.whoIsConcernedFirstRichText[2], style: TextStyles.textBaseRegular),
            TextSpan(text: Strings.whoIsConcernedFirstRichText[3], style: TextStyles.textBaseBold),
            TextSpan(text: Strings.whoIsConcernedFirstRichText[4], style: TextStyles.textBaseRegular),
          ],
        ),
      ),
      SizedBox(height: Margins.spacing_m),
      RichText(
        text: TextSpan(
          children: [
            // → Les personnes qui ne sont pas en formation ni en emploi durable (CDI ou CDD de longue durée)
            TextSpan(text: Strings.whoIsConcernedSecondRichText[0], style: TextStyles.textBaseRegular),
            TextSpan(text: Strings.whoIsConcernedSecondRichText[1], style: TextStyles.textBaseBold),
            TextSpan(text: Strings.whoIsConcernedSecondRichText[2], style: TextStyles.textBaseRegular),
          ],
        ),
      ),
    ]);
  }

  Widget _cardBulletPoint(String icon, String text) {
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            child: Padding(
              padding: const EdgeInsets.only(right: Margins.spacing_s),
              child: SvgPicture.asset(icon),
            ),
          ),
          TextSpan(text: text, style: TextStyles.textBaseBold),
        ],
      ),
    );
  }
}
