import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/features/service_civique/detail/service_civique_detail_actions.dart';
import 'package:pass_emploi_app/models/service_civique.dart';
import 'package:pass_emploi_app/models/service_civique/domain.dart';
import 'package:pass_emploi_app/models/service_civique/service_civique_detail.dart';
import 'package:pass_emploi_app/network/post_evenement_engagement.dart';
import 'package:pass_emploi_app/pages/offre_page.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/service_civique/service_civique_detail_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/context_extensions.dart';
import 'package:pass_emploi_app/utils/launcher_utils.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/postuler_offre_bottom_sheet.dart';
import 'package:pass_emploi_app/widgets/buttons/delete_favori_button.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/share_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/errors/favori_not_found_error.dart';
import 'package:pass_emploi_app/widgets/external_link.dart';
import 'package:pass_emploi_app/widgets/favori_heart.dart';
import 'package:pass_emploi_app/widgets/favori_state_selector.dart';
import 'package:pass_emploi_app/widgets/tags/tags.dart';
import 'package:pass_emploi_app/widgets/title_section.dart';

class ServiceCiviqueDetailPage extends StatelessWidget {
  final String idOffre;
  final bool popPageWhenFavoriIsRemoved;

  ServiceCiviqueDetailPage(this.idOffre, [this.popPageWhenFavoriIsRemoved = false]);

  static MaterialPageRoute<void> materialPageRoute(String idOffre, [bool popPageWhenFavoriIsRemoved = false]) {
    return MaterialPageRoute(
      builder: (context) => ServiceCiviqueDetailPage(idOffre, popPageWhenFavoriIsRemoved),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.serviceCiviqueDetail,
      child: StoreConnector<AppState, ServiceCiviqueDetailViewModel>(
        onInit: (store) => store.dispatch(GetServiceCiviqueDetailAction(idOffre)),
        onInitialBuild: (_) {
          context.trackEvenementEngagement(EvenementEngagement.OFFRE_SERVICE_CIVIQUE_AFFICHEE);
        },
        converter: (store) => ServiceCiviqueDetailViewModel.create(store),
        builder: (context, viewModel) {
          return FavorisStateContext(
            child: _scaffold(_body(context, viewModel), context),
            selectState: (store) => store.state.serviceCiviqueFavorisIdsState,
          );
        },
      ),
    );
  }

  Scaffold _scaffold(Widget body, BuildContext context) {
    const backgroundColor = Colors.white;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: SecondaryAppBar(title: Strings.serviceCiviqueDetailTitle, backgroundColor: backgroundColor),
      body: body,
    );
  }

  Widget _body(BuildContext context, ServiceCiviqueDetailViewModel viewModel) {
    switch (viewModel.displayState) {
      case DisplayState.CONTENT:
      case DisplayState.EMPTY:
        return _content(context, viewModel);
      case DisplayState.LOADING:
        return _loading();
      case DisplayState.FAILURE:
        return _error();
    }
  }

  Widget _loading() => Center(child: CircularProgressIndicator(color: AppColors.primary));

  Widget _error() => Center(child: Text(Strings.offreDetailsError));

  Widget _content(BuildContext context, ServiceCiviqueDetailViewModel viewModel) {
    final ServiceCiviqueDetail? detail = viewModel.detail;
    final ServiceCivique? serviceCivique = viewModel.serviceCivique;
    final String organisation = detail?.organisation ?? serviceCivique?.companyName ?? "";
    final String titre = detail?.titre ?? serviceCivique?.title ?? "";
    final String domaine =
        Domaine.fromTag(detail?.domaine)?.titre ?? Domaine.fromTag(serviceCivique?.domain)?.titre ?? "";
    return Stack(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(Margins.spacing_m, Margins.spacing_m, Margins.spacing_m, 64),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (viewModel.displayState == DisplayState.EMPTY)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: FavoriNotFoundError(),
                  ),
                Text(domaine, style: TextStyles.textBaseRegular),
                _spacer(Margins.spacing_s),
                Padding(
                  padding: const EdgeInsets.only(bottom: Margins.spacing_s),
                  child: Text(titre, style: TextStyles.textMBold),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: Margins.spacing_m),
                  child: Text(organisation, style: TextStyles.textBaseRegular),
                ),
                if (detail != null) _tags(detail),
                if (detail != null) _description(detail),
                if (detail != null) _organisation(detail),
                if (detail != null) _spacer(60),
                if (viewModel.displayState == DisplayState.EMPTY)
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _incompleteDataFooter(),
                  )
              ],
            ),
          ),
        ),
        if (detail?.lienAnnonce != null)
          Align(
            alignment: Alignment.bottomCenter,
            child: _footer(context, detail!.lienAnnonce!, detail.titre, viewModel.shouldShowCvBottomSheet),
          )
      ],
    );
  }

  Widget _spacer(double height) => SizedBox(height: height);

  Widget _tags(ServiceCiviqueDetail detail) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: Margins.spacing_base),
          child: DataTag(
              label: detail.codeDepartement != null ? "${detail.codeDepartement} - ${detail.ville}" : detail.ville,
              iconSemantics: IconWithSemantics(AppIcons.place_outlined, Strings.iconAlternativeLocation)),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: Margins.spacing_base),
          child: DataTag(
              label: "Commence le ${detail.dateDeDebut}",
              iconSemantics: IconWithSemantics(AppIcons.today_rounded, Strings.iconAlternativeDateDeDebut)),
        ),
        if (detail.dateDeFin != null)
          Padding(
            padding: const EdgeInsets.only(bottom: Margins.spacing_base),
            child: DataTag(
                label: "Termine le ${detail.dateDeFin}",
                iconSemantics: IconWithSemantics(AppIcons.today_rounded, Strings.iconAlternativeDateDeFin)),
          ),
      ],
    );
  }

  Widget _description(ServiceCiviqueDetail detail) {
    final String missionFullAdresse = detail.adresseMission != null && detail.codePostal != null
        ? "${detail.adresseMission!}, ${detail.codePostal!} ${detail.ville}"
        : detail.ville;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TitleSection(label: Strings.serviceCiviqueMissionTitle),
        _spacer(Margins.spacing_m),
        Text(
          missionFullAdresse,
          style: TextStyles.textBaseRegular,
        ),
        if (detail.description != null) _spacer(Margins.spacing_s),
        if (detail.description != null)
          Text(
            detail.description!,
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
        if (detail.descriptionOrganisation != null) _spacer(Margins.spacing_s),
        if (detail.descriptionOrganisation != null)
          Text(
            detail.descriptionOrganisation!,
            style: TextStyles.textBaseRegular,
          ),
      ],
    );
  }

  Widget _footer(BuildContext context, String url, String? title, bool shouldShowCvBottomSheet) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(Margins.spacing_base),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: Semantics(
              link: true,
              child: PrimaryActionButton(
                label: Strings.postulerButtonTitle,
                onPressed: () {
                  if (shouldShowCvBottomSheet) {
                    showPassEmploiBottomSheet(
                      context: context,
                      builder: (context) => PostulerOffreBottomSheet(
                        onPostuler: () => _applyToOffer(context, url),
                      ),
                    );
                  } else {
                    _applyToOffer(context, url);
                  }
                },
                icon: shouldShowCvBottomSheet ? null : AppIcons.open_in_new_rounded,
                iconLabel: Strings.link,
              ),
            ),
          ),
          SizedBox(width: Margins.spacing_base),
          FavoriHeart<ServiceCivique>(
            offreId: idOffre,
            withBorder: true,
            from: OffrePage.serviceCiviqueDetails,
            onFavoriRemoved: popPageWhenFavoriIsRemoved ? () => Navigator.pop(context) : null,
          ),
          SizedBox(width: Margins.spacing_base),
          ShareButton(
            textToShare: url,
            semanticsLabel: Strings.a11yPartagerOffreLabel,
            subjectForEmail: title,
            onPressed: () => _shareOffer(context),
          ),
        ],
      ),
    );
  }

  void _applyToOffer(BuildContext context, String url) {
    launchExternalUrl(url);
    context.trackEvenementEngagement(_postulerEvent());
  }

  void _shareOffer(BuildContext context) => context.trackEvenementEngagement(_partagerEvent());

  EvenementEngagement _partagerEvent() => EvenementEngagement.OFFRE_SERVICE_CIVIQUE_PARTAGEE;

  EvenementEngagement _postulerEvent() => EvenementEngagement.OFFRE_SERVICE_CIVIQUE_POSTULEE;

  Padding _incompleteDataFooter() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(child: DeleteFavoriButton<ServiceCivique>(offreId: idOffre, from: OffrePage.serviceCiviqueDetails)),
        ],
      ),
    );
  }
}
