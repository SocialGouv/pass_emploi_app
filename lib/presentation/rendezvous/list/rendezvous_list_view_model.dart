import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/rendezvous/list/rendezvous_list_actions.dart';
import 'package:pass_emploi_app/features/rendezvous/list/rendezvous_list_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/rendezvous_list_builder.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class RendezvousListViewModel extends Equatable {
  final int pageOffset;
  final DisplayState displayState;
  final List<RendezvousItem> rendezvousItems;
  final Function() onRetry;
  final bool withPreviousPageButton;
  final bool withNextPageButton;
  final bool isReloading;
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
    required this.onRetry,
    required this.withPreviousPageButton,
    required this.withNextPageButton,
    required this.isReloading,
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
      rendezvousItems: _makeRendezvousItems(
        rendezvous: builder.makeSections(),
        dateDerniereMiseAJour: rendezvousListState.dateDerniereMiseAJour,
      ),
      onRetry: () => _retry(store, pageOffset),
      title: builder.makeTitle(),
      dateLabel: builder.makeDateLabel(),
      withPreviousPageButton: RendezVousListBuilder.hasPreviousPage(pageOffset, store.state.loginState),
      withNextPageButton: RendezVousListBuilder.hasNextPage(pageOffset),
      isReloading: rendezvousListState.futurRendezVousStatus == RendezvousListStatus.RELOADING,
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
        rendezvousItems,
        withPreviousPageButton,
        withNextPageButton,
        isReloading,
        nextRendezvousPageOffset,
      ];
}

List<RendezvousItem> _makeRendezvousItems({
  required List<RendezvousSection> rendezvous,
  DateTime? dateDerniereMiseAJour,
}) {
  return [
    if (dateDerniereMiseAJour != null) RendezvousNotUpToDateItem(),
    ...rendezvous,
  ];
}

DisplayState _displayState(RendezvousListState state, int pageOffset) {
  if (state.isNotInitialized()) return DisplayState.LOADING;
  if (pageOffset.isInPast()) {
    if (state.pastRendezVousStatus == RendezvousListStatus.LOADING) return DisplayState.LOADING;
    if (state.pastRendezVousStatus == RendezvousListStatus.RELOADING) return DisplayState.LOADING;
    if (state.pastRendezVousStatus == RendezvousListStatus.SUCCESS) return DisplayState.CONTENT;
    return DisplayState.FAILURE;
  } else {
    if (state.futurRendezVousStatus == RendezvousListStatus.LOADING) return DisplayState.LOADING;
    if (state.futurRendezVousStatus == RendezvousListStatus.RELOADING) return DisplayState.LOADING;
    if (state.futurRendezVousStatus == RendezvousListStatus.SUCCESS) return DisplayState.CONTENT;
    return DisplayState.FAILURE;
  }
}

void _retry(Store<AppState> store, int pageOffset) {
  if (pageOffset.isInPast()) {
    store.dispatch(RendezvousListRequestReloadAction(RendezvousPeriod.PASSE, forceRefresh: true));
  } else {
    store.dispatch(RendezvousListRequestReloadAction(RendezvousPeriod.FUTUR, forceRefresh: true));
  }
}

abstract class RendezvousItem extends Equatable {
  @override
  List<Object?> get props => [];
}

class RendezvousSection extends RendezvousItem {
  final String title;
  final List<RendezvousListId> displayedRendezvous;
  final List<RendezvousListId> expandableRendezvous;

  RendezvousSection({required this.title, required this.displayedRendezvous, this.expandableRendezvous = const []});

  RendezvousSection.normal({required this.title, required List<RendezvousListId> rendezvous})
      : displayedRendezvous = rendezvous,
        expandableRendezvous = [];

  factory RendezvousSection.expandable({
    required String title,
    required List<RendezvousListId> rendezvous,
    required int count,
  }) {
    return RendezvousSection(
      title: title,
      displayedRendezvous: rendezvous.take(count).toList(),
      expandableRendezvous: rendezvous.skip(count).toList(),
    );
  }

  @override
  List<Object?> get props => [title, displayedRendezvous, expandableRendezvous];
}

class RendezvousNotUpToDateItem extends RendezvousItem {}

sealed class RendezvousListId extends Equatable {
  final String id;

  RendezvousListId(this.id);

  @override
  List<Object?> get props => [id];
}

class RendezvousId extends RendezvousListId {
  RendezvousId(super.id);
}

class SessionMiloId extends RendezvousListId {
  SessionMiloId(super.id);
}
