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
    final builder = RendezVousListBuilderFactory.create(weekOffset);
    return RendezvousListViewModel(
      displayState: _displayState(rendezvousState),
      rendezvousItems: builder.rendezvousItems(rendezvousState, loginState, now, weekOffset),
      deeplinkRendezvousId: _deeplinkRendezvousId(store.state.deepLinkState, rendezvousState),
      onRetry: () => store.dispatch(RendezvousRequestAction()),
      onDeeplinkUsed: () => store.dispatch(ResetDeeplinkAction()),
      title: builder.makeTitle(),
      dateLabel: builder.makeDateLabel(weekOffset, rendezvousState, now),
      withNextButton: weekOffset < 5,
      withPreviousButton: weekOffset >= 0,
      emptyLabel: builder.makeEmptyLabel(weekOffset, rendezvousState, now),
      analyticsLabel: builder.makeAnalyticsLabel(weekOffset),
    );
  }

  @override
  List<Object?> get props => [displayState, rendezvousItems, deeplinkRendezvousId];
}

DisplayState _displayState(RendezvousState state) {
  if (state is RendezvousNotInitializedState) return DisplayState.LOADING;
  if (state is RendezvousLoadingState) return DisplayState.LOADING;
  if (state is RendezvousSuccessState && state.rendezvous.isNotEmpty) return DisplayState.CONTENT;
  if (state is RendezvousSuccessState && state.rendezvous.isEmpty) return DisplayState.EMPTY;
  return DisplayState.FAILURE;
}

extension _WeekOffsetExtension on int {
  bool isInPast() {
    return this < 0;
  }

  bool isThisWeek() {
    return this == 0;
  }
}

extension _RendezvousIterableExtension on Iterable<Rendezvous> {
  List<Rendezvous> sortedFromRecentToOldest() {
    return sorted((a, b) => b.date.compareTo(a.date));
  }

  List<Rendezvous> sortedFromRecentToFuture() {
    return sorted((a, b) => a.date.compareTo(b.date));
  }

  List<RendezVousItem> groupedItemsBy(String Function(Rendezvous) fn) {
    final groupedRendezvous = groupListsBy(fn);
    return groupedRendezvous.keys
        .map((date) => [
      RendezVousDivider(date),
      ...groupedRendezvous[date]!.map((e) => RendezVousCardItem(e.id)).toList(),
    ])
        .flattened
        .toList();
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

class RendezVousDivider extends RendezVousItem {
  final String label;

  RendezVousDivider(this.label);

  @override
  List<Object?> get props => [label];
}


class RendezVousListBuilderFactory {
  static RendezVousListBuilder create(int weekOffset) {
    if (weekOffset.isInPast()) {
      return PastRendezVousListBuilder();
    } else if (weekOffset.isThisWeek()) {
      return CurrentWeekRendezVousListBuilder();
    }
    return FutureWeekRendezVousListBuilder();
  }
}

abstract class RendezVousListBuilder {
  String makeTitle();

  String makeDateLabel(int weekOffset, RendezvousState rendezvousState, DateTime now);

  String makeEmptyLabel(int weekOffset, RendezvousState rendezvousState, DateTime now);

  String makeAnalyticsLabel(int weekOffset);

  List<RendezVousItem> rendezvousItems(
      RendezvousState rendezvousState, LoginState loginState, DateTime now, int weekOffset);
}

class PastRendezVousListBuilder implements RendezVousListBuilder {
  @override
  String makeTitle() => Strings.rendezVousPassesTitre;

  @override
  String makeDateLabel(int weekOffset, RendezvousState rendezvousState, DateTime now) {
    if (rendezvousState is! RendezvousSuccessState) return "";
    if (rendezvousState.rendezvous.isEmpty) return "";

    final oldestRendezvousDate =
        rendezvousState.rendezvous.reduce((value, element) => value.date.isAfter(element.date) ? element : value).date;

    if (oldestRendezvousDate.isInPreviousDay(now)) {
      return Strings.rendezvousSinceDate(oldestRendezvousDate.toDay());
    } else {
      return "";
    }
  }

  @override
  String makeEmptyLabel(int weekOffset, RendezvousState rendezvousState, DateTime now) =>
      Strings.noRendezAvantCetteSemaine;

  @override
  String makeAnalyticsLabel(int weekOffset) => AnalyticsScreenNames.rendezvousListPast;

  @override
  List<RendezVousItem> rendezvousItems(
      RendezvousState rendezvousState, LoginState loginState, DateTime now, int weekOffset) {
    if (rendezvousState is! RendezvousSuccessState) return [];

    return rendezvousState.rendezvous
        .sortedFromRecentToOldest()
        .where((element) => element.date.isBefore(DateUtils.dateOnly(now)))
        .groupedItemsBy((element) => element.date.toFullMonthAndYear());
  }
}

class CurrentWeekRendezVousListBuilder implements RendezVousListBuilder {
  @override
  String makeTitle() => Strings.rendezVousCetteSemaineTitre;

  @override
  String makeDateLabel(int weekOffset, RendezvousState rendezvousState, DateTime now) {
    final firstDay = now.toDay();
    final lastDay = now.add(Duration(days: 6)).toDay();
    return "$firstDay au $lastDay";
  }

  @override
  String makeEmptyLabel(int weekOffset, RendezvousState rendezvousState, DateTime now) =>
      Strings.noRendezVousCetteSemaineTitre;

  @override
  String makeAnalyticsLabel(int weekOffset) => AnalyticsScreenNames.rendezvousListWeek + weekOffset.toString();

  @override
  List<RendezVousItem> rendezvousItems(
      RendezvousState rendezvousState, LoginState loginState, DateTime now, int weekOffset) {
    if (rendezvousState is! RendezvousSuccessState) return [];
    final firstDay = DateUtils.dateOnly(now.add(Duration(days: 7 * weekOffset)));
    final lastDay = DateUtils.dateOnly(now.add(Duration(days: (7 * weekOffset) + 7)));


    return rendezvousState.rendezvous
        .sortedFromRecentToFuture()
        .where((element) => (element.date.isAfter(firstDay) && element.date.isBefore(lastDay)))
        .groupedItemsBy((element) => element.date.toDayOfWeekWithFullMonthContextualized());
  }
}

class FutureWeekRendezVousListBuilder implements RendezVousListBuilder {
  @override
  String makeTitle() => Strings.rendezVousFutursTitre;

  @override
  String makeDateLabel(int weekOffset, RendezvousState rendezvousState, DateTime now) {
    final firstDay = now.add(Duration(days: 7 * weekOffset)).toDay();
    final lastDay = now.add(Duration(days: (7 * weekOffset) + 6)).toDay();
    return "$firstDay au $lastDay";
  }

  @override
  String makeEmptyLabel(int weekOffset, RendezvousState rendezvousState, DateTime now) {
    return Strings.noRendezAutreCetteSemainePrefix + makeDateLabel(weekOffset, rendezvousState, now);
  }

  @override
  String makeAnalyticsLabel(int weekOffset) => AnalyticsScreenNames.rendezvousListWeek + weekOffset.toString();

  @override
  List<RendezVousItem> rendezvousItems(
      RendezvousState rendezvousState, LoginState loginState, DateTime now, int weekOffset) {
    if (rendezvousState is! RendezvousSuccessState) return [];
    final firstDay = DateUtils.dateOnly(now.add(Duration(days: 7 * weekOffset)));
    final lastDay = DateUtils.dateOnly(now.add(Duration(days: (7 * weekOffset) + 7)));


    return rendezvousState.rendezvous
        .sortedFromRecentToFuture()
        .where((element) => (element.date.isAfter(firstDay) && element.date.isBefore(lastDay)))
        .groupedItemsBy((element) => element.date.toDayOfWeekWithFullMonthContextualized());
  }
}
