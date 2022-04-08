import "package:collection/collection.dart";
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_actions.dart';
import 'package:pass_emploi_app/features/deep_link/deep_link_state.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_actions.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:redux/redux.dart';

class RendezvousListViewModel extends Equatable {
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
  final String analyticsLabel;

  RendezvousListViewModel({
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
    required this.analyticsLabel,
  });

  factory RendezvousListViewModel.create(Store<AppState> store, DateTime now, int weekOffset) {
    final loginState = store.state.loginState;
    final rendezvousState = store.state.rendezvousState;
    final rendezvousItems = _rendezvousItems(rendezvousState, loginState, now, weekOffset);
    return RendezvousListViewModel(
      displayState: _displayState(rendezvousState),
      rendezvousItems: rendezvousItems,
      deeplinkRendezvousId: _deeplinkRendezvousId(store.state.deepLinkState, rendezvousState),
      onRetry: () => store.dispatch(RendezvousRequestAction()),
      onDeeplinkUsed: () => store.dispatch(ResetDeeplinkAction()),
      title: _buildTitle(weekOffset),
      dateLabel: _buildDateLabel(now, weekOffset, rendezvousState),
      withNextButton: _withNextButton(rendezvousState, now, weekOffset),
      withPreviousButton: weekOffset >= 0,
      emptyLabel: _emptyLabel(weekOffset, rendezvousState, now),
      analyticsLabel: _analyticsLabel(weekOffset),
    );
  }

  @override
  List<Object?> get props => [displayState, rendezvousItems, deeplinkRendezvousId];
}

String _analyticsLabel(int weekOffset) {
  if (weekOffset.isInPast()) return AnalyticsScreenNames.rendezvousListPast;
  return AnalyticsScreenNames.rendezvousListWeek + weekOffset.toString();
}

DisplayState _displayState(RendezvousState state) {
  if (state is RendezvousNotInitializedState) return DisplayState.LOADING;
  if (state is RendezvousLoadingState) return DisplayState.LOADING;
  if (state is RendezvousSuccessState && state.rendezvous.isNotEmpty) return DisplayState.CONTENT;
  if (state is RendezvousSuccessState && state.rendezvous.isEmpty) return DisplayState.EMPTY;
  return DisplayState.FAILURE;
}

String _buildDateLabel(DateTime now, int weekOffset, RendezvousState rdvState) {
  if (weekOffset.isInPast()) {
    return _pastDateLabel(rdvState, now);
  } else {
    final firstDay = now.add(Duration(days: 7 * weekOffset)).toDay();
    final lastDay = now.add(Duration(days: (7 * weekOffset) + 6)).toDay();
    return "$firstDay au $lastDay";
  }
}

String _pastDateLabel(RendezvousState rdvState, DateTime now) {
  if (rdvState is! RendezvousSuccessState) return "";
  if (rdvState.rendezvous.isEmpty) return "";

  final oldestRendezvousDate =
      rdvState.rendezvous.reduce((value, element) => value.date.isAfter(element.date) ? element : value).date;
  
  if (oldestRendezvousDate.isInPreviousDay(now)) {
    return Strings.rendezvousSinceDate(oldestRendezvousDate.toDay());
  } else {
    return "";
  }
}

bool _withNextButton(RendezvousState rendezvousState, DateTime now, int weekOffset) {
  if (weekOffset.isInPast()) return true;
  if (rendezvousState is! RendezvousSuccessState) return false;
  final lastDay = DateUtils.dateOnly(now.add(Duration(days: (7 * weekOffset) + 7)));
  return rendezvousState.rendezvous.any((element) => element.date.isAfter(lastDay));
}

String _buildTitle(int weekOffset) {
  if (weekOffset.isInPast()) return Strings.rendezVousPassesTitre;
  if (weekOffset.isThisWeek()) return Strings.rendezVousCetteSemaineTitre;
  return Strings.rendezVousFutursTitre;
}

String _emptyLabel(int weekOffset, RendezvousState rendezvousState, DateTime now) {
  if (weekOffset.isInPast()) return Strings.noRendezAvantCetteSemaine;
  if (weekOffset.isThisWeek()) return Strings.noRendezVousCetteSemaineTitre;
  return Strings.noRendezAutreCetteSemainePrefix + _buildDateLabel(now, weekOffset, rendezvousState);
}

List<RendezVousItem> _rendezvousItems(
    RendezvousState rendezvousState, LoginState loginState, DateTime now, int weekOffset) {
  if (rendezvousState is! RendezvousSuccessState) return [];
  final firstDay = DateUtils.dateOnly(now.add(Duration(days: 7 * weekOffset)));
  final lastDay = DateUtils.dateOnly(now.add(Duration(days: (7 * weekOffset) + 7)));

  final rendezvous = rendezvousState.rendezvous;

  if (weekOffset.isInPast()) {
    rendezvous.sortFromRecentToOldest();
  } else {
    rendezvous.sortFromRecentToFuture();
  }

  final filteredRendezVous = rendezvous
      .where((element) => weekOffset.isInPast() || element.date.isAfter(firstDay))
      .where((element) => element.date.isBefore(lastDay));
  final groupByDate = filteredRendezVous.groupListsBy((element) {
    if (weekOffset.isInPast()) {
      return element.date.toFullMonthAndYear();
    } else {
      return element.date.toDayOfWeekWithFullMonthContextualized();
    }
  });
  return groupByDate.keys
      .map((date) => [
            RendezVousDayDivider(date),
            ...groupByDate[date]!.map((e) => RendezVousCardItem(e.id)).toList(),
          ])
      .flattened
      .toList();
}

extension _WeekOffsetExtension on int {
  bool isInPast() {
    return this < 0;
  }

  bool isThisWeek() {
    return this == 0;
  }
}

extension _RendezvousListExtension on List<Rendezvous> {
  void sortFromRecentToOldest() {
    sort((a, b) => b.date.compareTo(a.date));
  }

  void sortFromRecentToFuture() {
    sort((a, b) => a.date.compareTo(b.date));
  }
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

class RendezVousDayDivider extends RendezVousItem {
  final String label;

  RendezVousDayDivider(this.label);

  @override
  List<Object?> get props => [label];
}
