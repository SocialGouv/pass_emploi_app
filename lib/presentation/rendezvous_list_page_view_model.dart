import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_actions.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';
import 'package:pass_emploi_app/presentation/rendezvous_view_model.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:redux/redux.dart';

import '../features/deep_link/deep_link_actions.dart';

class RendezvousListPageViewModel extends Equatable {
  final bool withLoading;
  final bool withFailure;
  final bool withEmptyMessage;
  final List<RendezvousViewModel> items;
  final Function() onRetry;
  final Function() onDeeplinkUsed;
  final RendezvousViewModel? deeplinkRendezvous;

  RendezvousListPageViewModel({
    required this.withLoading,
    required this.withFailure,
    required this.withEmptyMessage,
    required this.items,
    required this.onRetry,
    required this.deeplinkRendezvous,
    required this.onDeeplinkUsed,
  });

  factory RendezvousListPageViewModel.create(Store<AppState> store) {
    final rendezvousState = store.state.rendezvousState;
    final items = _items(state: rendezvousState);
    return RendezvousListPageViewModel(
      withLoading: rendezvousState is RendezvousLoadingState || rendezvousState is RendezvousNotInitializedState,
      withFailure: rendezvousState is RendezvousFailureState,
      withEmptyMessage: _isEmpty(rendezvousState),
      items: items,
      onRetry: () => store.dispatch(RendezvousRequestAction()),
      deeplinkRendezvous: _deeplinkRendezvous(items, store.state.deepLinkState),
      onDeeplinkUsed: () => store.dispatch(ResetDeeplinkAction()),
    );
  }

  @override
  List<Object?> get props => [withLoading, withFailure, withEmptyMessage, items, deeplinkRendezvous];
}

bool _isEmpty(RendezvousState state) => state is RendezvousSuccessState && state.rendezvous.isEmpty;

List<RendezvousViewModel> _items({required RendezvousState state}) {
  if (state is RendezvousSuccessState) {
    final rendezvous = state.rendezvous;
    rendezvous.sort((a, b) => b.date.compareTo(a.date));
    return rendezvous.map((rdv) => RendezvousViewModel.create(rdv)).toList();
  }
  return [];
}

RendezvousViewModel? _deeplinkRendezvous(List<RendezvousViewModel> viewModels, DeepLinkState state) {
  if (state.deepLink == DeepLink.ROUTE_TO_RENDEZVOUS) return viewModels.firstWhereOrNull((e) => e.id == state.dataId);
  return null;
}
