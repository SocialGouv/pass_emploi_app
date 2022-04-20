import 'dart:math';

import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/rendezvous_list_builder.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/rendezvous_list_view_model.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

const int _daysInAWeek = 7;
const int _maxPageOffset = 5;

class CurrentWeekRendezVousListBuilder implements RendezVousListBuilder {
  final RendezvousState _rendezvousState;
  final int _pageOffset;
  final DateTime _now;

  CurrentWeekRendezVousListBuilder(this._rendezvousState, this._pageOffset, this._now);

  @override
  String makeTitle() => Strings.rendezVousCetteSemaineTitre;

  @override
  String makeDateLabel() {
    final firstDay = _now.toMondayOnThisWeek().toDay();
    final lastDay = _now.toSundayOnThisWeek().toDay();
    return "$firstDay au $lastDay";
  }

  @override
  String makeEmptyLabel() {
    final rendezvousState = _rendezvousState;
    if (rendezvousState is RendezvousSuccessState && rendezvousState.rendezvous.isEmpty) return Strings.noRendezYet;
    if (rendezvousState is RendezvousSuccessState && _haveRendezvousPreviousThisWeek(rendezvousState.rendezvous)) {
      return Strings.noMoreRendezVousThisWeek;
    }
    return Strings.noRendezVousCetteSemaineTitre;
  }

  bool _haveRendezvousPreviousThisWeek(List<Rendezvous> rendezvous) {
    return rendezvous.any((element) {
      return element.date.isAfter(_now.toMondayOnThisWeek()) && element.date.isBefore(_now);
    });
  }

  @override
  String? makeEmptySubtitleLabel() {
    final rendezvousState = _rendezvousState;
    if (rendezvousState is RendezvousSuccessState && rendezvousState.rendezvous.isEmpty) {
      return Strings.noRendezYetSubtitle;
    }
    return null;
  }

  @override
  bool withNextRendezvousButton() => nextRendezvousPageOffset() != -1;

  @override
  int nextRendezvousPageOffset() {
    final state = _rendezvousState;
    final List<Rendezvous> rendezvous = state is RendezvousSuccessState ? state.rendezvous : [];
    final sortedRendezvous = rendezvous.sortedFromRecentToFuture();
    final currentWeekRendezvous = sortedRendezvous.filteredFromTodayToSunday(_now);
    final futureRendezvous = sortedRendezvous.where((rdv) => rdv.date.isAfter(_now));
    if (currentWeekRendezvous.isEmpty && futureRendezvous.isNotEmpty) {
      return _futureRendezvousPageOffset(futureRendezvous.first);
    } else {
      return -1;
    }
  }

  int _futureRendezvousPageOffset(Rendezvous futureRendezvous) {
    final nextMonday = _now.toMondayOnNextWeek();
    final differenceInDays = nextMonday.difference(futureRendezvous.date).abs().inDays;
    return min(1 + differenceInDays ~/ _daysInAWeek, _maxPageOffset);
  }

  @override
  String makeAnalyticsLabel() => AnalyticsScreenNames.rendezvousListWeek + _pageOffset.toString();

  @override
  List<RendezvousItem> rendezvousItems() {
    final rendezvousState = _rendezvousState;
    if (rendezvousState is! RendezvousSuccessState) return [];

    return rendezvousState.rendezvous
        .sortedFromRecentToFuture()
        .filteredFromTodayToSunday(_now)
        .groupedItems(groupedBy: (element) => element.date.toDayOfWeekWithFullMonthContextualized());
  }
}
