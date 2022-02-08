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
import '../widgets/cej_information_content_card.dart';
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
        MatomoTracker.trackScreenWithName(AnalyticsScreenNames.cejInformationPage(_controllerPage + 1), "");
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
                      const CejInformationFirstContentCard(),
                      const CejInformationSecondContentCard(),
                      const CejInformationThirdContentCard()
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
}
