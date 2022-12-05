import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/features/rendezvous/list/rendezvous_list_state.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/future_months_rendezvous_list_builder.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/future_week_rendezvous_list_builder.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/rendezvous_list_builder.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/rendezvous_list_view_model.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

class CurrentWeekRendezVousListBuilder implements RendezVousListBuilder {
  final RendezvousListState _rendezvousListState;
  final int _pageOffset;
  final DateTime _now;

  CurrentWeekRendezVousListBuilder(this._rendezvousListState, this._pageOffset, this._now);

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
    if (_rendezvousListState.futurRendezVousStatus == RendezvousListStatus.SUCCESS) {
      if (_rendezvousListState.rendezvous.isEmpty) {
        return Strings.noRendezYet;
      } else if (_haveRendezvousPreviousThisWeek(_rendezvousListState.rendezvous)) {
        return Strings.noMoreRendezVousThisWeek;
      }
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
    if (_rendezvousListState.futurRendezVousStatus == RendezvousListStatus.SUCCESS &&
        _rendezvousListState.rendezvous.isEmpty) {
      return Strings.noRendezYetSubtitle;
    }
    return null;
  }

  @override
  int? nextRendezvousPageOffset() {
    if (_rendezvousListState.rendezvous.isEmpty) return null;
    if (rendezvous().isNotEmpty) return null;

    final futureBuilders = [
      FutureWeekRendezVousListBuilder(_rendezvousListState, 1, _now),
      FutureWeekRendezVousListBuilder(_rendezvousListState, 2, _now),
      FutureWeekRendezVousListBuilder(_rendezvousListState, 3, _now),
      FutureWeekRendezVousListBuilder(_rendezvousListState, 4, _now),
      FutureMonthsRendezVousListBuilder(_rendezvousListState, _now),
    ];

    final index = futureBuilders.indexWhere((element) => element.rendezvous().isNotEmpty);
    return index == -1 ? null : index + 1;
  }

  @override
  String makeAnalyticsLabel() => AnalyticsScreenNames.rendezvousListWeek + _pageOffset.toString();

  @override
  List<RendezvousSection> rendezvous() {
    if (_rendezvousListState.futurRendezVousStatus != RendezvousListStatus.SUCCESS) return [];

    return _rendezvousListState.rendezvous
        .sortedFromRecentToFuture()
        .filteredFromTodayToSunday(_now)
        .sections(groupedBy: (element) => element.date.toDayOfWeekWithFullMonthContextualized());
  }
}
