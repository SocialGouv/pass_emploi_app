import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/demarche/search/seach_demarche_actions.dart';
import 'package:pass_emploi_app/features/demarche/search/seach_demarche_state.dart';
import 'package:pass_emploi_app/features/thematiques_demarche/thematiques_demarche_state.dart';
import 'package:pass_emploi_app/features/top_demarche/top_demarche_state.dart';
import 'package:pass_emploi_app/models/demarche_du_referentiel.dart';
import 'package:pass_emploi_app/presentation/demarche/demarche_source.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

class CreateDemarcheStep2ViewModel extends Equatable {
  final List<CreateDemarcheStep2Item> items;
  final DisplayState displayState;
  final void Function() onRetry;

  CreateDemarcheStep2ViewModel({required this.items, required this.displayState, required this.onRetry});

  factory CreateDemarcheStep2ViewModel.create(Store<AppState> store, DemarcheSource source, {String? query}) {
    final List<DemarcheDuReferentiel> demarches = source.demarcheList(store);
    final state = store.state;

    return CreateDemarcheStep2ViewModel(
      items: _items(demarches),
      displayState: _displayState(source, state),
      onRetry: () => _onRetry(store, source, query),
    );
  }

  @override
  List<Object?> get props => [items, displayState];
}

List<CreateDemarcheStep2Item> _items(List<DemarcheDuReferentiel> demarches) {
  return [
    if (demarches.isEmpty) CreateDemarcheStep2EmptyItem(),
    if (demarches.isNotEmpty) CreateDemarcheStep2TitleItem(Strings.selectDemarche),
    ...demarches.map((demarche) => CreateDemarcheStep2DemarcheFoundItem(demarche.id)),
    CreateDemarcheStep2ButtonItem(),
  ];
}

void _onRetry(Store<AppState> store, DemarcheSource source, String? query) {
  if (source is RechercheDemarcheSource) {
    store.dispatch(SearchDemarcheRequestAction(query!));
  }
}

sealed class CreateDemarcheStep2Item extends Equatable {
  @override
  List<Object?> get props => [];
}

class CreateDemarcheStep2TitleItem extends CreateDemarcheStep2Item {
  final String title;

  CreateDemarcheStep2TitleItem(this.title);

  @override
  List<Object?> get props => [title];
}

class CreateDemarcheStep2DemarcheFoundItem extends CreateDemarcheStep2Item {
  final String idDemarche;

  CreateDemarcheStep2DemarcheFoundItem(this.idDemarche);

  @override
  List<Object?> get props => [idDemarche];
}

class CreateDemarcheStep2ButtonItem extends CreateDemarcheStep2Item {}

class CreateDemarcheStep2EmptyItem extends CreateDemarcheStep2Item {}

DisplayState _displayState(DemarcheSource source, AppState state) {
  return switch (source) {
    RechercheDemarcheSource() => _displayStateFromRechercheSource(state.searchDemarcheState),
    ThematiqueDemarcheSource() => _displayStateFromThematiqueSource(state.thematiquesDemarcheState),
    TopDemarcheSource() => _displayStateFromTopDemarcheSource(state.topDemarcheState),
    MatchingDemarcheSource() => throw UnimplementedError("MatchingDemarcheSource not implemented"),
  };
}

DisplayState _displayStateFromRechercheSource(SearchDemarcheState state) {
  if (state is SearchDemarcheLoadingState || state is SearchDemarcheNotInitializedState) return DisplayState.LOADING;
  if (state is SearchDemarcheFailureState) return DisplayState.FAILURE;
  return DisplayState.CONTENT;
}

DisplayState _displayStateFromThematiqueSource(ThematiqueDemarcheState state) {
  if (state is ThematiqueDemarcheLoadingState || state is ThematiqueDemarcheNotInitializedState) {
    return DisplayState.LOADING;
  }
  if (state is ThematiqueDemarcheFailureState) return DisplayState.FAILURE;
  return DisplayState.CONTENT;
}

DisplayState _displayStateFromTopDemarcheSource(TopDemarcheState state) {
  if (state is TopDemarcheNotInitializedState) return DisplayState.LOADING;
  return DisplayState.CONTENT;
}
