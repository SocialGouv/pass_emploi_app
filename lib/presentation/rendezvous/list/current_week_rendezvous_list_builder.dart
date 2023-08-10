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
  final RendezvousListStatus _futurRendezVousStatus;
  final List<Rendezvous> _allRendezvous;
  final int _pageOffset;
  final DateTime _now;

  CurrentWeekRendezVousListBuilder(this._futurRendezVousStatus, this._allRendezvous, this._pageOffset, this._now);

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
    if (_futurRendezVousStatus == RendezvousListStatus.SUCCESS) {
      if (_allRendezvous.isEmpty) {
        return Strings.noRendezYet;
      } else if (_haveRendezvousPreviousThisWeek()) {
        return Strings.noMoreRendezVousThisWeek;
      }
    }
    return Strings.noRendezVousCetteSemaineTitre;
  }

  bool _haveRendezvousPreviousThisWeek() {
    return _allRendezvous.any((element) {
      return element.date.isAfter(_now.toMondayOnThisWeek()) && element.date.isBefore(_now);
    });
  }

  @override
  String? makeEmptySubtitleLabel() {
    if (_futurRendezVousStatus == RendezvousListStatus.SUCCESS && _allRendezvous.isEmpty) {
      return Strings.noRendezYetSubtitle;
    }
    return null;
  }

  @override
  int? nextRendezvousPageOffset() {
    if (_allRendezvous.isEmpty) return null;
    if (makeSections().isNotEmpty) return null;

    final futureBuilders = [
      FutureWeekRendezVousListBuilder(_futurRendezVousStatus, _allRendezvous, 1, _now),
      FutureWeekRendezVousListBuilder(_futurRendezVousStatus, _allRendezvous, 2, _now),
      FutureWeekRendezVousListBuilder(_futurRendezVousStatus, _allRendezvous, 3, _now),
      FutureWeekRendezVousListBuilder(_futurRendezVousStatus, _allRendezvous, 4, _now),
      FutureMonthsRendezVousListBuilder(_futurRendezVousStatus, _allRendezvous, _now),
    ];

    final index = futureBuilders.indexWhere((element) => element.makeSections().isNotEmpty);
    return index == -1 ? null : index + 1;
  }

  @override
  String makeAnalyticsLabel() => AnalyticsScreenNames.rendezvousListWeek + _pageOffset.toString();

  @override
  List<RendezvousSection> makeSections() {
    if (_futurRendezVousStatus != RendezvousListStatus.SUCCESS) return [];

    return _allRendezvous
        .sortedFromRecentToFuture()
        .filteredFromTodayToSunday(_now)
        .sections(groupedBy: (element) => element.date.toDayOfWeekWithFullMonthContextualized());
  }
}
