import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/current_week_rendezvous_list_builder.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/future_months_rendezvous_list_builder.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/future_week_rendezvous_list_builder.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/past_rendezvous_list_builder.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/rendezvous_list_view_model.dart';

abstract class RendezVousListBuilder {
  String makeTitle();

  String makeDateLabel(int pageOffset, RendezvousState rendezvousState, DateTime now);

  String makeEmptyLabel(int pageOffset, RendezvousState rendezvousState, DateTime now);

  String makeAnalyticsLabel(int pageOffset);

  List<RendezVousItem> rendezvousItems(
    RendezvousState rendezvousState,
    LoginState loginState,
    DateTime now,
    int pageOffset,
  );

  factory RendezVousListBuilder.create(int pageOffset) {
    if (pageOffset.isInPast()) {
      return PastRendezVousListBuilder();
    } else if (pageOffset.isThisWeek()) {
      return CurrentWeekRendezVousListBuilder();
    } else if (pageOffset >= 1 && pageOffset < 5) {
      return FutureWeekRendezVousListBuilder();
    } else {
      return FutureMonthsRendezVousListBuilder();
    }
  }

  static bool hasPreviousPage(int pageOffset) => pageOffset >= 0;

  static bool hasNextPage(int pageOffset) => pageOffset < 5;
}

extension _PageOffsetExtension on int {
  bool isInPast() => this < 0;

  bool isThisWeek() => this == 0;
}

extension RendezvousIterableExtension on Iterable<Rendezvous> {
  List<Rendezvous> sortedFromRecentToOldest() => sorted((a, b) => b.date.compareTo(a.date));

  List<Rendezvous> sortedFromRecentToFuture() => sorted((a, b) => a.date.compareTo(b.date));

  Iterable<Rendezvous> filterSemaineGlissante(int pageOffset, DateTime now) {
    final firstDay = DateUtils.dateOnly(now.add(Duration(days: 7 * pageOffset)));
    final lastDay = DateUtils.dateOnly(now.add(Duration(days: (7 * pageOffset) + 7)));
    return where((element) => (element.date.isAfter(firstDay) && element.date.isBefore(lastDay)));
  }

  Iterable<Rendezvous> filterAfterFourWeeks(DateTime now) {
    final firstDay = DateUtils.dateOnly(now.add(Duration(days: 7 * 5)));
    return where((element) => element.date.isAfter(firstDay));
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
