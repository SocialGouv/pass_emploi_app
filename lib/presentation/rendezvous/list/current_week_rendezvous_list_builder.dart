import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/future_months_rendezvous_list_builder.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/future_week_rendezvous_list_builder.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/rendezvous_list_builder.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/rendezvous_list_view_model.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

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
    if (_rendezvousState.futurRendezVousStatus == RendezvousStatus.SUCCESS) {
      if (_rendezvousState.rendezvous.isEmpty) {
        return Strings.noRendezYet;
      } else if (_haveRendezvousPreviousThisWeek(_rendezvousState.rendezvous)) {
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
    if (_rendezvousState.futurRendezVousStatus == RendezvousStatus.SUCCESS && _rendezvousState.rendezvous.isEmpty) {
      return Strings.noRendezYetSubtitle;
    }
    return null;
  }

  @override
  int? nextRendezvousPageOffset() {
    if (_rendezvousState.rendezvous.isEmpty) return null;
    if (rendezvous().isNotEmpty) return null;

    final futureBuilders = [
      FutureWeekRendezVousListBuilder(_rendezvousState, 1, _now),
      FutureWeekRendezVousListBuilder(_rendezvousState, 2, _now),
      FutureWeekRendezVousListBuilder(_rendezvousState, 3, _now),
      FutureWeekRendezVousListBuilder(_rendezvousState, 4, _now),
      FutureMonthsRendezVousListBuilder(_rendezvousState, _now),
    ];

    final index = futureBuilders.indexWhere((element) => element.rendezvous().isNotEmpty);
    return index == -1 ? null : index + 1;
  }

  @override
  String makeAnalyticsLabel() => AnalyticsScreenNames.rendezvousListWeek + _pageOffset.toString();

  @override
  List<RendezvousSection> rendezvous() {
    if (_rendezvousState.futurRendezVousStatus != RendezvousStatus.SUCCESS) return [];

    return _rendezvousState.rendezvous
        .sortedFromRecentToFuture()
        .filteredFromTodayToSunday(_now)
        .sections(groupedBy: (element) => element.date.toDayOfWeekWithFullMonthContextualized());
  }
}
