import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_actions.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_card_view_model.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

import '../../features/deep_link/deep_link_actions.dart';

class RendezvousListViewModel extends Equatable {
  final DisplayState displayState;
  final List<RendezvousCardViewModel> items;
  final String? deeplinkRendezvousId;
  final Function() onRetry;
  final Function() onDeeplinkUsed;

  RendezvousListViewModel({
    required this.displayState,
    required this.items,
    required this.deeplinkRendezvousId,
    required this.onRetry,
    required this.onDeeplinkUsed,
  });

  factory RendezvousListViewModel.create(Store<AppState> store) {
    final rendezvousState = store.state.rendezvousState;
    final items = _items(state: rendezvousState);
    return RendezvousListViewModel(
      displayState: _displayState(rendezvousState),
      items: items,
      onRetry: () => store.dispatch(RendezvousRequestAction()),
      deeplinkRendezvousId: _deeplinkRendezvousId(store.state.deepLinkState),
      onDeeplinkUsed: () => store.dispatch(ResetDeeplinkAction()),
    );
  }

  @override
  List<Object?> get props => [displayState, items, deeplinkRendezvousId];
}

DisplayState _displayState(RendezvousState state) {
  if (state is RendezvousNotInitializedState) return DisplayState.LOADING;
  if (state is RendezvousLoadingState) return DisplayState.LOADING;
  if (state is RendezvousSuccessState && state.rendezvous.isNotEmpty) return DisplayState.CONTENT;
  if (state is RendezvousSuccessState && state.rendezvous.isEmpty) return DisplayState.EMPTY;
  return DisplayState.FAILURE;
}

List<RendezvousCardViewModel> _items({required RendezvousState state}) {
  if (state is RendezvousSuccessState) {
    final rendezvous = state.rendezvous;
    rendezvous.sort((a, b) => b.date.compareTo(a.date));
    return rendezvous.map((rdv) => RendezvousCardViewModel.create(rdv)).toList();
  }
  return [];
}

String? _deeplinkRendezvousId(DeepLinkState state) {
  return state.deepLink == DeepLink.ROUTE_TO_RENDEZVOUS ? state.dataId : null;
}
