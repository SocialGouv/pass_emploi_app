import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/presentation/onboarding/accueil_onboarding_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/drawables.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/onboarding/onboarding_bottom_sheet_height_factor.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';

class OnboardingAccueilBottomSheet extends StatefulWidget {
  const OnboardingAccueilBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const OnboardingAccueilBottomSheet(),
      isDismissible: false,
      enableDrag: false,
    );
  }

  @override
  State<OnboardingAccueilBottomSheet> createState() => _OnboardingAccueilBottomSheetState();
}

class _OnboardingAccueilBottomSheetState extends State<OnboardingAccueilBottomSheet> {
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
          heightFactor: _currentPage == 0 ? onboardingBottomSheetHeightFactor(context) + 0.05 : 0.9,
          body: AnimatedSwitcher(
            duration: AnimationDurations.fast,
            child: _currentPage == 0
                ? _OnboardingAccueilPage(viewModel: viewModel, onContinue: () => nextPage())
                : _OnboardingPushNotificationPermissionPage(
              viewModel: viewModel,
                    onAcceptNotifications: () {
                      viewModel.onRequestNotificationsPermission();
                      PassEmploiMatomoTracker.instance.trackEvent(
                        eventCategory: AnalyticsEventNames.onboardingPushNotificationPermissionCategory,
                        action: AnalyticsEventNames.onboardingPushNotificationPermissionAcceptAction,
                      );
                    },
                    onDeclineNotifications: () {
                      viewModel.onOnboardingCompleted();
                      PassEmploiMatomoTracker.instance.trackEvent(
                        eventCategory: AnalyticsEventNames.onboardingPushNotificationPermissionCategory,
                        action: AnalyticsEventNames.onboardingPushNotificationPermissionDeclineAction,
                      );
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

class _OnboardingAccueilPage extends StatelessWidget {
  const _OnboardingAccueilPage({required this.viewModel, required this.onContinue});

  final AccueilOnboardingViewModel viewModel;
  final void Function() onContinue;

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.onboardingAccueil,
      child: Scaffold(
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
              SizedBox(height: Margins.spacing_base),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingPushNotificationPermissionPage extends StatelessWidget {
  const _OnboardingPushNotificationPermissionPage({
    required this.onAcceptNotifications,
    required this.onDeclineNotifications,
    required this.viewModel,
  });

  final void Function() onAcceptNotifications;
  final void Function() onDeclineNotifications;
  final AccueilOnboardingViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.onboardingPushNotificationPermission,
      child: Scaffold(
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
                    SizedBox(height: Margins.spacing_base),
                  ],
                ),
              )
            ],
          ),
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
