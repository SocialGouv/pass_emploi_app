import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_actions.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/rendezvous_list_builder.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class RendezvousListViewModel extends Equatable {
  final int pageOffset;
  final DisplayState displayState;
  final List<RendezvousItem> rendezvousItems;
  final String? deeplinkRendezvousId;
  final Function() onRetry;
  final Function() onDeeplinkUsed;
  final bool withPreviousPageButton;
  final bool withNextPageButton;
  final int? nextRendezvousPageOffset;
  final String title;
  final String dateLabel;
  final String emptyLabel;
  final String? emptySubtitleLabel;
  final String analyticsLabel;

  RendezvousListViewModel({
    required this.pageOffset,
    required this.displayState,
    required this.rendezvousItems,
    required this.deeplinkRendezvousId,
    required this.onRetry,
    required this.onDeeplinkUsed,
    required this.withPreviousPageButton,
    required this.withNextPageButton,
    required this.nextRendezvousPageOffset,
    required this.title,
    required this.dateLabel,
    required this.emptyLabel,
    required this.emptySubtitleLabel,
    required this.analyticsLabel,
  });

  factory RendezvousListViewModel.create(Store<AppState> store, DateTime now, int pageOffset) {
    final rendezvousState = store.state.rendezvousState;
    final builder = RendezVousListBuilder.create(rendezvousState, pageOffset, now);
    return RendezvousListViewModel(
      pageOffset: pageOffset,
      displayState: _displayState(rendezvousState, pageOffset),
      rendezvousItems: builder.rendezvousItems(),
      deeplinkRendezvousId: _deeplinkRendezvousId(store.state.deepLinkState, rendezvousState),
      onRetry: () => store.dispatch(RendezvousRequestAction()),
      onDeeplinkUsed: () => store.dispatch(ResetDeeplinkAction()),
      title: builder.makeTitle(),
      dateLabel: builder.makeDateLabel(),
      withPreviousPageButton: RendezVousListBuilder.hasPreviousPage(pageOffset, store.state.loginState),
      withNextPageButton: RendezVousListBuilder.hasNextPage(pageOffset),
      nextRendezvousPageOffset: builder.nextRendezvousPageOffset(),
      emptyLabel: builder.makeEmptyLabel(),
      emptySubtitleLabel: builder.makeEmptySubtitleLabel(),
      analyticsLabel: builder.makeAnalyticsLabel(),
    );
  }

  @override
  List<Object?> get props =>
      [
        pageOffset,
        displayState,
        rendezvousItems,
        deeplinkRendezvousId,
        withPreviousPageButton,
        withNextPageButton,
        nextRendezvousPageOffset,
      ];
}

DisplayState _displayState(RendezvousState state, int pageOffset) {
  if (state.isNotInitialized()) return DisplayState.LOADING;
  if (pageOffset.isInPast()) {
    if (state.pastRendezVousStatus == RendezvousStatus.LOADING) return DisplayState.LOADING;
    if (state.pastRendezVousStatus == RendezvousStatus.SUCCESS) return DisplayState.CONTENT;
    return DisplayState.FAILURE;
  } else {
    if (state.futurRendezVousStatus == RendezvousStatus.LOADING) return DisplayState.LOADING;
    if (state.futurRendezVousStatus == RendezvousStatus.SUCCESS) return DisplayState.CONTENT;
    return DisplayState.FAILURE;
  }
}

String? _deeplinkRendezvousId(DeepLinkState state, RendezvousState rendezvousState) {
  final rdvIds = rendezvousState.rendezvous.map((e) => e.id);
  return (state.deepLink == DeepLink.ROUTE_TO_RENDEZVOUS && rdvIds.contains(state.dataId)) ? state.dataId : null;
}

abstract class RendezvousItem extends Equatable {}

class RendezvousCardItem extends RendezvousItem {
  final String id;

  RendezvousCardItem(this.id);

  @override
  List<Object?> get props => [id];
}

class RendezvousDivider extends RendezvousItem {
  final String label;

  RendezvousDivider(this.label);

  @override
  List<Object?> get props => [label];
}
