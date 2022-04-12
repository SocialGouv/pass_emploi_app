import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/rendezvous_list_builder.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/rendezvous_list_view_model.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

class FutureMonthsRendezVousListBuilder implements RendezVousListBuilder {
  @override
  String makeTitle() => Strings.rendezVousFutursTitre;

  @override
  String makeDateLabel(int pageOffset, RendezvousState rendezvousState, DateTime now) {
    final startingDay = now.addWeeks(5).toMondayOnThisWeek().toDay();
    return Strings.rendezvousStartingAtDate(startingDay);
  }

  @override
  String makeEmptyLabel(int pageOffset, RendezvousState rendezvousState, DateTime now) {
    return Strings.noRendezVousFutur;
  }

  @override
  String makeAnalyticsLabel(int pageOffset) => AnalyticsScreenNames.rendezvousListFuture;

  @override
  List<RendezVousItem> rendezvousItems(
    RendezvousState rendezvousState,
    LoginState loginState,
    DateTime now,
    int pageOffset,
  ) {
    if (rendezvousState is! RendezvousSuccessState) return [];

    return rendezvousState.rendezvous
        .sortedFromRecentToFuture()
        .filteredAfterFourWeeks(now)
        .groupedItems(displayCount: true, groupedBy: (element) => element.date.toFullMonthAndYear());
  }
}
