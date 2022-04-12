import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/rendezvous_list_builder.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/rendezvous_list_view_model.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

class CurrentWeekRendezVousListBuilder implements RendezVousListBuilder {
  final RendezvousState rendezvousState;
  final int pageOffset;
  final DateTime now;

  CurrentWeekRendezVousListBuilder(this.rendezvousState, this.pageOffset, this.now);

  @override
  String makeTitle() => Strings.rendezVousCetteSemaineTitre;

  @override
  String makeDateLabel() {
    final firstDay = now.toMondayOnThisWeek().toDay();
    final lastDay = now.toSundayOnThisWeek().toDay();
    return "$firstDay au $lastDay";
  }

  @override
  String makeEmptyLabel() {
    return Strings.noRendezVousCetteSemaineTitre;
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
