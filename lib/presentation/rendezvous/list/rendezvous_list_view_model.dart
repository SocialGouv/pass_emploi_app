import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/features/rendezvous/list/rendezvous_list_actions.dart';
import 'package:pass_emploi_app/features/rendezvous/list/rendezvous_list_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/rendezvous_list_builder.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class RendezvousListViewModel extends Equatable {
  final int pageOffset;
  final DisplayState displayState;
  final List<RendezvousSection> rendezvous;
  final String? deeplinkRendezvousId;
  final Function() onRetry;
  final Function() onDeeplinkUsed;
  final bool withPreviousPageButton;
  final bool withNextPageButton;
  final bool withNotUpToDateMessage;
  final int? nextRendezvousPageOffset;
  final String title;
  final String dateLabel;
  final String emptyLabel;
  final String? emptySubtitleLabel;
  final String analyticsLabel;

  RendezvousListViewModel({
    required this.pageOffset,
    required this.displayState,
    required this.rendezvous,
    required this.deeplinkRendezvousId,
    required this.onRetry,
    required this.onDeeplinkUsed,
    required this.withPreviousPageButton,
    required this.withNextPageButton,
    required this.withNotUpToDateMessage,
    required this.nextRendezvousPageOffset,
    required this.title,
    required this.dateLabel,
    required this.emptyLabel,
    required this.emptySubtitleLabel,
    required this.analyticsLabel,
  });

  factory RendezvousListViewModel.create(Store<AppState> store, DateTime now, int pageOffset) {
    final rendezvousListState = store.state.rendezvousListState;
    final builder = RendezVousListBuilder.create(rendezvousListState, pageOffset, now);
    return RendezvousListViewModel(
      pageOffset: pageOffset,
      displayState: _displayState(rendezvousListState, pageOffset),
      rendezvous: builder.rendezvous(),
      deeplinkRendezvousId: _deeplinkRendezvousId(store.state.deepLinkState, rendezvousListState),
      onRetry: () => _retry(store, pageOffset),
      onDeeplinkUsed: () => store.dispatch(ResetDeeplinkAction()),
      title: builder.makeTitle(),
      dateLabel: builder.makeDateLabel(),
      withPreviousPageButton: RendezVousListBuilder.hasPreviousPage(pageOffset, store.state.loginState),
      withNextPageButton: RendezVousListBuilder.hasNextPage(pageOffset),
      withNotUpToDateMessage: rendezvousListState.dateDerniereMiseAJour != null,
      nextRendezvousPageOffset: builder.nextRendezvousPageOffset(),
      emptyLabel: builder.makeEmptyLabel(),
      emptySubtitleLabel: builder.makeEmptySubtitleLabel(),
      analyticsLabel: builder.makeAnalyticsLabel(),
    );
  }

  static void fetchRendezvous(Store<AppState> store, int pageOffset) {
    final rendezvousListState = store.state.rendezvousListState;
    if (pageOffset.isInPast()) {
      if (rendezvousListState.pastRendezVousStatus == RendezvousListStatus.NOT_INITIALIZED) {
        store.dispatch(RendezvousListRequestAction(RendezvousPeriod.PASSE));
      }
    } else {
      if (rendezvousListState.futurRendezVousStatus == RendezvousListStatus.NOT_INITIALIZED) {
        store.dispatch(RendezvousListRequestAction(RendezvousPeriod.FUTUR));
      }
    }
  }

  @override
  List<Object?> get props => [
        pageOffset,
        displayState,
        rendezvous,
        deeplinkRendezvousId,
        withPreviousPageButton,
        withNextPageButton,
        nextRendezvousPageOffset,
      ];
}

DisplayState _displayState(RendezvousListState state, int pageOffset) {
  if (state.isNotInitialized()) return DisplayState.LOADING;
  if (pageOffset.isInPast()) {
    if (state.pastRendezVousStatus == RendezvousListStatus.LOADING) return DisplayState.LOADING;
    if (state.pastRendezVousStatus == RendezvousListStatus.SUCCESS) return DisplayState.CONTENT;
    return DisplayState.FAILURE;
  } else {
    if (state.futurRendezVousStatus == RendezvousListStatus.LOADING) return DisplayState.LOADING;
    if (state.futurRendezVousStatus == RendezvousListStatus.SUCCESS) return DisplayState.CONTENT;
    return DisplayState.FAILURE;
  }
}

void _retry(Store<AppState> store, int pageOffset) {
  if (pageOffset.isInPast()) {
    store.dispatch(RendezvousListRequestAction(RendezvousPeriod.PASSE));
  } else {
    store.dispatch(RendezvousListRequestAction(RendezvousPeriod.FUTUR));
  }
}

String? _deeplinkRendezvousId(DeepLinkState state, RendezvousListState rendezvousListState) {
  final rdvIds = rendezvousListState.rendezvous.map((e) => e.id);
  return (state is DetailRendezvousDeepLinkState && rdvIds.contains(state.idRendezvous)) ? state.idRendezvous : null;
}

class RendezvousSection extends Equatable {
  final String title;
  final List<String> displayedRendezvous;
  final List<String> expandableRendezvous;

  RendezvousSection({required this.title, required this.displayedRendezvous, this.expandableRendezvous = const []});

  RendezvousSection.normal({required this.title, required List<String> rendezvous})
      : displayedRendezvous = rendezvous,
        expandableRendezvous = [];

  factory RendezvousSection.expandable({required String title, required List<String> rendezvous, required int count}) {
    return RendezvousSection(
      title: title,
      displayedRendezvous: rendezvous.take(count).toList(),
      expandableRendezvous: rendezvous.skip(count).toList(),
    );
  }

  @override
  List<Object?> get props => [title, displayedRendezvous, expandableRendezvous];
}
