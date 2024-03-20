import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/presentation/onboarding/accueil_onboarding_view_model.dart';
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

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
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
      distinct: true,
      onWillChange: _onWillChange,
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
                    onAcceptNotifications: () => viewModel.onRequestNotificationsPermission(),
                    onDeclineNotifications: () {
                      viewModel.onOnboardingCompleted();
                      Navigator.of(context).pop();
                    },
                  ),
          ),
        );
      },
    );
  }

  void _onWillChange(AccueilOnboardingViewModel? previousVM, AccueilOnboardingViewModel newVM) {
    if ((previousVM?.shouldDismiss == false) && newVM.shouldDismiss) {
      Navigator.of(context).pop();
    }
  }
}

class _AccueilOnboardingPage1 extends StatelessWidget {
  const _AccueilOnboardingPage1({required this.viewModel, required this.onContinue});

  final AccueilOnboardingViewModel viewModel;
  final void Function() onContinue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _OnboardingIllustration(Drawables.accueilOnboardingIllustration1),
            SizedBox(height: Margins.spacing_xl),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _OnboardingTitle(Strings.accueilOnboardingTitle1(viewModel.userName)),
                  SizedBox(height: Margins.spacing_m),
                  _OnboardingBodyText(viewModel.body),
                  SizedBox(height: Margins.spacing_m),
                  PrimaryActionButton(
                    label: Strings.continueLabel,
                    onPressed: onContinue,
                  ),
                ],
              ),
            ),
            SizedBox(height: Margins.spacing_x_huge),
          ],
        ),
      ),
    );
  }
}

class _AccueilOnboardingPage2 extends StatelessWidget {
  const _AccueilOnboardingPage2({
    required this.onAcceptNotifications,
    required this.onDeclineNotifications,
    required this.viewModel,
  });

  final void Function() onAcceptNotifications;
  final void Function() onDeclineNotifications;
  final AccueilOnboardingViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _OnboardingIllustration(Drawables.accueilOnboardingIllustration2),
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
                  SizedBox(height: Margins.spacing_m),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      PrimaryActionButton(
                        label: Strings.accueilOnboardingButtonAcceptNotifications,
                        onPressed: onAcceptNotifications,
                      ),
                      SizedBox(height: Margins.spacing_s),
                      SecondaryButton(
                        label: Strings.accueilOnboardingButtonDeclineNotifications,
                        onPressed: onDeclineNotifications,
                      ),
                    ],
                  ),
                  SizedBox(height: Margins.spacing_x_huge),
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
  const _OnboardingIllustration(this.asset);

  final String asset;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      asset,
      fit: BoxFit.fitWidth,
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
