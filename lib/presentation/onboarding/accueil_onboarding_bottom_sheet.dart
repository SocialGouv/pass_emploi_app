import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/presentation/accueil/onboarding/accueil_onboarding_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';

class AccueilOnboardingBottomSheet extends StatefulWidget {
  const AccueilOnboardingBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const AccueilOnboardingBottomSheet(),
    );
  }

  @override
  State<AccueilOnboardingBottomSheet> createState() => _AccueilOnboardingBottomSheetState();
}

class _AccueilOnboardingBottomSheetState extends State<AccueilOnboardingBottomSheet> {
  int _currentPage = 0;

  void nextPage() => setState(() => _currentPage++);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, AccueilOnboardingViewModel>(
        converter: (store) => AccueilOnboardingViewModel.create(store),
        builder: (context, viewModel) {
          return BottomSheetWrapper(
            hideTitle: true,
            padding: EdgeInsets.zero,
            body: AnimatedSwitcher(
              duration: AnimationDurations.fast,
              child: _currentPage == 0
                  ? _AccueilOnboardingPage1(viewModel: viewModel, onContinue: () => nextPage())
                  : _AccueilOnboardingPage2(
                      viewModel: viewModel,
                      onAcceptNotifications: () {
                        viewModel.onRequestiNotificationsPermission();
                        viewModel.onOnboardingCompleted();
                      },
                      onDeclineNotifications: () {
                        viewModel.onOnboardingCompleted();
                      },
                    ),
            ),
          );
        });
  }
}

class _AccueilOnboardingPage1 extends StatelessWidget {
  const _AccueilOnboardingPage1({required this.viewModel, required this.onContinue});
  final AccueilOnboardingViewModel viewModel;
  final void Function() onContinue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_m),
        child: SizedBox(
          width: double.infinity,
          child: PrimaryActionButton(
            label: Strings.continueLabel,
            onPressed: onContinue,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _OnboardingIllustration(Drawables.accueilOnboardingIllustration1, AppColors.primary),
            SizedBox(height: Margins.spacing_xl),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_m),
              child: Column(
                children: [
                  _OnboardingTitle(Strings.accueilOnboardingTitle1(viewModel.userName)),
                  SizedBox(height: Margins.spacing_m),
                  _OnboardingBodyText(Strings.accueilOnboardingBody1),
                ],
              ),
            ),
            SizedBox(height: Margins.spacing_x_huge * 2),
          ],
        ),
      ),
    );
  }
}

class _AccueilOnboardingPage2 extends StatelessWidget {
  const _AccueilOnboardingPage2(
      {required this.onAcceptNotifications, required this.onDeclineNotifications, required this.viewModel});
  final void Function() onAcceptNotifications;
  final void Function() onDeclineNotifications;
  final AccueilOnboardingViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_m),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            PrimaryActionButton(
              label: Strings.accueilOnboardingButtonAcceptNotifications,
              onPressed: onAcceptNotifications,
            ),
            SizedBox(height: Margins.spacing_s),
            SecondaryButton(
              label: Strings.continueLabel,
              onPressed: onDeclineNotifications,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _OnboardingIllustration(Drawables.accueilOnboardingIllustration2, AppColors.alert),
            SizedBox(height: Margins.spacing_xl),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_m),
              child: Column(
                children: [
                  _OnboardingTitle(Strings.accueilOnboardingTitle2),
                  SizedBox(height: Margins.spacing_m),
                  _OnboardingBodyText(Strings.accueilOnboardingBody2),
                  SizedBox(height: Margins.spacing_base),
                  _section(Icons.notifications, Strings.accueilOnboardingSection1),
                  SizedBox(height: Margins.spacing_base),
                  _section(Icons.calendar_today, Strings.accueilOnboardingSection2),
                  SizedBox(height: Margins.spacing_x_huge * 2),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _section(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary),
        SizedBox(width: Margins.spacing_s),
        Expanded(child: _OnboardingBodyText(text)),
      ],
    );
  }
}

class _OnboardingIllustration extends StatelessWidget {
  const _OnboardingIllustration(this.asset, this.bgColor);
  final String asset;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: bgColor,
      child: Image.asset(
        asset,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}

class _OnboardingTitle extends StatelessWidget {
  const _OnboardingTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyles.textMBold,
    );
  }
}

class _OnboardingBodyText extends StatelessWidget {
  const _OnboardingBodyText(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyles.textBaseRegular,
    );
  }
}
