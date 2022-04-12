import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/rendezvous_list_builder.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/rendezvous_list_view_model.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

class FutureWeekRendezVousListBuilder implements RendezVousListBuilder {
  final RendezvousState rendezvousState;
  final int pageOffset;
  final DateTime now;

  FutureWeekRendezVousListBuilder(this.rendezvousState, this.pageOffset, this.now);

  @override
  String makeTitle() => Strings.rendezSemaineTitre;

  @override
  String makeDateLabel() {
    final firstDay = now.addWeeks(pageOffset).toMondayOnThisWeek().toDay();
    final lastDay = now.addWeeks(pageOffset).toSundayOnThisWeek().toDay();
    return "$firstDay au $lastDay";
  }

  @override
  String makeEmptyLabel() {
    return Strings.noRendezAutreCetteSemainePrefix + makeDateLabel();
  }

  @override
  String makeAnalyticsLabel() => AnalyticsScreenNames.rendezvousListWeek + pageOffset.toString();

  @override
  List<RendezVousItem> rendezvousItems() {
    final rendezvousState = this.rendezvousState;
    if (rendezvousState is! RendezvousSuccessState) return [];

    return rendezvousState.rendezvous
        .sortedFromRecentToFuture()
        .filteredOnWeek(pageOffset, now)
        .groupedItems(groupedBy: (element) => element.date.toDayOfWeekWithFullMonthContextualized());
  }
}
