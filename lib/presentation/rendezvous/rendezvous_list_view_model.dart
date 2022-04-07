import "package:collection/collection.dart";
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_actions.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:redux/redux.dart';

class RendezvousListViewModel extends Equatable {
  final DisplayState displayState;
  final List<RendezVousItem> rendezvousIds;
  final String? deeplinkRendezvousId;
  final Function() onRetry;
  final Function() onDeeplinkUsed;
  final bool withPreviousButton;
  final bool withNextButton;
  final String title;
  final String dateLabel;
  final String emptyLabel;

  RendezvousListViewModel({
    required this.displayState,
    required this.rendezvousIds,
    required this.deeplinkRendezvousId,
    required this.onRetry,
    required this.onDeeplinkUsed,
    this.withPreviousButton = false,
    this.withNextButton = false,
    required this.title,
    required this.dateLabel,
    required this.emptyLabel,
  });

  factory RendezvousListViewModel.create(Store<AppState> store, DateTime now, int offset) {
    final loginState = store.state.loginState;
    final rendezvousState = store.state.rendezvousState;
    final rendezvousIds = _rendezvousIds(rendezvousState, loginState, now, offset);
    return RendezvousListViewModel(
      displayState: _displayState(rendezvousState),
      rendezvousIds: rendezvousIds,
      deeplinkRendezvousId: _deeplinkRendezvousId(store.state.deepLinkState, rendezvousState),
      onRetry: () => store.dispatch(RendezvousRequestAction()),
      onDeeplinkUsed: () => store.dispatch(ResetDeeplinkAction()),
      title: _buildTitle(offset),
      dateLabel: _buildDateLabel(now, offset),
      withNextButton: _withNextButton(rendezvousState, now, offset),
      withPreviousButton: offset >= 0,
      emptyLabel: _emptyLabel(offset, rendezvousState, now),
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

String _buildDateLabel(DateTime now, int offset) {
  if (offset < 0) {
    return "du 01/01/2022 à hier";
  } else {
    final firstDay = now.add(Duration(days: 7 * offset)).toDay();
    final lastDay = now.add(Duration(days: (7 * offset) + 6)).toDay();
    return "$firstDay au $lastDay";
  }
}

bool _withNextButton(RendezvousState rendezvousState, DateTime now, int offset) {
  if (offset < 0) return true;
  if (rendezvousState is! RendezvousSuccessState) return false;
  final lastDay = DateUtils.dateOnly(now.add(Duration(days: (7 * offset) + 7)));
  return rendezvousState.rendezvous.any((element) => element.date.isAfter(lastDay));
}

String _buildTitle(int offset) {
  if (offset < 0) return Strings.rendezVousPassesTitre;
  if (offset == 0) return Strings.rendezVousCetteSemaineTitre;
  return Strings.rendezVousFutursTitre;
}

String _emptyLabel(int offset, RendezvousState rendezvousState, DateTime now) {
  if (offset < 0) return Strings.noRendezAvantCetteSemaine;
  if (offset == 0) return Strings.noRendezVousCetteSemaineTitre;
  return Strings.noRendezAutreCetteSemainePrefix + _buildDateLabel(now, offset);
}

List<RendezVousItem> _rendezvousIds(RendezvousState rendezvousState, LoginState loginState, DateTime now, int offset) {
  if (rendezvousState is! RendezvousSuccessState) return [];
  final firstDay = DateUtils.dateOnly(now.add(Duration(days: 7 * offset)));
  final lastDay = DateUtils.dateOnly(now.add(Duration(days: (7 * offset) + 7)));

  final rendezvous = rendezvousState.rendezvous;

  if (offset >= 0) {
    rendezvous.sort((a, b) => a.date.compareTo(b.date));
  } else {
    rendezvous.sort((a, b) => b.date.compareTo(a.date));
  }

  final filteredRendezVous = rendezvous
      .where((element) => offset < 0 || element.date.isAfter(firstDay))
      .where((element) => element.date.isBefore(lastDay));
  final groupByDate = filteredRendezVous.groupListsBy((element) {
    if (offset < 0) {
      return element.date.toFullMonthAndYear();
    } else {
      return element.date.toDayOfWeekWithFullMonthContextualized();
    }
  });
  return groupByDate.keys
      .map((date) => [
            RendezVousItem(false, date),
            ...groupByDate[date]!.map((e) => RendezVousItem(true, e.id)).toList(),
          ])
      .flattened
      .toList();
}

String? _deeplinkRendezvousId(DeepLinkState state, RendezvousState rendezVousState) {
  if (rendezVousState is! RendezvousSuccessState) return null;
  final rdvIds = rendezVousState.rendezvous.map((e) => e.id);
  return (state.deepLink == DeepLink.ROUTE_TO_RENDEZVOUS && rdvIds.contains(state.dataId)) ? state.dataId : null;
}

class RendezVousItem extends Equatable {
  final bool isRendezVous;
  final String id;

  RendezVousItem(this.isRendezVous, this.id);

  @override
  List<Object?> get props => [isRendezVous, id];
}
