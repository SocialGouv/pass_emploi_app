import 'dart:io' as io;

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/immersion.dart';
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
import 'package:pass_emploi_app/widgets/buttons/delete_favori_button.dart';
import 'package:pass_emploi_app/widgets/favori_heart.dart';
import 'package:pass_emploi_app/widgets/errors/favori_not_found_error.dart';
import 'package:pass_emploi_app/widgets/favori_state_selector.dart';
import 'package:pass_emploi_app/widgets/tags/immersion_tags.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/retry.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';
import 'package:pass_emploi_app/widgets/title_section.dart';
import 'package:url_launcher/url_launcher.dart';

import 'offre_page.dart';

class ImmersionDetailsPage extends TraceableStatelessWidget {
  final String _immersionId;
  final bool popPageWhenFavoriIsRemoved;

  ImmersionDetailsPage._(
    this._immersionId, {
    this.popPageWhenFavoriIsRemoved = false,
  }) : super(name: AnalyticsScreenNames.immersionDetails);

  static MaterialPageRoute materialPageRoute(
    String id, {
    bool popPageWhenFavoriIsRemoved = false,
  }) {
    return MaterialPageRoute(
      builder: (context) => ImmersionDetailsPage._(
        id,
        popPageWhenFavoriIsRemoved: popPageWhenFavoriIsRemoved,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final platform = io.Platform.isAndroid ? Platform.ANDROID : Platform.IOS;
    return StoreConnector<AppState, ImmersionDetailsViewModel>(
      onInit: (store) => store.dispatch(ImmersionDetailsAction.request(_immersionId)),
      onDispose: (store) => store.dispatch(ImmersionDetailsAction.reset()),
      converter: (store) => ImmersionDetailsViewModel.create(store, platform),
      builder: (context, viewModel) => FavorisStateContext(
        selectState: (store) => store.state.immersionFavorisState,
        child: _scaffold(_body(context, viewModel)),
      ),
      distinct: true,
    );
  }

  Widget _body(BuildContext context, ImmersionDetailsViewModel viewModel) {
    switch (viewModel.displayState) {
      case ImmersionDetailsPageDisplayState.SHOW_DETAILS:
      case ImmersionDetailsPageDisplayState.SHOW_INCOMPLETE_DETAILS:
        return _content(context, viewModel);
      case ImmersionDetailsPageDisplayState.SHOW_LOADER:
        return _loading();
      case ImmersionDetailsPageDisplayState.SHOW_ERROR:
        return _retry(viewModel);
    }
  }

  Scaffold _scaffold(Widget body) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: passEmploiAppBar(label: Strings.offreDetails, withBackButton: true),
      body: DefaultAnimatedSwitcher(child: body),
    );
  }

  Widget _loading() => Center(child: CircularProgressIndicator(color: AppColors.nightBlue));

  Center _retry(ImmersionDetailsViewModel viewModel) =>
      Center(child: Retry(Strings.offreDetailsError, () => viewModel.onRetry(_immersionId)));

  Widget _content(BuildContext context, ImmersionDetailsViewModel viewModel) {
    final explanationLabel = viewModel.explanationLabel;
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(Margins.spacing_base, Margins.spacing_base, Margins.spacing_base, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(viewModel.title, style: TextStyles.textLBold()),
                SizedBox(height: Margins.spacing_m),
                Text(viewModel.companyName, style: TextStyles.textBaseRegular),
                SizedBox(height: Margins.spacing_m),
                ImmersionTags(secteurActivite: viewModel.secteurActivite, ville: viewModel.ville),
                SizedBox(height: Margins.spacing_l),
                if (viewModel.displayState == ImmersionDetailsPageDisplayState.SHOW_INCOMPLETE_DETAILS)
                  FavoriNotFoundError()
                else ...[
                  if (explanationLabel != null) ...[
                    Text(explanationLabel, style: TextStyles.textBaseRegular),
                    SizedBox(height: Margins.spacing_m),
                  ],
                  Text(Strings.immersionDescriptionLabel, style: TextStyles.textBaseRegular),
                  SizedBox(height: Margins.spacing_m),
                  _contactBlock(viewModel),
                  if (viewModel.withSecondaryCallToActions == true) ..._secondaryCallToActions(context, viewModel),
                ]
              ],
            ),
          ),
        ),
        if (viewModel.displayState == ImmersionDetailsPageDisplayState.SHOW_INCOMPLETE_DETAILS)
          Align(
            child: _incompleteDataFooter(viewModel),
            alignment: Alignment.bottomCenter,
          )
        else
          Align(child: _footer(context, viewModel), alignment: Alignment.bottomCenter)
      ],
    );
  }

  Padding _incompleteDataFooter(ImmersionDetailsViewModel viewModel) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(child: DeleteFavoriButton<Immersion>(offreId: viewModel.id, from: OffrePage.immersionDetails)),
        ],
      ),
    );
  }

  Widget _contactBlock(ImmersionDetailsViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleSection(label: Strings.immersionContactTitle),
        if (viewModel.contactLabel!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Margins.spacing_m),
            child: Text(viewModel.contactLabel!, style: TextStyles.textBaseBold),
          ),
        SizedBox(height: Margins.spacing_m),
        Text(viewModel.contactInformation!, style: TextStyles.textBaseRegular),
      ],
    );
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries.map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}').join('&');
  }

  Widget _footer(BuildContext context, ImmersionDetailsViewModel viewModel) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(Margins.spacing_base),
      child: Row(
        children: [
          Expanded(
            child: PrimaryActionButton(
              onPressed: () {
                context.trackEvent(viewModel.mainCallToAction!.eventType);
                launch(viewModel.mainCallToAction!.uri.toString());
              },
              label: viewModel.mainCallToAction!.label,
            ),
          ),
          SizedBox(width: 16),
          FavoriHeart<Immersion>(
            offreId: viewModel.id,
            withBorder: true,
            from: OffrePage.immersionDetails,
            onFavoriRemoved: popPageWhenFavoriIsRemoved ? () => Navigator.pop(context) : null,
          ),
        ],
      ),
    );
  }

  List<Widget> _secondaryCallToActions(BuildContext context, ImmersionDetailsViewModel viewModel) {
    final buttons = viewModel.secondaryCallToActions!.map((cta) {
      return Padding(
        padding: const EdgeInsets.only(bottom: Margins.spacing_m),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: double.infinity),
          child: SecondaryButton(
            label: cta.label,
            drawableRes: cta.drawableRes,
            onPressed: () {
              context.trackEvent(cta.eventType);
              launch(cta.uri.toString());
            },
          ),
        ),
      );
    }).toList();
    return [SepLine(Margins.spacing_m, Margins.spacing_m), ...buttons];
  }
}
