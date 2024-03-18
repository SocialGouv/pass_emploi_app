import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/first_launch_onboarding/first_launch_onboarding_actions.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/drawables/app_logo.dart';
import 'package:pass_emploi_app/widgets/entree_biseau_background.dart';

class FirstLaunchOnboardingPage extends StatelessWidget {
  const FirstLaunchOnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: const <Widget>[
          EntreeBiseauBackground(),
          _Content(),
        ],
      ),
    );
  }
}

class _Content extends StatefulWidget {
  const _Content();

  @override
  State<_Content> createState() => _ContentState();
}

class _ContentState extends State<_Content> {
  int _index = 0;

  void incrementIndex() {
    setState(() {
      _index++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: SizedBox()),
          Expanded(
            flex: 2,
            child: Center(child: _Welcome(firstScreen: _index == 0)),
          ),
          AnimatedSwitcher(
            duration: AnimationDurations.medium,
            child: switch (_index) {
              1 => _FirstPageContent(onContinue: incrementIndex),
              2 => _SecondPageContent(onContinue: incrementIndex),
              3 => _ThirdPageContent(
                  onContinue: () => StoreProvider.of<AppState>(context).dispatch(FirstLaunchOnboardingFinishAction())),
              _ => _InitialPageContent(onStart: incrementIndex),
            },
          ),
          SizedBox(height: Margins.spacing_base),
          if (_index == 0) SizedBox(height: Margins.spacing_s),
          if (_index != 0) _CarouselStepperIndicator(index: _index - 1, length: 3),
          SizedBox(height: MediaQuery.of(context).padding.bottom + Margins.spacing_base),
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
    final bool withText = firstScreen || MediaQuery.of(context).size.height > 700;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppLogo(width: 120),
        const SizedBox(height: Margins.spacing_base),
        if (withText) ...[
          Text(Strings.welcome, style: TextStyles.textLBold(color: Colors.white), textAlign: TextAlign.center),
          SizedBox(height: Margins.spacing_base),
          Text(Strings.welcomeMessage, style: TextStyles.textSMedium(color: Colors.white), textAlign: TextAlign.center),
          SizedBox(height: Margins.spacing_m),
        ],
      ],
    );
  }
}

class _CarouselStepperIndicator extends StatelessWidget {
  const _CarouselStepperIndicator({required this.index, required this.length});

  final int index;
  final int length;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (i) {
        return Container(
          width: Margins.spacing_s,
          height: Margins.spacing_s,
          margin: const EdgeInsets.symmetric(horizontal: Margins.spacing_xs),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i == index ? Colors.white : Colors.white.withOpacity(0.5),
          ),
        );
      }),
    );
  }
}

class _FirstLaunchOnboardingCard extends StatelessWidget {
  const _FirstLaunchOnboardingCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onContinue,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return CardContainer(
        padding: const EdgeInsets.all(Margins.spacing_m),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 32,
              ),
            ),
            SizedBox(height: Margins.spacing_s),
            Text(title, style: TextStyles.textBaseBold),
            SizedBox(height: Margins.spacing_s),
            Text(subtitle, style: TextStyles.textSRegular()),
            SizedBox(height: Margins.spacing_m),
            PrimaryActionButton(label: Strings.continueLabel, onPressed: onContinue),
          ],
        ));
  }
}

class _InitialPageContent extends StatelessWidget {
  const _InitialPageContent({required this.onStart});

  final VoidCallback onStart;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: double.infinity, child: SecondaryButton(label: Strings.start, onPressed: onStart));
  }
}

class _FirstPageContent extends StatelessWidget {
  const _FirstPageContent({required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return _FirstLaunchOnboardingCard(
      title: Strings.firstLaunchOnboardingCardTitle1,
      subtitle: Strings.firstLaunchOnboardingCardContent1,
      icon: AppIcons.people_outline_rounded,
      onContinue: onContinue,
    );
  }
}

class _SecondPageContent extends StatelessWidget {
  const _SecondPageContent({required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return _FirstLaunchOnboardingCard(
      title: Strings.firstLaunchOnboardingCardTitle2,
      subtitle: Strings.firstLaunchOnboardingCardContent2,
      icon: AppIcons.chat_outlined,
      onContinue: onContinue,
    );
  }
}

class _ThirdPageContent extends StatelessWidget {
  const _ThirdPageContent({required this.onContinue});

  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return _FirstLaunchOnboardingCard(
      title: Strings.firstLaunchOnboardingCardTitle3,
      subtitle: Strings.firstLaunchOnboardingCardContent3,
      icon: AppIcons.lock_rounded,
      onContinue: onContinue,
    );
  }
}
