import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/features/rendezvous/list/rendezvous_list_state.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/rendezvous_list_builder.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/rendezvous_list_view_model.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

class FutureMonthsRendezVousListBuilder implements RendezVousListBuilder {
  final RendezvousListStatus _futurRendezVousStatus;
  final List<Rendezvous> _allRendezvous;
  final DateTime _now;

  FutureMonthsRendezVousListBuilder(this._futurRendezVousStatus, this._allRendezvous, this._now);

  @override
  String makeTitle() => Strings.rendezVousFutursTitre;

  @override
  String makeDateLabel() {
    final startingDay = _now.addWeeks(5).toMondayOnThisWeek().toDay();
    return Strings.rendezvousStartingAtDate(startingDay);
  }

  @override
  String makeEmptyLabel() {
    return Strings.noRendezVousFutur;
  }

  @override
  String? makeEmptySubtitleLabel() => null;

  @override
  int? nextRendezvousPageOffset() => null;

  @override
  String makeAnalyticsLabel() => AnalyticsScreenNames.rendezvousListFuture;

  @override
  List<RendezvousSection> makeSections() {
    if (_futurRendezVousStatus != RendezvousListStatus.SUCCESS) return [];

    return _allRendezvous
        .sortedFromRecentToFuture()
        .filteredAfterFourWeeks(_now)
        .sections(displayCount: true, expandable: true, groupedBy: (element) => element.date.toFullMonthAndYear());
  }
}
