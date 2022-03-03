import 'dart:ffi';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/presentation/rendezvous_view_model.dart';
import 'package:pass_emploi_app/redux/actions/named_actions.dart';
import 'package:pass_emploi_app/redux/states/app_state.dart';
import 'package:pass_emploi_app/redux/states/deep_link_state.dart';
import 'package:pass_emploi_app/redux/states/state.dart';
import 'package:redux/redux.dart';

import '../redux/actions/deep_link_action.dart';

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
      withLoading: rendezvousState.isLoading() || rendezvousState.isNotInitialized(),
      withFailure: rendezvousState.isFailure(),
      withEmptyMessage: _isEmpty(rendezvousState),
      items: items,
      onRetry: () => store.dispatch(RendezvousAction.request(Void)),
      deeplinkRendezvous: _deeplinkRendezvous(items, store.state.deepLinkState),
      onDeeplinkUsed: () => store.dispatch(ResetDeeplinkAction()),
    );
  }

  @override
  List<Object?> get props => [withLoading, withFailure, withEmptyMessage, items, deeplinkRendezvous];
}

bool _isEmpty(State<List<Rendezvous>> state) => state.isSuccess() && state.getResultOrThrow().isEmpty;

List<RendezvousViewModel> _items({required State<List<Rendezvous>> state}) {
  if (state.isSuccess()) {
    final rendezvousList = state.getResultOrThrow();
    rendezvousList.sort((a, b) => b.date.compareTo(a.date));
    return rendezvousList.map((rdv) => RendezvousViewModel.create(rdv)).toList();
  }
  return [];
}

RendezvousViewModel? _deeplinkRendezvous(List<RendezvousViewModel> viewModels, DeepLinkState state) {
  if (state.deepLink == DeepLink.ROUTE_TO_RENDEZVOUS) return viewModels.firstWhereOrNull((e) => e.id == state.dataId);
  return null;
}
