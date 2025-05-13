import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/models/onboarding.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/confetti_wrapper.dart';

class OnboardingNotifierWrapper extends StatefulWidget {
  final Widget child;

  const OnboardingNotifierWrapper({super.key, required this.child});

  @override
  State<OnboardingNotifierWrapper> createState() => _OnboardingNotifierWrapperState();
}

class _OnboardingNotifierWrapperState extends State<OnboardingNotifierWrapper> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Onboarding?>(
      converter: (store) => store.state.onboardingState.onboarding,
      builder: (context, viewModel) {
        return widget.child;
      },
      distinct: true,
      onDidChange: (previousOnboarding, onboarding) {
        if (previousOnboarding != null && onboarding != null) {
          if (!previousOnboarding.messageCompleted && onboarding.messageCompleted) {
            _showOnboardingSnackbar(Strings.onboardingStepFinished);
          } else if (!previousOnboarding.actionCompleted && onboarding.actionCompleted) {
            _showOnboardingSnackbar(Strings.onboardingStepFinished);
          } else if (!previousOnboarding.offreCompleted && onboarding.offreCompleted) {
            _showOnboardingSnackbar(Strings.onboardingStepFinished);
          } else if (!previousOnboarding.evenementCompleted && onboarding.evenementCompleted) {
            _showOnboardingSnackbar(Strings.onboardingStepFinished);
          } else if (!previousOnboarding.outilsCompleted && onboarding.outilsCompleted) {
            _showOnboardingSnackbar(Strings.onboardingStepFinished);
          }
        }
      },
    );
  }

  void _showOnboardingSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        margin: const EdgeInsets.all(Margins.spacing_base),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.successLighten,
        content: ConfettiWrapper(
          builder: (context, confettiController) {
            confettiController.play();
            return Text(message, style: TextStyles.textSBold.copyWith(color: AppColors.success));
          },
        ),
        action: SnackBarAction(
          label: Strings.close,
          textColor: AppColors.success,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
