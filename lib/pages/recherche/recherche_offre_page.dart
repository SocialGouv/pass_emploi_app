import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/models/offre_emploi.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/pages/offre_emploi_details_page.dart';
import 'package:pass_emploi_app/pages/offre_page.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/offre_emploi_item_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_repository.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/font_sizes.dart';
import 'package:pass_emploi_app/ui/margins.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/cards/data_card.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
import 'package:pass_emploi_app/widgets/favori_state_selector.dart';
import 'package:redux/redux.dart';

class RechercheOffrePage extends StatelessWidget {
  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => RechercheOffrePage());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: 1353 - StoreConnector juste pour le dispose, voir si à mettre dans un view model
    return StoreConnector<AppState, int>(
      builder: (_, __) {
        const backgroundColor = AppColors.grey100;
        return Scaffold(
          backgroundColor: backgroundColor,
          appBar: SecondaryAppBar(title: Strings.rechercheOffresEmploiTitle, backgroundColor: backgroundColor),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CritereRecherche(),
              _ResultatRecherche(),
            ],
          ),
        );
      },
      onDispose: (store) => store.dispatch(RechercheResetAction<OffreEmploi>()),
      converter: (store) => 0,
      distinct: true,
    );
  }
}

class _CritereRecherche extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BlocCritereRechercheViewModel>(
      converter: (store) => BlocCritereRechercheViewModel.create(store),
      builder: (context, vm) {
        return Padding(
          padding: const EdgeInsets.only(
            left: Margins.spacing_base,
            right: Margins.spacing_base,
            top: Margins.spacing_base,
          ),
          child: Column(
            children: [
              Material(
                elevation: 16, //TODO Real box shadow ?
                borderRadius: BorderRadius.circular(Dimens.radius_s),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Dimens.radius_s),
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      key: UniqueKey(),
                      // required to force rebuild with new vm.isOpen value
                      collapsedBackgroundColor: AppColors.primary,
                      collapsedIconColor: Colors.white,
                      iconColor: AppColors.primary,
                      backgroundColor: Colors.white,
                      collapsedTextColor: Colors.white,
                      title: _CritereRechercheBandeau(),
                      initiallyExpanded: vm.isOpen,
                      children: [_CritereRechercheContenu()],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      distinct: true,
    );
  }
}

class _CritereRechercheBandeau extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      // TODO: 1353 MAJ des critères
      "(0) critères actifs",
      // TODO: 1353 Créer un bon TextStyle à part
      style: TextStyle(
        fontFamily: 'Marianne',
        fontSize: FontSizes.medium,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _CritereRechercheContenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BlocCritereRechercheContenuViewModel>(
      converter: (store) => BlocCritereRechercheContenuViewModel.create(store),
      builder: (context, vm) {
        return Column(
          children: [
            if (vm.displayState == DisplayState.FAILURE) Text("failure"),
            if (vm.displayState == DisplayState.LOADING) Text("loading"),
            PrimaryActionButton(
              label: "Rechercher",
              onPressed: vm.displayState == DisplayState.LOADING ? null : () => vm.onSearch("toto"),
            )
          ],
        );
      },
      distinct: true,
    );
  }
}

class _ResultatRecherche extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ResultatRechercheViewModel>(
      builder: _builder,
      converter: (store) => ResultatRechercheViewModel.create(store),
      distinct: true,
    );
  }

  Widget _builder(BuildContext context, ResultatRechercheViewModel viewModel) {
    final items = viewModel.items;
    if (items == null) {
      return Padding(padding: const EdgeInsets.symmetric(vertical: 16.0), child: Text("Faites votre recherche !"));
    } else if (items.isEmpty) {
      return Padding(padding: const EdgeInsets.symmetric(vertical: 16.0), child: Text("Aucun résultat"));
    } else {
      return FavorisStateContext<OffreEmploi>(
        selectState: (store) => store.state.offreEmploiFavorisState,
        child: Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(
              left: Margins.spacing_base,
              right: Margins.spacing_base,
              top: Margins.spacing_base,
              bottom: 120,
            ),
            //controller: _scrollController,
            itemBuilder: (context, index) => _buildItem(context, items[index]),
            separatorBuilder: (context, index) => const SizedBox(height: Margins.spacing_base),
            itemCount: items.length,
          ),
        ),
      );
    }
  }

  Widget _buildItem(BuildContext context, OffreEmploiItemViewModel item) {
    return DataCard<OffreEmploi>(
      titre: item.title,
      sousTitre: item.companyName,
      lieu: item.location,
      id: item.id,
      dataTag: [item.contractType, item.duration ?? ''],
      onTap: () => _showOffreEmploiDetailsPage(context, item.id),
      from: OffrePage.emploiResults, // TODO: 1353 - only alternance
      //from: widget.onlyAlternance ? OffrePage.alternanceResults : OffrePage.emploiResults,
    );
  }

  void _showOffreEmploiDetailsPage(BuildContext context, String offreId) {
    // TODO: 1353 - Scroll
    //_offsetBeforeLoading = _scrollController.offset;
    Navigator.push(
      context,
      // TODO: 1353 - only alternance
      //OffreEmploiDetailsPage.materialPageRoute(offreId, fromAlternance: widget.onlyAlternance),
      OffreEmploiDetailsPage.materialPageRoute(offreId, fromAlternance: false),
    ); //.then((_) => _scrollController.jumpTo(_offsetBeforeLoading));
  }
}

// TODO: 1353 - ViewModels à mettre dans un fichier à part
class BlocCritereRechercheViewModel extends Equatable {
  final bool isOpen;

  BlocCritereRechercheViewModel(this.isOpen);

  factory BlocCritereRechercheViewModel.create(Store<AppState> store) {
    final isOpen = [
      RechercheStatus.newSearch,
      RechercheStatus.loading,
      RechercheStatus.failure,
    ].contains(store.state.rechercheEmploiState.status);
    return BlocCritereRechercheViewModel(isOpen);
  }

  @override
  List<Object?> get props => [isOpen];
}

class BlocCritereRechercheContenuViewModel extends Equatable {
  final DisplayState displayState;
  final Function(String) onSearch;

  BlocCritereRechercheContenuViewModel({required this.displayState, required this.onSearch});

  factory BlocCritereRechercheContenuViewModel.create(Store<AppState> store) {
    return BlocCritereRechercheContenuViewModel(
      displayState: _displayState(store),
      onSearch: (keyword) => store.dispatch(RechercheRequestAction(
        RechercheRequest(
          // TODO: 1353 - Vraie recherche
          EmploiCriteresRecherche(
            keywords: 'boulanger',
            location: null,
            onlyAlternance: false,
          ),
          OffreEmploiSearchParametersFiltres.noFiltres(),
          1,
        ),
      )),
    );
  }

  @override
  List<Object?> get props => [displayState];
}

DisplayState _displayState(Store<AppState> store) {
  final status = store.state.rechercheEmploiState.status;
  if (status == RechercheStatus.loading) return DisplayState.LOADING;
  if (status == RechercheStatus.failure) return DisplayState.FAILURE;
  return DisplayState.CONTENT;
}

class ResultatRechercheViewModel extends Equatable {
  final List<OffreEmploiItemViewModel>? items;

  ResultatRechercheViewModel(this.items);

  factory ResultatRechercheViewModel.create(Store<AppState> store) {
    final results = store.state.rechercheEmploiState.results;
    if (results == null) return ResultatRechercheViewModel(null);
    return ResultatRechercheViewModel(results.map((offre) => OffreEmploiItemViewModel.create(offre)).toList());
  }

  @override
  List<Object?> get props => [items];
}
