import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:pass_emploi_app/features/raclette/raclette_actions.dart';
import 'package:pass_emploi_app/features/raclette/raclette_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/dimens.dart';
import 'package:pass_emploi_app/ui/font_sizes.dart';
import 'package:pass_emploi_app/widgets/buttons/primary_action_button.dart';
import 'package:redux/redux.dart';

class RechercheRaclettePage extends StatelessWidget {
  static MaterialPageRoute<void> materialPageRoute() {
    return MaterialPageRoute(builder: (context) => RechercheRaclettePage());
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, int>(
      builder: (_, __) {
        return Scaffold(
          appBar: AppBar(title: Text('Recherche raclette')),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _CritereRecherche(),
                _ResultatRecherche(),
              ],
            ),
          ),
        );
      },
      onDispose: (store) => store.dispatch(RacletteResetAction()),
      converter: (store) => 0,
      distinct: true,
    );
  }
}

class _CritereRecherche extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BlocCritereRacletteViewModel>(
      converter: (store) => BlocCritereRacletteViewModel.create(store),
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
                    title: _CritereRechercheFerme(),
                    initiallyExpanded: vm.isOpen,
                    children: [_CritereRechercheOuvert()],
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

class BlocCritereRacletteViewModel extends Equatable {
  final bool isOpen;

  BlocCritereRacletteViewModel(this.isOpen);

  factory BlocCritereRacletteViewModel.create(Store<AppState> store) {
    final isOpen = [
      RacletteStatus.nouvelleRecherche,
      RacletteStatus.loading,
      RacletteStatus.failure,
    ].contains(store.state.racletteState.status);
    return BlocCritereRacletteViewModel(isOpen);
  }

  @override
  List<Object?> get props => [isOpen];
}

class _CritereRechercheOuvert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BlocCritereRacletteOuvertViewModel>(
      converter: (store) => BlocCritereRacletteOuvertViewModel.create(store),
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

class BlocCritereRacletteOuvertViewModel extends Equatable {
  final DisplayState displayState;
  final Function(String) onSearch;

  BlocCritereRacletteOuvertViewModel({required this.displayState, required this.onSearch});

  factory BlocCritereRacletteOuvertViewModel.create(Store<AppState> store) {
    return BlocCritereRacletteOuvertViewModel(
      displayState: _displayState(store),
      onSearch: (keyword) => store.dispatch(RacletteRequestAction(RacletteCritere(""))),
    );
  }

  @override
  List<Object?> get props => [displayState];
}

DisplayState _displayState(Store<AppState> store) {
  final status = store.state.racletteState.status;
  if (status == RacletteStatus.loading) return DisplayState.LOADING;
  if (status == RacletteStatus.failure) return DisplayState.FAILURE;
  return DisplayState.CONTENT;
}

class _CritereRechercheFerme extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      "(0) critères actifs",
      style: TextStyle(
        fontFamily: 'Marianne',
        fontSize: FontSizes.medium,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _ResultatRecherche extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ResultatRechercheViewModel>(
      builder: (context, vm) {
        final raclettes = vm.raclettes;
        if (raclettes == null) {
          return Padding(padding: const EdgeInsets.symmetric(vertical: 16.0), child: Text("Faites votre recherche !"));
        }
        if (raclettes.isEmpty) {
          return Padding(padding: const EdgeInsets.symmetric(vertical: 16.0), child: Text("Pas de chance"));
        }
        return Padding(padding: const EdgeInsets.symmetric(vertical: 16.0), child: Text(raclettes.join("\n")));
      },
      converter: (store) => ResultatRechercheViewModel.create(store),
      distinct: true,
    );
  }
}

class ResultatRechercheViewModel extends Equatable {
  final List<String>? raclettes;

  ResultatRechercheViewModel(this.raclettes);

  factory ResultatRechercheViewModel.create(Store<AppState> store) {
    return ResultatRechercheViewModel(store.state.racletteState.result);
  }

  @override
  List<Object?> get props => [raclettes];
}
