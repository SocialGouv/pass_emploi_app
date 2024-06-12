import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/network/post_evenement_engagement.dart';
import 'package:pass_emploi_app/presentation/call_to_action.dart';
import 'package:pass_emploi_app/presentation/immersion/immersion_contact_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/context_extensions.dart';
import 'package:pass_emploi_app/utils/launcher_utils.dart';
import 'package:pass_emploi_app/utils/platform.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';

class ImmersionContactBottomSheet extends StatelessWidget {
  static Future<void> show(BuildContext context) {
    return showPassEmploiBottomSheet(
      context: context,
      builder: (context) => ImmersionContactBottomSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final platform = PlatformUtils.getPlatform;
    return Tracker(
      tracking: AnalyticsScreenNames.immersionContact,
      child: StoreConnector<AppState, ImmersionContactViewModel>(
        onInitialBuild: (_) => context.trackEvenementEngagement(EvenementEngagement.OFFRE_IMMERSION_CONTACT_AFFICHEE),
        converter: (store) => ImmersionContactViewModel.create(store: store, platform: platform),
        builder: (context, viewModel) => _Content(viewModel.callToAction),
        distinct: true,
      ),
    );
  }
}

class _Content extends StatelessWidget {
  const _Content(this.callToAction);

  final CallToAction callToAction;

  @override
  Widget build(BuildContext context) {
    return BottomSheetWrapper(
      title: Strings.offreDetails,
      padding: EdgeInsets.symmetric(horizontal: Margins.spacing_m),
      body: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              _InstructionsText(),
              SizedBox(height: 160),
            ],
          ),
        ),
        floatingActionButton: _ContactButton(callToAction),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}

class _InstructionsText extends StatelessWidget {
  const _InstructionsText();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(Strings.immersionContactTitle, style: TextStyles.textLBold()),
        SizedBox(height: Margins.spacing_base),
        _Subtitle(text: Strings.immersionContactSubtitle1),
        SizedBox(height: Margins.spacing_base),
        RichText(
          text: TextSpan(
            text: Strings.immersionContactBody1_1,
            style: TextStyles.textBaseRegular,
            children: [
              TextSpan(
                text: Strings.immersionContactBody1_2bold,
                style: TextStyles.textBaseBold,
              ),
              TextSpan(
                text: Strings.immersionContactBody1_3,
              ),
              TextSpan(
                text: Strings.immersionContactBody1_4bold,
                style: TextStyles.textBaseBold,
              ),
              TextSpan(
                text: Strings.immersionContactBody1_5,
              ),
              TextSpan(
                text: Strings.immersionContactBody1_6,
              ),
              TextSpan(
                text: Strings.immersionContactBody1_7bold,
                style: TextStyles.textBaseBold,
              ),
              TextSpan(
                text: Strings.immersionContactBody1_8,
              ),
              TextSpan(
                text: Strings.immersionContactBody1_9bold,
                style: TextStyles.textBaseBold,
              ),
              TextSpan(
                text: Strings.immersionContactBody1_10,
              ),
              TextSpan(
                text: Strings.immersionContactBody1_11,
              ),
              TextSpan(
                text: Strings.immersionContactBody1_12,
              ),
            ],
          ),
        ),
        SizedBox(height: Margins.spacing_base),
        _Subtitle(text: Strings.immersionContactSubtitle2),
        SizedBox(height: Margins.spacing_base),
        Text(Strings.immersionContactBody2, style: TextStyles.textBaseRegular),
        SizedBox(height: Margins.spacing_base),
        _Subtitle(text: Strings.immersionContactSubtitle3),
        SizedBox(height: Margins.spacing_base),
        Text(Strings.immersionContactBody3, style: TextStyles.textBaseRegular),
        SizedBox(height: Margins.spacing_base),
        _Subtitle(text: Strings.immersionContactSubtitle4),
        SizedBox(height: Margins.spacing_base),
        Text(Strings.immersionContactBody4, style: TextStyles.textBaseRegular),
      ],
    );
  }
}

class _Subtitle extends StatelessWidget {
  final String text;

  const _Subtitle({required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: Margins.spacing_base),
            Expanded(child: Text(text, style: TextStyles.textMBold))
          ],
        ),
        SizedBox(height: Margins.spacing_base),
        Divider(height: 1),
      ],
    );
  }
}

class _ContactButton extends StatelessWidget {
  const _ContactButton(this.callToAction);

  final CallToAction callToAction;

  @override
  Widget build(BuildContext context) {
    return PrimaryActionButton(
      onPressed: () {
        context.trackEvenementEngagement(callToAction.eventType);
        launchExternalUrl(callToAction.uri.toString());
      },
      label: callToAction.label,
    );
  }
}
