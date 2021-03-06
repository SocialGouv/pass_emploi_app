import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/auth/auth_id_token.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/current_week_rendezvous_list_builder.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/future_months_rendezvous_list_builder.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/future_week_rendezvous_list_builder.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/past_rendezvous_list_builder.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/rendezvous_list_view_model.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';

abstract class RendezVousListBuilder {
  String makeTitle();

  String makeDateLabel();

  String makeEmptyLabel();

  String? makeEmptySubtitleLabel();

  int? nextRendezvousPageOffset();

  String makeAnalyticsLabel();

  List<RendezvousSection> rendezvous();

  factory RendezVousListBuilder.create(
    RendezvousState rendezvousState,
    int pageOffset,
    DateTime now,
  ) {
    if (pageOffset.isInPast()) {
      return PastRendezVousListBuilder(rendezvousState, now);
    } else if (pageOffset.isThisWeek()) {
      return CurrentWeekRendezVousListBuilder(rendezvousState, pageOffset, now);
    } else if (pageOffset >= 1 && pageOffset < 5) {
      return FutureWeekRendezVousListBuilder(rendezvousState, pageOffset, now);
    } else {
      return FutureMonthsRendezVousListBuilder(rendezvousState, now);
    }
  }

  static bool hasPreviousPage(int pageOffset, LoginState loginState) {
    if (pageOffset > 0) return true;
    if (pageOffset < 0) return false;

    return (loginState is LoginSuccessState && loginState.user.loginMode != LoginMode.POLE_EMPLOI);
  }

  static bool hasNextPage(int pageOffset) => pageOffset < 5;
}

extension PageOffsetExtension on int {
  bool isInPast() => this < 0;

  bool isThisWeek() => this == 0;
}

extension RendezvousIterableExtension on Iterable<Rendezvous> {
  List<Rendezvous> sortedFromRecentToOldest() => sorted((a, b) => b.date.compareTo(a.date));

  List<Rendezvous> sortedFromRecentToFuture() => sorted((a, b) => a.date.compareTo(b.date));

  Iterable<Rendezvous> filteredOnWeek(int pageOffset, DateTime now) {
    final firstDay = DateUtils.dateOnly(now.addWeeks(pageOffset).toMondayOnThisWeek());
    final lastDay = DateUtils.dateOnly(now.addWeeks(pageOffset).toMondayOnNextWeek());
    return where((element) => (element.date.isAfter(firstDay) && element.date.isBefore(lastDay)));
  }

  Iterable<Rendezvous> filteredFromTodayToSunday(DateTime now) {
    final firstDay = DateUtils.dateOnly(now);
    final lastDay = DateUtils.dateOnly(now.toMondayOnNextWeek());
    return where((element) => (element.date.isAfter(firstDay) && element.date.isBefore(lastDay)));
  }

  Iterable<Rendezvous> filteredAfterFourWeeks(DateTime now) {
    final firstDay = DateUtils.dateOnly(now.addWeeks(5).toMondayOnThisWeek());
    return where((element) => element.date.isAfter(firstDay));
  }

  List<RendezvousSection> sections({
    bool displayCount = false,
    bool expandable = false,
    required String Function(Rendezvous) groupedBy,
  }) {
    final groupedRendezvous = groupListsBy(groupedBy);

    return groupedRendezvous.keys.map((date) {
      final title = _title(displayCount, date, groupedRendezvous);
      final rendezvous = groupedRendezvous[date]!.map((e) => e.id).toList();
      if (expandable) {
        return RendezvousSection.expandable(title: title, rendezvous: rendezvous, count: 3);
      } else {
        return RendezvousSection.normal(title: title, rendezvous: rendezvous);
      }
    }).toList();
  }
}

String _title(bool displayCount, String date, Map<String, List<Rendezvous>> groupedRendezvous) {
  final dateLabel = date.firstLetterUpperCased();
  return displayCount ? "$dateLabel (${groupedRendezvous[date]!.length})" : dateLabel;
}
