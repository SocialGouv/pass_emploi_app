import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/recherche/recherche_actions.dart';
import 'package:pass_emploi_app/features/recherche/recherche_state.dart';
import 'package:pass_emploi_app/models/offre_emploi_filtres_parameters.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/offre_emploi_repository.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/font_sizes.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:pass_emploi_app/widgets/default_app_bar.dart';
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
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _CritereRecherche(),
                //_ResultatRecherche(),
              ],
            ),
          ),
        );
      },
      onDispose: (store) => store.dispatch(RechercheResetAction()),
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
        return Column(
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
