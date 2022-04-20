import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/rendezvous_list_builder.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/rendezvous_list_view_model.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

class FutureMonthsRendezVousListBuilder implements RendezVousListBuilder {
  final RendezvousState _rendezvousState;
  final DateTime _now;

  FutureMonthsRendezVousListBuilder(this._rendezvousState, this._now);

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
  bool withNextRendezvousButton() => false;

  @override
  String makeAnalyticsLabel() => AnalyticsScreenNames.rendezvousListFuture;

  @override
  List<RendezvousItem> rendezvousItems() {
    final rendezvousState = _rendezvousState;
    if (rendezvousState is! RendezvousSuccessState) return [];

    return rendezvousState.rendezvous
        .sortedFromRecentToFuture()
        .filteredAfterFourWeeks(_now)
        .groupedItems(displayCount: true, groupedBy: (element) => element.date.toFullMonthAndYear());
  }
}
