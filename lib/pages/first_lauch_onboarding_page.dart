import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/first_launch_onboarding/first_launch_onboarding_actions.dart';
import 'package:pass_emploi_app/models/brand.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/media_sizes.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/context_extensions.dart';
import 'package:pass_emploi_app/widgets/a11y/auto_focus.dart';
import 'package:pass_emploi_app/widgets/biseau_background.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/drawables/app_logo.dart';
import 'package:pass_emploi_app/widgets/welcome.dart';

class FirstLaunchOnboardingPage extends StatefulWidget {
  @override
  State<FirstLaunchOnboardingPage> createState() => _FirstLaunchOnboardingPageState();
}

class _FirstLaunchOnboardingPageState extends State<FirstLaunchOnboardingPage> {
  bool _firstScreen = true;

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.onboardingFirstLaunch,
      child: _firstScreen ? _FirstScreen(onStart: () => setState(() => _firstScreen = false)) : _PageViewScreen(),
    );
  }
}

class _FirstScreen extends StatelessWidget {
  final VoidCallback onStart;

  const _FirstScreen({required this.onStart});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          BiseauBackground(),
          Align(
            alignment: Alignment.center,
            child: _Welcome(firstScreen: true),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(Margins.spacing_xl),
              child: SizedBox(
                width: double.infinity,
                child: SecondaryButton(
                  label: Strings.start,
                  foregroundColor: Brand.isCej() ? AppColors.primary : AppColors.primaryDarkenStrong,
                  onPressed: onStart,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PageViewScreen extends StatelessWidget {
  final _pageController = PageController();

  final page2Key = GlobalKey();
  final page3Key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final shrink = MediaQuery.of(context).size.height < MediaSizes.height_s;
    return Scaffold(
      body: Stack(
        children: [
          BiseauBackground(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                flex: shrink ? 0 : 13,
                child: SizedBox.shrink(),
              ),
              Expanded(
                flex: shrink ? 15 : 37,
                child: Center(child: _Welcome(firstScreen: false)),
              ),
              Expanded(
                flex: 40,
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (value) {
                    if (value == 1) {
                      page2Key.requestFocusDelayed(duration: AnimationDurations.verySlow);
                    } else if (value == 2) {
                      page3Key.requestFocusDelayed(duration: AnimationDurations.verySlow);
                    }
                  },
                  children: [
                    _FirstPageContent(onContinue: () => _pageController.next()),
                    _SecondPageContent(
                      onContinue: () => _pageController.next(),
                      globalKey: page2Key,
                    ),
                    _ThirdPageContent(
                      onContinue: () => context.dispatch(FirstLaunchOnboardingFinishAction()),
                      globalKey: page3Key,
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: shrink ? 5 : 10,
                child: Center(
                  child: _CarouselStepperIndicator(_pageController),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Welcome extends StatelessWidget {
  final bool firstScreen;

  const _Welcome({required this.firstScreen});

  @override
  Widget build(BuildContext context) {
    final bool withText = firstScreen || MediaQuery.of(context).size.height > MediaSizes.height_s;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppLogo(width: 120),
        if (withText) ...[
          const SizedBox(height: Margins.spacing_base),
          firstScreen ? Welcome() : Welcome.small(),
        ],
      ],
    );
  }
}

class _FirstPageContent extends StatelessWidget {
  const _FirstPageContent({required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return _PageContent(
      title: Strings.firstLaunchOnboardingCardTitle1,
      subtitle: Strings.firstLaunchOnboardingCardContent1,
      icon: AppIcons.people_outline_rounded,
      onContinue: onContinue,
      autoFocus: true,
    );
  }
}

class _SecondPageContent extends StatelessWidget {
  const _SecondPageContent({required this.onContinue, required this.globalKey});

  final VoidCallback onContinue;
  final GlobalKey globalKey;

  @override
  Widget build(BuildContext context) {
    return _PageContent(
      title: Strings.firstLaunchOnboardingCardTitle2,
      subtitle: Strings.firstLaunchOnboardingCardContent2,
      icon: AppIcons.chat_outlined,
      onContinue: onContinue,
      autoFocus: false,
      globalKey: globalKey,
    );
  }
}

class _ThirdPageContent extends StatelessWidget {
  const _ThirdPageContent({required this.onContinue, required this.globalKey});

  final VoidCallback onContinue;
  final GlobalKey globalKey;

  @override
  Widget build(BuildContext context) {
    return _PageContent(
      title: Strings.firstLaunchOnboardingCardTitle3,
      subtitle: Strings.firstLaunchOnboardingCardContent3,
      icon: AppIcons.lock_rounded,
      onContinue: onContinue,
      autoFocus: false,
      globalKey: globalKey,
    );
  }
}

class _PageContent extends StatelessWidget {
  const _PageContent({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onContinue,
    required this.autoFocus,
    this.globalKey,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onContinue;
  final bool autoFocus;
  final GlobalKey? globalKey;

  @override
  Widget build(BuildContext context) {
    final color = Brand.isCej() ? AppColors.primary : AppColors.primaryDarkenStrong;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_m),
      child: CardContainer(
        padding: const EdgeInsets.all(Margins.spacing_m),
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(icon, color: color, size: 32),
                  ),
                  SizedBox(height: Margins.spacing_s),
                  Builder(builder: (context) {
                    final text = Text(key: globalKey, title, style: TextStyles.textBaseBold);
                    if (autoFocus) {
                      return AutoFocusA11y(child: text);
                    }
                    return text;
                  }),
                  SizedBox(height: Margins.spacing_s),
                  Text(subtitle, style: TextStyles.textSRegular()),
                  Expanded(child: SizedBox.shrink()),
                  PrimaryActionButton(
                    label: Strings.continueLabel,
                    backgroundColor: color,
                    onPressed: onContinue,
                  ),
                  SizedBox(height: Margins.spacing_s),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _CarouselStepperIndicator extends StatefulWidget {
  final PageController _pageController;

  const _CarouselStepperIndicator(this._pageController);

  @override
  State<_CarouselStepperIndicator> createState() => _CarouselStepperIndicatorState();
}

class _CarouselStepperIndicatorState extends State<_CarouselStepperIndicator> {
  static const _length = 3;
  int currentPage = 0;

  @override
  void initState() {
    widget._pageController.addListener(() {
      setState(() => currentPage = widget._pageController.page!.round());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_length, (i) {
        return Container(
          width: Margins.spacing_s,
          height: Margins.spacing_s,
          margin: const EdgeInsets.symmetric(horizontal: Margins.spacing_xs),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i == currentPage ? Colors.white : Colors.white.withOpacity(0.5),
          ),
        );
      }),
    );
  }
}

extension on PageController {
  Future<void> next() => nextPage(duration: AnimationDurations.medium, curve: Curves.fastEaseInToSlowEaseOut);
}
