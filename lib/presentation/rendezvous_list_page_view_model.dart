import 'package:pass_emploi_app/presentation/rendezvous_view_model.dart';
import 'package:pass_emploi_app/redux/actions/ui_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/login_state.dart';
import 'package:pass_emploi_app/redux/states/rendezvous_state.dart';
import 'package:redux/redux.dart';

class RendezvousListPageViewModel {
  final bool withLoading;
  final bool withFailure;
  final bool withEmptyMessage;
  final List<RendezvousViewModel> items;
  final Function() onRetry;

  RendezvousListPageViewModel({
    required this.withLoading,
    required this.withFailure,
    required this.withEmptyMessage,
    required this.items,
    required this.onRetry,
  });

  factory RendezvousListPageViewModel.create(Store<AppState> store) {
    if (!(store.state.loginState is LoggedInState)) {
      throw Exception("User should be logged in to access rendezvous list page");
    }
    final user = (store.state.loginState as LoggedInState).user;
    return RendezvousListPageViewModel(
      withLoading: _isLoading(store.state.rendezvousState),
      withFailure: _isFailure(store.state.rendezvousState),
      withEmptyMessage: _isEmpty(store.state.rendezvousState),
      items: _items(state: store.state.rendezvousState),
      onRetry: () => store.dispatch(RequestRendezvousAction(user.id)),
    );
  }
}

bool _isLoading(RendezvousState state) => state is RendezvousLoadingState || state is RendezvousNotInitializedState;

bool _isFailure(RendezvousState state) => state is RendezvousFailureState;

bool _isEmpty(RendezvousState state) => state is RendezvousSuccessState && state.rendezvous.isEmpty;

List<RendezvousViewModel> _items({required RendezvousState state}) {
  if (state is RendezvousSuccessState) {
    return state.rendezvous.map((rdv) => RendezvousViewModel.create(rdv)).toList();
  }
  return [];
}
