import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_actions.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class RendezvousListViewModel extends Equatable {
  final DisplayState displayState;
  final List<String> rendezvousIds;
  final String? deeplinkRendezvousId;
  final Function() onRetry;
  final Function() onDeeplinkUsed;

  RendezvousListViewModel({
    required this.displayState,
    required this.rendezvousIds,
    required this.deeplinkRendezvousId,
    required this.onRetry,
    required this.onDeeplinkUsed,
  });

  factory RendezvousListViewModel.create(Store<AppState> store) {
    final loginState = store.state.loginState;
    final rendezvousState = store.state.rendezvousState;
    final rendezvousIds = _rendezvousIds(rendezvousState, loginState);
    return RendezvousListViewModel(
      displayState: _displayState(rendezvousState),
      rendezvousIds: rendezvousIds,
      deeplinkRendezvousId: _deeplinkRendezvousId(store.state.deepLinkState, rendezvousIds),
      onRetry: () => store.dispatch(RendezvousRequestAction()),
      onDeeplinkUsed: () => store.dispatch(ResetDeeplinkAction()),
    );
  }

  @override
  List<Object?> get props => [displayState, rendezvousIds, deeplinkRendezvousId];
}

DisplayState _displayState(RendezvousState state) {
  if (state is RendezvousNotInitializedState) return DisplayState.LOADING;
  if (state is RendezvousLoadingState) return DisplayState.LOADING;
  if (state is RendezvousSuccessState && state.rendezvous.isNotEmpty) return DisplayState.CONTENT;
  if (state is RendezvousSuccessState && state.rendezvous.isEmpty) return DisplayState.EMPTY;
  return DisplayState.FAILURE;
}

List<String> _rendezvousIds(RendezvousState rendezvousState, LoginState loginState) {
  if (rendezvousState is! RendezvousSuccessState) return [];
  if (loginState is! LoginSuccessState) return [];

  final rendezvous = rendezvousState.rendezvous;

  if (loginState.user.loginMode == LoginMode.POLE_EMPLOI) {
    rendezvous.sort((a, b) => a.date.compareTo(b.date));
  } else {
    rendezvous.sort((a, b) => b.date.compareTo(a.date));
  }

  return rendezvous.map((rdv) => rdv.id).toList();
}

String? _deeplinkRendezvousId(DeepLinkState state, List<String> rdvIds) {
  return (state.deepLink == DeepLink.ROUTE_TO_RENDEZVOUS && rdvIds.contains(state.dataId)) ? state.dataId : null;
}
