import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/presentation/onboarding/onboarding_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/onboarding/onboarding_bottom_sheet_height_factor.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';

enum OnboardingSource {
  monSuivi,
  chat,
  reherche,
  evenements,
}

class OnboardingBottomSheet extends StatelessWidget {
  const OnboardingBottomSheet({super.key, required this.source});

  final OnboardingSource source;

  static Future<void> show(BuildContext context, {required OnboardingSource source}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => OnboardingBottomSheet(source: source),
      isDismissible: false,
      enableDrag: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: _tracking(),
      child: StoreConnector<AppState, OnboardingViewModel>(
        converter: (store) => OnboardingViewModel.create(store, source),
        builder: (context, viewModel) {
          return BottomSheetWrapper(
            hideTitle: true,
            padding: EdgeInsets.zero,
            body: _Body(viewModel),
            heightFactor: onboardingBottomSheetHeightFactor(context),
          );
        },
      ),
    );
  }

  String _tracking() {
    return switch (source) {
      OnboardingSource.monSuivi => AnalyticsScreenNames.onboardingMonSuivi,
      OnboardingSource.chat => AnalyticsScreenNames.onboardingChat,
      OnboardingSource.reherche => AnalyticsScreenNames.onboardingRecherche,
      OnboardingSource.evenements => AnalyticsScreenNames.onboardingEvenements
    };
  }
}

class _Body extends StatelessWidget {
  final OnboardingViewModel viewModel;

  const _Body(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _OnboardingIllustration(viewModel.illustration),
            SizedBox(height: Margins.spacing_xl),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_m),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _OnboardingTitle(viewModel.title),
                  SizedBox(height: Margins.spacing_m),
                  _OnboardingBodyText(viewModel.body),
                  SizedBox(height: Margins.spacing_xl),
                  PrimaryActionButton(
                    label: Strings.gotIt,
                    onPressed: () {
                      Navigator.of(context).pop();
                      viewModel.onGotIt();
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: Margins.spacing_base),
          ],
        ),
      ),
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
