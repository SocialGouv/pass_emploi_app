import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/features/rendezvous/list/rendezvous_list_state.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/rendezvous_list_builder.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/rendezvous_list_view_model.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

class FutureWeekRendezVousListBuilder implements RendezVousListBuilder {
  final RendezvousListState _rendezvousListState;
  final int _pageOffset;
  final DateTime _now;

  FutureWeekRendezVousListBuilder(this._rendezvousListState, this._pageOffset, this._now);

  @override
  String makeTitle() => Strings.rendezSemaineTitre;

  @override
  String makeDateLabel() {
    final firstDay = _now.addWeeks(_pageOffset).toMondayOnThisWeek().toDay();
    final lastDay = _now.addWeeks(_pageOffset).toSundayOnThisWeek().toDay();
    return "$firstDay au $lastDay";
  }

  @override
  String makeEmptyLabel() {
    return Strings.noRendezAutreCetteSemainePrefix + makeDateLabel();
  }

  @override
  String? makeEmptySubtitleLabel() => null;

  @override
  int? nextRendezvousPageOffset() => null;

  @override
  String makeAnalyticsLabel() => AnalyticsScreenNames.rendezvousListWeek + _pageOffset.toString();

  @override
  List<RendezvousSection> rendezvous() {
    if (_rendezvousListState.futurRendezVousStatus != RendezvousListStatus.SUCCESS) return [];

    return _rendezvousListState.rendezvous
        .sortedFromRecentToFuture()
        .filteredOnWeek(_pageOffset, _now)
        .sections(groupedBy: (element) => element.date.toDayOfWeekWithFullMonthContextualized());
  }
}
