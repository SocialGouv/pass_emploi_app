import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/presentation/call_to_action.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/immersion_details_view_model.dart';
import 'package:pass_emploi_app/redux/actions/named_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/context_extensions.dart';
import 'package:pass_emploi_app/utils/platform.dart';
import 'package:pass_emploi_app/widgets/default_animated_switcher.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/immersion_tags.dart';
import 'package:pass_emploi_app/widgets/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/retry.dart';
import 'package:pass_emploi_app/widgets/secondary_button.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';
import 'package:pass_emploi_app/widgets/title_section.dart';
import 'package:url_launcher/url_launcher.dart';

class ImmersionDetailsPage extends TraceableStatelessWidget {
  final String _immersionId;

  ImmersionDetailsPage._(this._immersionId) : super(name: AnalyticsScreenNames.immersionDetails);

  static MaterialPageRoute materialPageRoute(String id) {
    return MaterialPageRoute(builder: (context) => ImmersionDetailsPage._(id));
  }

  @override
  Widget build(BuildContext context) {
    final platform = io.Platform.isAndroid ? Platform.ANDROID : Platform.IOS;
    return StoreConnector<AppState, ImmersionDetailsViewModel>(
      onInit: (store) => store.dispatch(ImmersionDetailsAction.request(_immersionId)),
      onDispose: (store) => store.dispatch(ImmersionDetailsAction.reset()),
      converter: (store) => ImmersionDetailsViewModel.create(store, platform),
      builder: (context, viewModel) => _scaffold(_body(context, viewModel)),
      distinct: true,
    );
  }

  Widget _body(BuildContext context, ImmersionDetailsViewModel viewModel) {
    switch (viewModel.displayState) {
      case DisplayState.CONTENT:
        return _content(context, viewModel);
      case DisplayState.LOADING:
        return _loading();
      default:
        return Retry(Strings.offreDetailsError, () => viewModel.onRetry(_immersionId));
    }
  }

  Scaffold _scaffold(Widget body) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: passEmploiAppBar(label: Strings.offreDetails, withBackButton: true),
      body: Center(child: DefaultAnimatedSwitcher(child: body)),
    );
  }

  Widget _loading() => CircularProgressIndicator(color: AppColors.nightBlue);

  Widget _content(BuildContext context, ImmersionDetailsViewModel viewModel) {
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(Margins.spacing_base, Margins.spacing_base, Margins.spacing_base, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(viewModel.title, style: TextStyles.textLBold()),
                SizedBox(height: 20),
                Text(viewModel.companyName, style: TextStyles.textBaseRegular),
                SizedBox(height: 20),
                ImmersionTags(secteurActivite: viewModel.secteurActivite, ville: viewModel.ville),
                SizedBox(height: 20),
                Text(viewModel.explanationLabel, style: TextStyles.textBaseRegular),
                SizedBox(height: 20),
                Text(Strings.immersionDescriptionLabel, style: TextStyles.textBaseRegular),
                SizedBox(height: 20),
                _contactBlock(viewModel),
                if (viewModel.withSecondaryCallToActions) ..._secondaryCallToActions(context, viewModel),
              ],
            ),
          ),
        ),
        if (viewModel.withMainCallToAction)
          Align(child: _footer(context, viewModel.mainCallToAction!), alignment: Alignment.bottomCenter)
      ],
    );
  }

  Widget _contactBlock(ImmersionDetailsViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleSection(label: Strings.immersionContactTitle),
        if (viewModel.contactLabel.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Text(viewModel.contactLabel, style: TextStyles.textBaseBold),
          ),
        Text(viewModel.contactInformation, style: TextStyles.textBaseRegular),
      ],
    );
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');
  }

  Widget _footer(BuildContext context, CallToAction callToAction) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: double.infinity),
        child: PrimaryActionButton(
            onPressed: () {
              context.trackEvent(callToAction.eventType);
              launch(callToAction.uri.toString());
            },
            label: callToAction.label),
      ),
    );
  }

  List<Widget> _secondaryCallToActions(BuildContext context, ImmersionDetailsViewModel viewModel) {
    final buttons = viewModel.secondaryCallToActions.map((cta) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: SecondaryButton(
          label: cta.label,
          drawableRes: cta.drawableRes,
          onPressed: () {
            context.trackEvent(cta.eventType);
            launch(cta.uri.toString());
          },
        ),
      );
    }).toList();
    return [SepLine(24, 20), ...buttons];
  }
}
