import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/suggestions_recherche/list/suggestions_recherche_actions.dart';
import 'package:pass_emploi_app/models/location.dart';
import 'package:pass_emploi_app/models/login_mode.dart';
import 'package:pass_emploi_app/models/offre_type.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_emploi_page.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_immersion_page.dart';
import 'package:pass_emploi_app/pages/recherche/recherche_offre_service_civique_page.dart';
import 'package:pass_emploi_app/pages/suggestions_recherche/suggestions_alerte_location_form.dart';
import 'package:pass_emploi_app/presentation/alerte/alerte_navigation_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/suggestions/suggestion_recherche_card_view_model.dart';
import 'package:pass_emploi_app/presentation/suggestions/suggestions_recherche_list_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/redux/store_connector_aware.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/app_icons.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/ui/text_styles.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/buttons/secondary_button.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/base_card.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_complement.dart';
import 'package:pass_emploi_app/widgets/cards/base_cards/widgets/card_tag.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/illustration/illustration.dart';
import 'package:pass_emploi_app/widgets/loading_overlay.dart';
import 'package:pass_emploi_app/widgets/retry.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';

class SuggestionsRechercheListPage extends StatelessWidget {
  final bool fetchSuggestions;

  SuggestionsRechercheListPage._({required this.fetchSuggestions}) : super();

  static MaterialPageRoute<void> materialPageRoute({bool fetchSuggestions = false}) {
    return MaterialPageRoute(
        builder: (context) => SuggestionsRechercheListPage._(
              fetchSuggestions: fetchSuggestions,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnectorAware<SuggestionsRechercheListViewModel>(
      onInit: (store) => fetchSuggestions ? store.dispatch(SuggestionsRechercheRequestAction()) : null,
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

  void _navigateToSearch(BuildContext context, AlerteNavigationState searchNavigationState) {
    switch (searchNavigationState) {
      case AlerteNavigationState.OFFRE_EMPLOI:
        _goToPage(context, RechercheOffreEmploiPage(onlyAlternance: false));
        break;
      case AlerteNavigationState.OFFRE_ALTERNANCE:
        _goToPage(context, RechercheOffreEmploiPage(onlyAlternance: true));
        break;
      case AlerteNavigationState.OFFRE_IMMERSION:
        _goToPage(context, RechercheOffreImmersionPage());
        break;
      case AlerteNavigationState.SERVICE_CIVIQUE:
        _goToPage(context, RechercheOffreServiceCiviquePage());
        break;
      case AlerteNavigationState.NONE:
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
      appBar: SecondaryAppBar(title: Strings.vosSuggestionsAlertes, backgroundColor: backgroundColor),
      body: _Body(viewModel: viewModel),
    );
  }
}

class _Body extends StatelessWidget {
  final SuggestionsRechercheListViewModel viewModel;

  _Body({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        switch (viewModel.displayState) {
          DisplayState.EMPTY => _Empty(viewModel: viewModel),
          DisplayState.CONTENT => _Content(viewModel: viewModel),
          DisplayState.LOADING => Center(child: CircularProgressIndicator()),
          DisplayState.FAILURE => Retry(Strings.vosSuggestionsAlertesError, () => viewModel.retryFetchSuggestions()),
        },
        if (viewModel.traiterDisplayState == DisplayState.LOADING) LoadingOverlay(),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final SuggestionsRechercheListViewModel viewModel;

  _Content({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: viewModel.suggestionIds.length,
      padding: const EdgeInsets.all(Margins.spacing_base),
      separatorBuilder: (context, index) => SizedBox(height: Margins.spacing_base),
      itemBuilder: (context, index) {
        final suggestionId = viewModel.suggestionIds[index];
        return index == 0 ? _Header(suggestionId: suggestionId) : _Card(suggestionId: suggestionId);
      },
    );
  }
}

class _Empty extends StatelessWidget {
  final SuggestionsRechercheListViewModel viewModel;

  _Empty({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: Margins.spacing_xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(flex: 1),
          Center(
            child: SizedBox(
              height: 130,
              width: 130,
              child: Illustration.grey(AppIcons.checklist_rounded),
            ),
          ),
          Text(Strings.emptySuggestionAlerteListTitre, style: TextStyles.textBaseBold, textAlign: TextAlign.center),
          SizedBox(height: Margins.spacing_base),
          Text(
            viewModel.loginMode?.isMiLo() == true
                ? Strings.emptySuggestionAlerteListDescriptionMilo
                : Strings.emptySuggestionAlerteListDescriptionPoleEmploi,
            style: TextStyles.textBaseRegular,
            textAlign: TextAlign.center,
          ),
          Spacer(flex: 2),
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

    return BaseCard(
      title: viewModel.titre,
      tag: viewModel.type.toCardTag(),
      complements: [if (viewModel.localisation != null) CardComplement.place(text: viewModel.localisation!)],
      secondaryTags: [
        if (source != null) CardTag.secondary(text: source, semanticsLabel: Strings.source + source),
      ],
      actions: [
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

class _Buttons extends StatelessWidget {
  final Function() onTapAjouter;
  final Function() onTapRefuser;

  _Buttons({required this.onTapAjouter, required this.onTapRefuser});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _Refuser(onTapRefuser: onTapRefuser)),
        SizedBox(width: Margins.spacing_base),
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
    return SecondaryButton(
      label: Strings.refuserLabel,
      icon: AppIcons.remove_alert_rounded,
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
      backgroundColor: AppColors.successLighten,
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
                  color: AppColors.success,
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
                  style: TextStyles.textBaseBoldWithColor(AppColors.success),
                ),
              ),
              _CloseSnackbar(newViewModel),
            ],
          ),
          Text(
            Strings.suggestionRechercheAjouteeDescription,
            style: TextStyles.textBaseRegularWithColor(AppColors.success),
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
          color: AppColors.success,
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
            style: TextStyles.textBaseBoldWithColor(AppColors.success).copyWith(decoration: TextDecoration.underline),
          ),
          Icon(
            AppIcons.chevron_right_rounded,
            color: AppColors.success,
          ),
        ],
      ),
    );
  }
}
