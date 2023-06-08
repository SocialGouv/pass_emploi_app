import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/immersion/details/immersion_details_actions.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/pages/immersion/immersion_contact_form_page.dart';
import 'package:pass_emploi_app/pages/immersion/immersion_contact_page.dart';
import 'package:pass_emploi_app/pages/offre_page.dart';
import 'package:pass_emploi_app/presentation/immersion/immersion_details_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/context_extensions.dart';
import 'package:pass_emploi_app/utils/launcher_utils.dart';
import 'package:pass_emploi_app/utils/platform.dart';
import 'package:pass_emploi_app/widgets/buttons/delete_favori_button.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/default_animated_switcher.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/errors/favori_not_found_error.dart';
import 'package:pass_emploi_app/widgets/favori_heart.dart';
import 'package:pass_emploi_app/widgets/favori_state_selector.dart';
import 'package:pass_emploi_app/widgets/retry.dart';
import 'package:pass_emploi_app/widgets/sepline.dart';
import 'package:pass_emploi_app/widgets/tags/entreprise_accueillante_tag.dart';
import 'package:pass_emploi_app/widgets/tags/immersion_tags.dart';
import 'package:pass_emploi_app/widgets/title_section.dart';

class ImmersionDetailsPage extends StatelessWidget {
  final String _immersionId;
  final bool popPageWhenFavoriIsRemoved;

  ImmersionDetailsPage._(
    this._immersionId, {
    this.popPageWhenFavoriIsRemoved = false,
  });

  static MaterialPageRoute<void> materialPageRoute(String id, {bool popPageWhenFavoriIsRemoved = false}) {
    return MaterialPageRoute(
      builder: (context) => ImmersionDetailsPage._(id, popPageWhenFavoriIsRemoved: popPageWhenFavoriIsRemoved),
    );
  }

  @override
  Widget build(BuildContext context) {
    final platform = PlatformUtils.getPlatform;
    return Tracker(
      tracking: AnalyticsScreenNames.immersionDetails,
      child: StoreConnector<AppState, ImmersionDetailsViewModel>(
        onInit: (store) => store.dispatch(ImmersionDetailsRequestAction(_immersionId)),
        onInitialBuild: (_) {
          context.trackEvent(EventType.OFFRE_IMMERSION_AFFICHEE);
        },
        onDispose: (store) => store.dispatch(ImmersionDetailsResetAction()),
        converter: (store) => ImmersionDetailsViewModel.create(store, platform),
        builder: (context, viewModel) => FavorisStateContext(
          selectState: (store) => store.state.immersionFavorisIdsState,
          child: _scaffold(_body(context, viewModel), context),
        ),
        distinct: true,
      ),
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

  Scaffold _scaffold(Widget body, BuildContext context) {
    const backgroundColor = Colors.white;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: SecondaryAppBar(title: Strings.offreDetails, backgroundColor: backgroundColor),
      body: DefaultAnimatedSwitcher(child: body),
    );
  }

  Widget _loading() => Center(child: CircularProgressIndicator(color: AppColors.nightBlue));

  Center _retry(ImmersionDetailsViewModel viewModel) =>
      Center(child: Retry(Strings.offreDetailsError, () => viewModel.onRetry(_immersionId)));

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
                SizedBox(height: Margins.spacing_m),
                Text(viewModel.companyName, style: TextStyles.textBaseRegular),
                SizedBox(height: Margins.spacing_base),
                ImmersionTags(secteurActivite: viewModel.secteurActivite, ville: viewModel.ville),
                SizedBox(height: Margins.spacing_base),
                if (viewModel.displayState == ImmersionDetailsPageDisplayState.SHOW_INCOMPLETE_DETAILS)
                  FavoriNotFoundError()
                else ...[
                  if (viewModel.fromEntrepriseAccueillante) _EntrepriseAccueillanteCard(),
                  if (!viewModel.fromEntrepriseAccueillante)
                    Text(Strings.immersionNonAccueillanteExplanation, style: TextStyles.textBaseRegular),
                  SizedBox(height: Margins.spacing_m),
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
            alignment: Alignment.bottomCenter,
            child: _incompleteDataFooter(viewModel),
          )
        else
          Align(
            alignment: Alignment.bottomCenter,
            child: _footer(context, viewModel),
          )
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
        TitleSection(label: Strings.immersionContactBlocTitle),
        if (viewModel.contactLabel!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: Margins.spacing_m),
            child: Text(viewModel.contactLabel!, style: TextStyles.textBaseBold),
          ),
        SizedBox(height: Margins.spacing_m),
        Text(viewModel.contactInformation!, style: TextStyles.textBaseRegular),
        SizedBox(height: Margins.spacing_base),
        if (viewModel.withDataWarningMessage) _DataWarningMessage(),
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
              viewModel.withContactForm
                  ? Navigator.push(context, ImmersionContactFormPage.materialPageRoute())
                  : Navigator.push(context, ImmersionContactPage.materialPageRoute());
            },
            label: Strings.immersionContact,
          )),
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
            icon: cta.icon,
            onPressed: () {
              context.trackEvent(cta.eventType);
              launchExternalUrl(cta.uri.toString());
            },
          ),
        ),
      );
    }).toList();
    return [SepLine(Margins.spacing_m, Margins.spacing_m), ...buttons];
  }
}

class _EntrepriseAccueillanteCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          EntrepriseAccueillanteTag(),
          SizedBox(height: Margins.spacing_s),
          Text(Strings.immersionAccueillanteExplanation, style: TextStyles.textSRegular()),
        ],
      ),
    );
  }
}

class _DataWarningMessage extends StatelessWidget {
  const _DataWarningMessage();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(Margins.spacing_m),
      decoration: BoxDecoration(
        color: AppColors.primaryLighten,
        borderRadius: BorderRadius.circular(Dimens.radius_base),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(AppIcons.info_rounded, color: AppColors.primary, size: Dimens.icon_size_m),
          SizedBox(width: Margins.spacing_s),
          Expanded(
              child: Text(Strings.immersionDataWarningMessage,
                  style: TextStyles.textBaseBold.copyWith(color: AppColors.primary))),
        ],
      ),
    );
  }
}
