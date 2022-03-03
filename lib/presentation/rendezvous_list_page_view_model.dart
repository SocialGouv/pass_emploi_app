import 'dart:ffi';

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
  final String? idRendezVousFromDeeplink;

  RendezvousListPageViewModel({
    required this.withLoading,
    required this.withFailure,
    required this.withEmptyMessage,
    required this.items,
    required this.onRetry,
    this.idRendezVousFromDeeplink,
    required this.onDeeplinkUsed,
  });

  factory RendezvousListPageViewModel.create(Store<AppState> store) {
    final DeepLinkState link = store.state.deepLinkState;
    final rendezvousState = store.state.rendezvousState;
    return RendezvousListPageViewModel(
      withLoading: rendezvousState.isLoading() || rendezvousState.isNotInitialized(),
      withFailure: rendezvousState.isFailure(),
      withEmptyMessage: _isEmpty(rendezvousState),
      items: _items(state: rendezvousState),
      onRetry: () => store.dispatch(RendezvousAction.request(Void)),
      idRendezVousFromDeeplink: link.deepLink == DeepLink.ROUTE_TO_RENDEZVOUS ? link.dataId : null,
      onDeeplinkUsed: () => store.dispatch(ResetDeeplinkAction()),
    );
  }

  @override
  List<Object?> get props => [withLoading, withFailure, withEmptyMessage, items, idRendezVousFromDeeplink];
}

bool _isEmpty(State<List<Rendezvous>> state) => state.isSuccess() && state.getResultOrThrow().isEmpty;

List<RendezvousViewModel> _items({required State<List<Rendezvous>> state}) {
  if (state.isSuccess()) {
    final rendezVousList = state.getResultOrThrow();
    rendezVousList.sort((a, b) => b.date.compareTo(a.date));
    return rendezVousList.map((rdv) => RendezvousViewModel.create(rdv)).toList();
  }
  return [];
}
