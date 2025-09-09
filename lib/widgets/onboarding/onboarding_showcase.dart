import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/onboarding/onboarding_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:showcaseview/showcaseview.dart';

class ShowcaseWrapper extends StatelessWidget {
  const ShowcaseWrapper({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      onStart: (index, __) {},
      onFinish: () {
        StoreProvider.of<AppState>(context).dispatch(ResetOnboardingShowcaseAction());
      },
      builder: (context) {
        return child;
      },
    );
  }
}

enum ShowcaseSource {
  message,
  action,
  offre,
  evenement,
  outils,
}

class OnboardingShowcase extends StatefulWidget {
  const OnboardingShowcase({super.key, required this.child, required this.source, this.bottom = false});
  final Widget child;
  final ShowcaseSource source;
  final bool bottom;

  @override
  State<OnboardingShowcase> createState() => _OnboardingShowcaseState();
}

class _OnboardingShowcaseState extends State<OnboardingShowcase> {
  final GlobalKey key = GlobalKey();

  bool shown = false;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, bool>(
      converter: (store) => switch (widget.source) {
        ShowcaseSource.message => store.state.onboardingState.showMessageOnboarding,
        ShowcaseSource.action => store.state.onboardingState.showActionOnboarding,
        ShowcaseSource.offre => store.state.onboardingState.showOffreOnboarding,
        ShowcaseSource.evenement => store.state.onboardingState.showEvenementOnboarding,
        ShowcaseSource.outils => store.state.onboardingState.showOutilsOnboarding,
      },
      builder: (context, show) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (show && !shown) {
            ShowCaseWidget.of(context).startShowCase([key]);
            shown = true;
          }
        });
        return Showcase(
          targetBorderRadius: BorderRadius.circular(Dimens.radius_base),
          tooltipPosition: widget.bottom ? TooltipPosition.bottom : TooltipPosition.top,
          title: switch (widget.source) {
            ShowcaseSource.message => Strings.onboardingShowcaseMessageTitle,
            ShowcaseSource.action => Strings.onboardingShowcaseActionTitle,
            ShowcaseSource.offre => Strings.onboardingShowcaseOffreTitle,
            ShowcaseSource.evenement => Strings.onboardingShowcaseEvenementTitle,
            ShowcaseSource.outils => Strings.onboardingShowcaseOutilsTitle,
          },
          description: switch (widget.source) {
            ShowcaseSource.message => Strings.onboardingShowcaseMessageDescription,
            ShowcaseSource.action => Strings.onboardingShowcaseActionDescription,
            ShowcaseSource.offre => Strings.onboardingShowcaseOffreDescription,
            ShowcaseSource.evenement => Strings.onboardingShowcaseEvenementDescription,
            ShowcaseSource.outils => Strings.onboardingShowcaseOutilsDescription,
          },
          tooltipBackgroundColor: AppColors.primary,
          titleTextStyle: TextStyles.textMBold.copyWith(color: Colors.white),
          descTextStyle: TextStyles.textBaseRegular.copyWith(color: Colors.white),
          key: key,
          titleAlignment: Alignment.centerLeft,
          descriptionAlignment: Alignment.centerLeft,
          tooltipPadding: const EdgeInsets.all(Margins.spacing_base),
          child: widget.child,
        );
      },
    );
  }
}
