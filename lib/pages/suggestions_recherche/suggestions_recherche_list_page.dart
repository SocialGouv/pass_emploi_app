import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/immersion/list/immersion_list_actions.dart';
import 'package:pass_emploi_app/pages/immersion_list_page.dart';
import 'package:pass_emploi_app/pages/offre_emploi_list_page.dart';
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
import 'package:pass_emploi_app/widgets/sepline.dart';
import 'package:pass_emploi_app/widgets/snack_bar/show_snack_bar.dart';

class SuggestionsRechercheListPage extends StatelessWidget {
  SuggestionsRechercheListPage._() : super();

  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(
      builder: (context) {
        return SuggestionsRechercheListPage._();
      },
    );
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
        _goToPage(context, OffreEmploiListPage(onlyAlternance: false, fromSavedSearch: true));
        break;
      case SavedSearchNavigationState.OFFRE_ALTERNANCE:
        _goToPage(context, OffreEmploiListPage(onlyAlternance: true, fromSavedSearch: true));
        break;
      case SavedSearchNavigationState.OFFRE_IMMERSION:
        _goToPage(context, ImmersionListPage(true))
            .then((value) => StoreProvider.of<AppState>(context).dispatch(ImmersionListResetAction()));
        break;
      case SavedSearchNavigationState.SERVICE_CIVIQUE:
        //_goToPage(context, ServiceCiviqueListPage(true)); //TODO(1418): à adapter
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
            padding: const EdgeInsets.all(Margins.spacing_s),
            separatorBuilder: (context, index) => SizedBox(height: Margins.spacing_base),
            itemBuilder: (context, index) {
              return _Card(suggestionId: viewModel.suggestionIds[index]);
            },
          ),
          if (viewModel.traiterDisplayState == DisplayState.LOADING) LoadingOverlay(),
        ],
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final String suggestionId;

  _Card({required this.suggestionId});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SuggestionRechercheCardViewModel?>(
      builder: (context, viewModel) => _builder(viewModel),
      converter: (store) => SuggestionRechercheCardViewModel.create(store, suggestionId),
      distinct: true,
    );
  }

  Widget _builder(SuggestionRechercheCardViewModel? viewModel) {
    if (viewModel == null) return SizedBox(height: 0);

    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Type(viewModel.type),
          _Space(),
          _Titre(viewModel.titre),
          _Space(),
          if (viewModel.metier != null) ...[
            _Metier(viewModel.metier!),
            _Space(),
          ],
          if (viewModel.localisation != null) ...[
            _Localisation(viewModel.localisation!),
            _Space(),
          ],
          _Buttons(onTapAjouter: viewModel.ajouterSuggestion, onTapRefuser: viewModel.refuserSuggestion),
        ],
      ),
    );
  }
}

class _Space extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: Margins.spacing_base);
  }
}

class _Type extends StatelessWidget {
  final String text;

  _Type(this.text);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.accent2),
        borderRadius: BorderRadius.circular(Dimens.radius_l),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(text, style: TextStyles.textSRegular(color: AppColors.accent2)),
      ),
    );
  }
}

class _Titre extends StatelessWidget {
  final String text;

  _Titre(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyles.textBaseBold);
  }
}

class _Metier extends StatelessWidget {
  final String text;

  _Metier(this.text);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primaryLighten,
        borderRadius: BorderRadius.circular(Dimens.radius_l),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Text(text, style: TextStyles.textSRegular(color: AppColors.primaryDarken)),
      ),
    );
  }
}

class _Localisation extends StatelessWidget {
  final String text;

  _Localisation(this.text);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.primaryLighten,
        borderRadius: BorderRadius.circular(Dimens.radius_l),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Icon(
                AppIcons.location_on_rounded,
                color: AppColors.primary,
                size: Dimens.icon_size_base,
              ),
            ),
            Text(text, style: TextStyles.textSRegular(color: AppColors.primary)),
          ],
        ),
      ),
    );
  }
}

class _Buttons extends StatelessWidget {
  final Function() onTapAjouter;
  final Function() onTapRefuser;

  _Buttons({required this.onTapAjouter, required this.onTapRefuser});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SepLine(0, 0),
        Padding(
          padding: const EdgeInsets.only(top: 12),
          child: IntrinsicHeight(
            child: Row(
              children: [
                _Supprimer(onTapRefuser: onTapRefuser),
                VerticalDivider(thickness: 1, color: AppColors.primaryLighten),
                _Ajouter(onTapAjouter: onTapAjouter),
              ],
            ),
          ),
        )
      ],
    );
  }
}

class _Supprimer extends StatelessWidget {
  final Function() onTapRefuser;

  _Supprimer({required this.onTapRefuser});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(left: Margins.spacing_s),
        child: TextButton(
          onPressed: onTapRefuser,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Icon(
                  AppIcons.delete_rounded,
                  color: AppColors.primary,
                  size: Dimens.icon_size_base,
                ),
              ),
              Text(Strings.suppressionLabel, style: TextStyles.textBaseBoldWithColor(AppColors.primary)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Ajouter extends StatelessWidget {
  final Function() onTapAjouter;

  _Ajouter({required this.onTapAjouter});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
          alignment: Alignment.centerRight,
          child: PrimaryActionButton(
            label: Strings.ajouter,
            icon: AppIcons.add_rounded,
            withShadow: false,
            heightPadding: 6,
            onPressed: onTapAjouter,
          )),
    );
  }
}

void _displaySuccessSnackbar(BuildContext context, SuggestionsRechercheListViewModel? oldViewModel,
    SuggestionsRechercheListViewModel newViewModel) {
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
        snackbarKey.currentState?.hideCurrentSnackBar();
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
        snackbarKey.currentState?.removeCurrentSnackBar();
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
