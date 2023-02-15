import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/presentation/immersion_details_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/context_extensions.dart';
import 'package:pass_emploi_app/utils/launcher_utils.dart';
import 'package:pass_emploi_app/utils/platform.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/retry.dart';

class ImmersionContactPage extends StatelessWidget {
  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(
      builder: (context) => ImmersionContactPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final platform = io.Platform.isAndroid ? Platform.ANDROID : Platform.IOS;
    return Tracker(
      tracking: AnalyticsScreenNames.immersionContact,
      child: StoreConnector<AppState, ImmersionDetailsViewModel>(
        onInitialBuild: (_) {
          context.trackEvent(EventType.OFFRE_IMMERSION_CONTACT_AFFICHEE);
        },
        converter: (store) => ImmersionDetailsViewModel.create(store, platform),
        builder: (context, viewModel) => _Body(viewModel),
        distinct: true,
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body(this.viewModel);
  final ImmersionDetailsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    switch (viewModel.displayState) {
      case ImmersionDetailsPageDisplayState.SHOW_DETAILS:
      case ImmersionDetailsPageDisplayState.SHOW_INCOMPLETE_DETAILS:
        return _Content(viewModel);
      case ImmersionDetailsPageDisplayState.SHOW_LOADER:
        return _Loading();
      case ImmersionDetailsPageDisplayState.SHOW_ERROR:
        return _Retry(viewModel);
    }
  }
}

class _Loading extends StatelessWidget {
  const _Loading();

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator(color: AppColors.nightBlue));
  }
}

class _Retry extends StatelessWidget {
  final ImmersionDetailsViewModel viewModel;
  const _Retry(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return Center(child: Retry(Strings.offreDetailsError, () => viewModel.onRetry(viewModel.id)));
  }
}

class _Content extends StatelessWidget {
  const _Content(this.viewModel);
  final ImmersionDetailsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    const backgroundColor = Colors.white;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: SecondaryAppBar(title: Strings.offreDetails, backgroundColor: backgroundColor),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_m),
          child: Column(
            children: [
              _InstructionsText(),
              SizedBox(height: 160),
            ],
          ),
        ),
      ),
      floatingActionButton: _ContactButton(viewModel),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
  const _Subtitle({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

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
                color: AppColors.nightBlue,
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
  const _ContactButton(this.viewModel);
  final ImmersionDetailsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return PrimaryActionButton(
      onPressed: () {
        context.trackEvent(viewModel.mainCallToAction!.eventType);
        launchExternalUrl(viewModel.mainCallToAction!.uri.toString());
      },
      label: viewModel.mainCallToAction!.label,
    );
  }
}
