import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/analytics/tracker.dart';
import 'package:pass_emploi_app/models/immersion.dart';
import 'package:pass_emploi_app/pages/immersion_details_page.dart';
import 'package:pass_emploi_app/pages/immersion_filtres_page.dart';
import 'package:pass_emploi_app/pages/offre_page.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/immersion/immersion_search_results_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/bottom_sheets.dart';
import 'package:pass_emploi_app/widgets/bottom_sheets/immersion_saved_search_bottom_sheet.dart';
import 'package:pass_emploi_app/widgets/buttons/filtre_button.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/cards/data_card.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/empty_offre_widget.dart';
import 'package:pass_emploi_app/widgets/favori_state_selector.dart';
import 'package:pass_emploi_app/widgets/tags/entreprise_accueillante_tag.dart';

class ImmersionListPage extends StatelessWidget {
  final bool fromSavedSearch;

  ImmersionListPage([this.fromSavedSearch = false]);

  @override
  Widget build(BuildContext context) {
    return Tracker(
      tracking: AnalyticsScreenNames.immersionResults,
      child: StoreConnector<AppState, ImmersionSearchResultsViewModel>(
        converter: (store) => ImmersionSearchResultsViewModel.create(store),
        builder: (context, viewModel) {
          const backgroundColor = AppColors.grey100;
          return FavorisStateContext<Immersion>(
            selectState: (store) => store.state.immersionFavorisState,
            child: Scaffold(
              backgroundColor: backgroundColor,
              appBar: SecondaryAppBar(title: Strings.immersionsTitle, backgroundColor: backgroundColor),
              body: _body(context, viewModel),
            ),
          );
        },
        distinct: true,
      ),
    );
  }

  Widget _body(BuildContext context, ImmersionSearchResultsViewModel viewModel) {
    switch (viewModel.displayState) {
      case DisplayState.CONTENT:
      case DisplayState.LOADING:
        return _content(context, viewModel);
      case DisplayState.EMPTY:
        return _empty(context, viewModel);
      case DisplayState.FAILURE:
        return _error(context, viewModel);
    }
  }

  Widget _empty(BuildContext context, ImmersionSearchResultsViewModel viewModel) {
    _trackEmptyResult(context);
    return EmptyOffreWidget(
      withModifyButton: !fromSavedSearch,
      additional: Padding(
        padding: const EdgeInsets.only(top: Margins.spacing_base),
        child: fromSavedSearch
            ? Container()
            : Column(
                children: [
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _alertSecondaryButton(context),
                      _filtreSecondaryButton(context, viewModel),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  Widget _content(BuildContext context, ImmersionSearchResultsViewModel viewModel) {
    return Stack(
      children: [
        ListView.separated(
          padding: const EdgeInsets.fromLTRB(
            Margins.spacing_base,
            Margins.spacing_base,
            Margins.spacing_base,
            Margins.spacing_base + Margins.spacing_huge,
          ),
          itemBuilder: (context, index) => _buildItem(context, viewModel, index),
          separatorBuilder: (context, index) => SizedBox(height: Margins.spacing_base),
          itemCount: viewModel.items.length,
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: Margins.spacing_m),
            child: Wrap(
              spacing: Margins.spacing_base,
              runSpacing: Margins.spacing_base,
              children: [
                _alertPrimaryButton(context),
                _filtrePrimaryButton(context, viewModel),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItem(BuildContext context, ImmersionSearchResultsViewModel viewModel, int index) {
    final immersion = viewModel.items[index];
    final dataCard = DataCard<Immersion>(
      titre: immersion.metier,
      sousTitre: immersion.nomEtablissement,
      lieu: immersion.ville,
      dataTag: [immersion.secteurActivite],
      onTap: () => Navigator.push(context, ImmersionDetailsPage.materialPageRoute(immersion.id)),
      from: OffrePage.immersionResults,
      id: immersion.id,
      additionalChild: immersion.fromEntrepriseAccueillante ? EntrepriseAccueillanteTag() : null,
    );
    return index == 0 && viewModel.withEntreprisesAccueillantesHeader
        ? Column(children: [_EntreprisesAccueillantesHeader(), SizedBox(height: Margins.spacing_base), dataCard])
        : dataCard;
  }

  Widget _alertPrimaryButton(BuildContext context) {
    return PrimaryActionButton(
      label: Strings.createAlert,
      icon: AppIcons.notifications_rounded,
      rippleColor: AppColors.primaryDarken,
      heightPadding: 6,
      widthPadding: 6,
      iconSize: Dimens.icon_size_base,
      onPressed: () => _onAlertButtonPressed(context),
    );
  }

  Widget _alertSecondaryButton(BuildContext context) {
    return SecondaryButton(
      label: Strings.createAlert,
      icon: AppIcons.notifications_rounded,
      onPressed: () => _onAlertButtonPressed(context),
    );
  }

  void _onAlertButtonPressed(BuildContext context) {
    showPassEmploiBottomSheet(context: context, builder: (context) => ImmersionSavedSearchBottomSheet());
  }

  Widget _error(BuildContext context, ImmersionSearchResultsViewModel viewModel) {
    return Stack(
      children: [
        Center(child: Text(viewModel.errorMessage, style: TextStyles.textSRegular())),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(padding: const EdgeInsets.only(bottom: 24), child: _filtrePrimaryButton(context, viewModel)),
        ),
      ],
    );
  }

  Widget _filtrePrimaryButton(BuildContext context, ImmersionSearchResultsViewModel viewModel) {
    return FiltreButton.primary(
      filtresCount: viewModel.filtresCount,
      onPressed: () => _onFiltreButtonPressed(context),
    );
  }

  Widget _filtreSecondaryButton(BuildContext context, ImmersionSearchResultsViewModel viewModel) {
    return FiltreButton.secondary(
      filtresCount: viewModel.filtresCount,
      onPressed: () => _onFiltreButtonPressed(context),
    );
  }

  Future<void> _onFiltreButtonPressed(BuildContext context) {
    return Navigator.push(
      context,
      ImmersionFiltresPage.materialPageRoute(),
    );
  }

  void _trackEmptyResult(BuildContext context) {
    PassEmploiMatomoTracker.instance.trackScreen(context, eventName: AnalyticsScreenNames.immersionNoResults);
  }
}

class _EntreprisesAccueillantesHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.primaryLighten,
      padding: EdgeInsets.all(Margins.spacing_m),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(AppIcons.info_rounded, color: AppColors.primary),
          SizedBox(width: Margins.spacing_s),
          Flexible(
            child: Text(
              Strings.entreprisesAccueillantesHeader,
              style: TextStyles.textBaseBoldWithColor(AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
