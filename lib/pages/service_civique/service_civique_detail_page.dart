import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:matomo/matomo.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/features/service_civique/detail/service_civique_detail_actions.dart';
import 'package:pass_emploi_app/models/service_civique/service_civique_detail.dart';
import 'package:pass_emploi_app/network/post_tracking_event_request.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/utils/context_extensions.dart';
import 'package:pass_emploi_app/widgets/external_link.dart';
import 'package:pass_emploi_app/widgets/favori_state_selector.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../presentation/service_civique/service_civique_detail_view_model.dart';
import '../../ui/app_colors.dart';
import '../../ui/drawables.dart';
import '../../ui/margins.dart';
import '../../ui/strings.dart';
import '../../ui/text_styles.dart';
import '../../widgets/buttons/primary_action_button.dart';
import '../../widgets/buttons/share_button.dart';
import '../../widgets/default_app_bar.dart';
import '../../widgets/tags/tags.dart';
import '../../widgets/title_section.dart';

class ServiceCiviqueDetailPage extends TraceableStatelessWidget {
  final String idOffre;

  ServiceCiviqueDetailPage(this.idOffre) : super(name: AnalyticsScreenNames.serviceCiviqueDetail);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ServiceCiviqueDetailViewModel>(
      onInit: (store) => store.dispatch(GetServiceCiviqueDetailAction(idOffre)),
      converter: (store) => ServiceCiviqueDetailViewModel.create(store),
      builder: (context, viewModel) {
        return FavorisStateContext(
          child: _scaffold(_body(context, viewModel)),
          selectState: (store) => store.state.offreEmploiFavorisState,
        );
      },
    );
  }

  Scaffold _scaffold(Widget body) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: passEmploiAppBar(label: Strings.serviceCiviqueDetailTitle, withBackButton: true),
      body: body,
    );
  }

  Widget _body(BuildContext context, ServiceCiviqueDetailViewModel viewModel) {
    switch (viewModel.displayState) {
      case DisplayState.CONTENT:
        return _content(context, viewModel);
      case DisplayState.LOADING:
        return _loading();
      case DisplayState.EMPTY:
      case DisplayState.FAILURE:
        return _error();
    }
  }

  Widget _loading() => Center(child: CircularProgressIndicator(color: AppColors.primary));

  Widget _error() => Center(child: Text(Strings.offreDetailsError));

  Widget _content(BuildContext context, ServiceCiviqueDetailViewModel viewModel) {
    final ServiceCiviqueDetail detail = viewModel.detail!;
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(Margins.spacing_m, Margins.spacing_m, Margins.spacing_m, 64),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(detail.domaine, style: TextStyles.textBaseRegular),
                _spacer(Margins.spacing_s),
                Padding(
                  padding: const EdgeInsets.only(bottom: Margins.spacing_s),
                  child: Text(detail.titre, style: TextStyles.textMBold),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: Margins.spacing_m),
                  child: Text(detail.organisation, style: TextStyles.textBaseRegular),
                ),
                _tags(detail),
                if (detail.description != null) _description(detail.description!),
                _organisation(detail),
                _spacer(60),
              ],
            ),
          ),
        ),
        if (detail.lienAnnonce != null)
          Align(
            child: _footer(context, detail.lienAnnonce!, detail.titre),
            alignment: Alignment.bottomCenter,
          )
      ],
    );
  }

  Widget _spacer(double _height) => SizedBox(height: _height);

  Widget _tags(ServiceCiviqueDetail detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: Margins.spacing_base),
          child: DataTag(
              label: detail.codeDepartement != null ? "${detail.codeDepartement} - ${detail.ville}" : detail.ville,
              drawableRes: Drawables.icPlace),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: Margins.spacing_base),
          child: DataTag(label: "Commence le ${detail.dateDeDebut}", drawableRes: Drawables.icCalendar),
        ),
        if (detail.dateDeFin != null)
          Padding(
            padding: const EdgeInsets.only(bottom: Margins.spacing_base),
            child: DataTag(label: "Termine le ${detail.dateDeFin}", drawableRes: Drawables.icCalendar),
          ),
      ],
    );
  }

  Widget _description(String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TitleSection(label: Strings.serviceCiviqueMissionTitle),
        _spacer(Margins.spacing_m),
        Text(
          description,
          style: TextStyles.textBaseRegular,
        ),
        _spacer(Margins.spacing_m),
      ],
    );
  }

  Widget _organisation(ServiceCiviqueDetail detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TitleSection(label: Strings.serviceCiviqueOrganisationTitle),
        _spacer(Margins.spacing_m),
        Text(
          detail.organisation,
          style: TextStyles.textBaseBold,
        ),
        if (detail.urlOrganisation != null) _spacer(Margins.spacing_s),
        if (detail.urlOrganisation != null)
          ExternalLink(
            label: detail.urlOrganisation!,
            url: detail.urlOrganisation!,
          ),
        if (detail.adresseOrganisation != null) _spacer(Margins.spacing_s),
        if (detail.adresseOrganisation != null)
          Text(
            detail.adresseOrganisation!,
            style: TextStyles.textBaseRegular,
          ),
        if (detail.descriptionOrganisation != null)
          Text(
            detail.descriptionOrganisation!,
            style: TextStyles.textBaseRegular,
          ),
      ],
    );
  }

  Widget _footer(BuildContext context, String url, String? title) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(Margins.spacing_base),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: PrimaryActionButton(
              onPressed: () => _applyToOffer(context, url),
              label: Strings.postulerButtonTitle,
            ),
          ),
          SizedBox(width: Margins.spacing_base),
          ShareButton(url, title, () => _shareOffer(context)),
        ],
      ),
    );
  }

  void _applyToOffer(BuildContext context, String url) {
    launch(url);
    context.trackEvent(_postulerEvent());
  }

  void _shareOffer(BuildContext context) => context.trackEvent(_partagerEvent());

  EventType _partagerEvent() => EventType.OFFRE_SERVICE_CIVIQUE_PARTAGEE;

  EventType _postulerEvent() => EventType.OFFRE_SERVICE_CIVIQUE_POSTULEE;
}
