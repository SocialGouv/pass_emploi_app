import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/home_state.dart';
import 'package:redux/redux.dart';

class HomeViewModel {
  final bool withLoading;
  final bool withFailure;
  final String content;

  HomeViewModel({
    required this.withLoading,
    required this.withFailure,
    required this.content,
  });

  factory HomeViewModel.create(Store<AppState> store) {
    final homeState = store.state.homeState;
    return HomeViewModel(
      withLoading: homeState is HomeLoadingState || homeState is HomeNotInitializedState,
      withFailure: homeState is HomeFailureState,
      content: homeState is HomeSuccessState
          ? homeState.home.actions.map((action) => action.content + "\n").toString()
          : "Aucune action disponible",
    );
  }
}
