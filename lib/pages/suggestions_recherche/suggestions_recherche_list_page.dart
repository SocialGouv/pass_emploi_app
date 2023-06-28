import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/offre_type.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_emploi_page.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_immersion_page.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_service_civique_page.dart';
import 'package:pass_emploi_app/pages/suggestions_recherche/suggestions_alerte_location_form.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/saved_search/saved_search_navigation_state.dart';
import 'package:pass_emploi_app/presentation/suggestions/suggestion_recherche_card_view_model.dart';
import 'package:pass_emploi_app/presentation/suggestions/suggestions_recherche_list_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/redux/store_connector_aware.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/cards/generic/card_container.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/loading_overlay.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';
import 'package:pass_emploi_app/widgets/tags/job_tag.dart';

class SuggestionsRechercheListPage extends StatelessWidget {
  SuggestionsRechercheListPage._() : super();

  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => SuggestionsRechercheListPage._());
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnectorAware<SuggestionsRechercheListViewModel>(
      builder: (context, viewModel) => _Scaffold(viewModel: viewModel),
      converter: (store) => SuggestionsRechercheListViewModel.create(store),
      onDidChange: (oldVM, newVM) => _onDidChange(context, oldVM, newVM),
      distinct: true,
    );
  }

  void _onDidChange(BuildContext context, SuggestionsRechercheListViewModel? oldViewModel,
      SuggestionsRechercheListViewModel newViewModel) {
    _displaySuccessSnackbar(context, oldViewModel, newViewModel);
    _navigateToSearch(context, newViewModel.searchNavigationState);
  }

  void _navigateToSearch(BuildContext context, SavedSearchNavigationState searchNavigationState) {
    switch (searchNavigationState) {
      case SavedSearchNavigationState.OFFRE_EMPLOI:
        _goToPage(context, RechercheOffreEmploiPage(onlyAlternance: false));
        break;
      case SavedSearchNavigationState.OFFRE_ALTERNANCE:
        _goToPage(context, RechercheOffreEmploiPage(onlyAlternance: true));
        break;
      case SavedSearchNavigationState.OFFRE_IMMERSION:
        _goToPage(context, RechercheOffreImmersionPage());
        break;
      case SavedSearchNavigationState.SERVICE_CIVIQUE:
        _goToPage(context, RechercheOffreServiceCiviquePage());
        break;
      case SavedSearchNavigationState.NONE:
        break;
    }
  }

  Future<void> _goToPage(BuildContext context, Widget page) {
    return Navigator.push(context, MaterialPageRoute(builder: (_) => page));
  }
}

class _Scaffold extends StatelessWidget {
  final SuggestionsRechercheListViewModel viewModel;

  _Scaffold({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    const backgroundColor = AppColors.grey100;
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: SecondaryAppBar(title: Strings.suggestionsDeRechercheTitlePage, backgroundColor: backgroundColor),
      body: Stack(
        children: [
          ListView.separated(
            itemCount: viewModel.suggestionIds.length,
            padding: const EdgeInsets.all(Margins.spacing_base),
            separatorBuilder: (context, index) => SizedBox(height: Margins.spacing_base),
            itemBuilder: (context, index) {
              final suggestionId = viewModel.suggestionIds[index];
              return index == 0 ? _Header(suggestionId: suggestionId) : _Card(suggestionId: suggestionId);
            },
          ),
          if (viewModel.traiterDisplayState == DisplayState.LOADING) LoadingOverlay(),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String suggestionId;

  _Header({required this.suggestionId});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(Strings.suggestionsDeRechercheHeader, style: TextStyles.textBaseRegular),
        SizedBox(height: Margins.spacing_base),
        _Card(suggestionId: suggestionId),
      ],
    );
  }
}

class _Card extends StatelessWidget {
  final String suggestionId;

  _Card({required this.suggestionId});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SuggestionRechercheCardViewModel?>(
      builder: _builder,
      converter: (store) => SuggestionRechercheCardViewModel.create(store, suggestionId),
      distinct: true,
    );
  }

  Widget _builder(BuildContext context, SuggestionRechercheCardViewModel? viewModel) {
    if (viewModel == null) return SizedBox(height: 0);
    final source = viewModel.source;
    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (source != null) JobTag(label: source, backgroundColor: AppColors.additional2Ligthen),
              if (source != null) SizedBox(width: Margins.spacing_m),
              viewModel.type.toJobTag(),
            ],
          ),
          SizedBox(height: Margins.spacing_m),
          _Titre(viewModel.titre),
          SizedBox(height: Margins.spacing_base),
          if (viewModel.localisation != null) ...[
            _Localisation(viewModel.localisation!),
            SizedBox(height: Margins.spacing_base)
          ],
          SizedBox(height: Margins.spacing_s),
          _Buttons(
            onTapAjouter: () async {
              if (viewModel.withLocationForm) {
                await _selectLocationAndRayon(
                  context,
                  viewModel.type,
                  onSelected: (location, rayon) => viewModel.ajouterSuggestion(location: location, rayon: rayon),
                );
              } else {
                viewModel.ajouterSuggestion();
              }
            },
            onTapRefuser: viewModel.refuserSuggestion,
          ),
        ],
      ),
    );
  }

  Future<void> _selectLocationAndRayon(
    BuildContext context,
    OffreType type, {
    required void Function(Location? location, double? rayon) onSelected,
  }) async {
    final locationAndRayon =
        await Navigator.of(context).push(SuggestionsAlerteLocationForm.materialPageRoute(type: type));

    if (locationAndRayon != null) {
      final (Location location, double rayon) = locationAndRayon;
      onSelected(location, rayon);
    }
  }
}

class _Titre extends StatelessWidget {
  final String text;

  _Titre(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyles.textMBold);
  }
}

class _Localisation extends StatelessWidget {
  final String localisation;

  const _Localisation(this.localisation);

  @override
  Widget build(BuildContext context) {
    const color = AppColors.grey800;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(AppIcons.location_on_rounded, color: color, size: Dimens.icon_size_base),
        SizedBox(width: Margins.spacing_s),
        Text(localisation, style: TextStyles.textSRegular(color: color)),
      ],
    );
  }
}

class _Buttons extends StatelessWidget {
  final Function() onTapAjouter;
  final Function() onTapRefuser;

  _Buttons({required this.onTapAjouter, required this.onTapRefuser});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _Refuser(onTapRefuser: onTapRefuser)),
        SizedBox(
          height: Margins.spacing_l,
          child: VerticalDivider(width: Margins.spacing_base, thickness: 1, color: AppColors.primaryLighten),
        ),
        Expanded(child: _Ajouter(onTapAjouter: onTapAjouter)),
      ],
    );
  }
}

class _Refuser extends StatelessWidget {
  final Function() onTapRefuser;

  _Refuser({required this.onTapRefuser});

  @override
  Widget build(BuildContext context) {
    return PrimaryActionButton(
      heightPadding: Margins.spacing_base,
      backgroundColor: AppColors.primaryLighten,
      rippleColor: Color.alphaBlend(Colors.black12, AppColors.primaryLighten),
      textColor: AppColors.primary,
      iconColor: AppColors.primary,
      label: Strings.refuserLabel,
      icon: AppIcons.remove_alert_rounded,
      iconRightPadding: Margins.spacing_xs,
      withShadow: false,
      onPressed: onTapRefuser,
    );
  }
}

class _Ajouter extends StatelessWidget {
  final Function() onTapAjouter;

  _Ajouter({required this.onTapAjouter});

  @override
  Widget build(BuildContext context) {
    return PrimaryActionButton(
      heightPadding: Margins.spacing_base,
      label: Strings.ajouter,
      icon: AppIcons.add_alert_rounded,
      iconRightPadding: Margins.spacing_xs,
      withShadow: false,
      onPressed: onTapAjouter,
    );
  }
}

void _displaySuccessSnackbar(
  BuildContext context,
  SuggestionsRechercheListViewModel? oldViewModel,
  SuggestionsRechercheListViewModel newViewModel,
) {
  if (newViewModel.traiterDisplayState != DisplayState.CONTENT) return;
  if (oldViewModel?.traiterDisplayState == DisplayState.CONTENT) return;

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      padding: const EdgeInsets.only(left: 24, bottom: 14),
      duration: Duration(days: 365),
      backgroundColor: AppColors.secondaryLighten,
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.secondary,
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Icon(
                    AppIcons.check_rounded,
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(width: 10.0),
              Expanded(
                child: Text(
                  Strings.suggestionRechercheAjoutee,
                  style: TextStyles.textBaseBoldWithColor(AppColors.secondary),
                ),
              ),
              _CloseSnackbar(newViewModel),
            ],
          ),
          Text(
            Strings.suggestionRechercheAjouteeDescription,
            style: TextStyles.textBaseRegularWithColor(AppColors.secondary),
          ),
          SizedBox(height: Margins.spacing_s),
          _SeeResults(newViewModel),
        ],
      ),
    ),
  );
}

class _CloseSnackbar extends StatelessWidget {
  final SuggestionsRechercheListViewModel viewModel;

  _CloseSnackbar(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        viewModel.resetTraiterState();
        clearAllSnackBars();
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 24, 16),
        child: Icon(
          AppIcons.close_rounded,
          color: AppColors.secondary,
        ),
      ),
    );
  }
}

class _SeeResults extends StatelessWidget {
  final SuggestionsRechercheListViewModel viewModel;

  _SeeResults(this.viewModel);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        viewModel.seeOffreResults();
        viewModel.resetTraiterState();
        clearAllSnackBars();
      },
      child: Row(
        children: [
          Text(
            Strings.voirResultatsSuggestion,
            style: TextStyles.textBaseBoldWithColor(AppColors.secondary).copyWith(decoration: TextDecoration.underline),
          ),
          Icon(
            AppIcons.chevron_right_rounded,
            color: AppColors.secondary,
          ),
        ],
      ),
    );
  }
}
