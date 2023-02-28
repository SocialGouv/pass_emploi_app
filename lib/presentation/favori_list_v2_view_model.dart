import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/favori/list_v2/favori_list_v2_actions.dart';
import 'package:pass_emploi_app/features/favori/list_v2/favori_list_v2_state.dart';
import 'package:pass_emploi_app/models/favori.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class FavoriListV2ViewModel extends Equatable {
  final DisplayState displayState;
  final List<Favori> favoris;
  final Function onRetry;

  FavoriListV2ViewModel({
    required this.displayState,
    required this.favoris,
    required this.onRetry,
  });

  static FavoriListV2ViewModel create(Store<AppState> store) {
    return FavoriListV2ViewModel(
      displayState: _displayState(store),
      favoris: _favoris(store),
      onRetry: () => store.dispatch(FavoriListV2RequestAction()),
    );
  }

  @override
  List<Object?> get props => [displayState, favoris];
}

DisplayState _displayState(Store<AppState> store) {
  final state = store.state.favoriListV2State;
  if (state is FavoriListV2LoadingState) return DisplayState.LOADING;
  if (state is FavoriListV2SuccessState && state.results.isNotEmpty) return DisplayState.CONTENT;
  if (state is FavoriListV2SuccessState && state.results.isEmpty) return DisplayState.EMPTY;
  return DisplayState.FAILURE;
}

List<Favori> _favoris(Store<AppState> store) {
  final state = store.state.favoriListV2State;
  return state is FavoriListV2SuccessState ? state.results : [];
}
