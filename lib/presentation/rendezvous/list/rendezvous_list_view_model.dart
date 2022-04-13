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
  final List<RendezVousItem> rendezvousItems;
  final String? deeplinkRendezvousId;
  final Function() onRetry;
  final Function() onDeeplinkUsed;
  final bool withPreviousButton;
  final bool withNextButton;
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
    this.withPreviousButton = false,
    this.withNextButton = false,
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
      displayState: _displayState(rendezvousState),
      rendezvousItems: builder.rendezvousItems(),
      deeplinkRendezvousId: _deeplinkRendezvousId(store.state.deepLinkState, rendezvousState),
      onRetry: () => store.dispatch(RendezvousRequestAction()),
      onDeeplinkUsed: () => store.dispatch(ResetDeeplinkAction()),
      title: builder.makeTitle(),
      dateLabel: builder.makeDateLabel(),
      withPreviousButton: RendezVousListBuilder.hasPreviousPage(pageOffset, rendezvousState, now),
      withNextButton: RendezVousListBuilder.hasNextPage(pageOffset, rendezvousState, now),
      emptyLabel: builder.makeEmptyLabel(),
      emptySubtitleLabel: builder.makeEmptySubtitleLabel(),
      analyticsLabel: builder.makeAnalyticsLabel(),
    );
  }

  @override
  List<Object?> get props => [pageOffset, displayState, rendezvousItems, deeplinkRendezvousId];
}

DisplayState _displayState(RendezvousState state) {
  if (state is RendezvousNotInitializedState) return DisplayState.LOADING;
  if (state is RendezvousLoadingState) return DisplayState.LOADING;
  if (state is RendezvousSuccessState) return DisplayState.CONTENT;
  return DisplayState.FAILURE;
}

String? _deeplinkRendezvousId(DeepLinkState state, RendezvousState rendezVousState) {
  if (rendezVousState is! RendezvousSuccessState) return null;
  final rdvIds = rendezVousState.rendezvous.map((e) => e.id);
  return (state.deepLink == DeepLink.ROUTE_TO_RENDEZVOUS && rdvIds.contains(state.dataId)) ? state.dataId : null;
}

abstract class RendezVousItem extends Equatable {}

class RendezVousCardItem extends RendezVousItem {
  final String id;

  RendezVousCardItem(this.id);

  @override
  List<Object?> get props => [id];
}

class RendezVousDivider extends RendezVousItem {
  final String label;

  RendezVousDivider(this.label);

  @override
  List<Object?> get props => [label];
}
