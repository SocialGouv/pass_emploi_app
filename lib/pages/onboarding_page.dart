import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/pages/accueil/accueil_onboarding_tile.dart';
import 'package:pass_emploi_app/presentation/onboarding_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/font_sizes.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (BuildContext context) => const OnboardingPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OnboardingViewModel>(
      converter: (store) => OnboardingViewModel.create(store),
      builder: (context, viewModel) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: SecondaryAppBar(title: ""),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(Margins.spacing_base),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      OnboardingStepper(
                        completedSteps: viewModel.completedSteps,
                        totalSteps: viewModel.totalSteps,
                        backgroundColor: AppColors.primaryLighten,
                        textColor: AppColors.contentColor,
                      ),
                      const SizedBox(width: Margins.spacing_base),
                      Expanded(
                        child: Text(
                          Strings.onboardingTitle,
                          style: TextStyles.textMBold,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: Margins.spacing_m),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: Margins.spacing_s,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLighten,
                            borderRadius: BorderRadius.circular(Dimens.radius_l),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              _Icon(AppIcons.smartphone_outlined),
                              SizedBox(height: Margins.spacing_base),
                              _Icon(AppIcons.chat_outlined),
                              SizedBox(height: Margins.spacing_base),
                              _Icon(AppIcons.bolt_outlined),
                              SizedBox(height: Margins.spacing_base),
                              _Icon(AppIcons.pageview_outlined),
                              SizedBox(height: Margins.spacing_base),
                              _Icon(AppIcons.calendar_today_outlined),
                              SizedBox(height: Margins.spacing_base),
                              _Icon(AppIcons.handyman_outlined),
                            ],
                          ),
                        ),
                        SizedBox(width: Margins.spacing_base),
                        Expanded(
                          child: Column(
                            children: [
                              _StepTile(
                                title: Strings.installOnboardingSection,
                                isCompleted: true,
                                onTap: () {},
                              ),
                              SizedBox(height: Margins.spacing_base),
                              _StepTile(
                                title: Strings.messageOnboardingSection,
                                isCompleted: viewModel.messageCompleted,
                                onTap: () {
                                  Navigator.of(context).pop();
                                  viewModel.onMessageOnboarding.call();
                                },
                              ),
                              SizedBox(height: Margins.spacing_base),
                              _StepTile(
                                title: Strings.actionOnboardingSection,
                                isCompleted: viewModel.actionCompleted,
                                onTap: () {
                                  Navigator.of(context).pop();
                                  viewModel.onActionOnboarding.call();
                                },
                              ),
                              SizedBox(height: Margins.spacing_base),
                              _StepTile(
                                title: Strings.offreOnboardingSection,
                                isCompleted: viewModel.offreCompleted,
                                onTap: () {
                                  Navigator.of(context).pop();
                                  viewModel.onOffreOnboarding.call();
                                },
                              ),
                              SizedBox(height: Margins.spacing_base),
                              _StepTile(
                                title: Strings.evenementOnboardingSection,
                                isCompleted: viewModel.evenementCompleted,
                                onTap: () {
                                  Navigator.of(context).pop();
                                  viewModel.onEvenementOnboarding.call();
                                },
                              ),
                              SizedBox(height: Margins.spacing_base),
                              _StepTile(
                                title: Strings.outilsOnboardingSection,
                                isCompleted: viewModel.outilsCompleted,
                                onTap: () {
                                  Navigator.of(context).pop();
                                  viewModel.onOutilsOnboarding.call();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: Margins.spacing_l),
                  SecondaryButton(
                    label: Strings.skipOnboarding,
                    onPressed: () => _showSkipOnboardingDialog(context, viewModel),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showSkipOnboardingDialog(BuildContext context, OnboardingViewModel viewModel) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => _SkipOnboardingDialog(viewModel: viewModel),
    );
    if (result == true && context.mounted) {
      Navigator.of(context).pop();
    }
  }
}

class _StepTile extends StatelessWidget {
  const _StepTile({
    required this.title,
    required this.isCompleted,
    required this.onTap,
  });

  final String title;
  final bool isCompleted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    if (isCompleted) {
      return Padding(
        padding: EdgeInsets.all(Margins.spacing_base),
        child: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: AppColors.success,
            ),
            const SizedBox(width: Margins.spacing_base),
            Expanded(
              child: Text(
                title,
                style: TextStyles.textBaseBold.copyWith(color: AppColors.grey800),
              ),
            ),
          ],
        ),
      );
    }
    return CardContainer(
      onTap: onTap,
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyles.textBaseBold,
            ),
          ),
          const SizedBox(width: Margins.spacing_base),
          Icon(
            Icons.chevron_right_rounded,
            color: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

class _Icon extends StatelessWidget {
  final IconData icon;
  const _Icon(this.icon);

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: AppColors.primary,
    );
  }
}

class _SkipOnboardingDialog extends StatelessWidget {
  const _SkipOnboardingDialog({required this.viewModel});

  final OnboardingViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(Strings.skipOnboarding, style: TextStyles.textMBold),
      content: Text(Strings.skipOnboardingContent, style: TextStyles.textBaseRegular),
      actions: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PrimaryActionButton(
              label: Strings.continueLabel,
              textColor: AppColors.warning,
              backgroundColor: AppColors.warningLighten,
              disabledBackgroundColor: AppColors.warningLighten,
              rippleColor: AppColors.warningLighten,
              withShadow: true,
              onPressed: () {
                Navigator.pop(context, true);
                viewModel.onSkipOnboarding.call();
              },
            ),
            SizedBox(height: Margins.spacing_base),
            SecondaryButton(
              label: Strings.cancelLabel,
              fontSize: FontSizes.medium,
              onPressed: () => Navigator.pop(context, false),
            ),
          ],
        ),
      ],
    );
  }
}
