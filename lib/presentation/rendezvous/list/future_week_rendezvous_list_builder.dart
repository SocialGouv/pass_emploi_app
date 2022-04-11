import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/rendezvous_list_builder.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/rendezvous_list_view_model.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

class FutureWeekRendezVousListBuilder implements RendezVousListBuilder {
  @override
  String makeTitle() => Strings.rendezVousFutursTitre;

  @override
  String makeDateLabel(int pageOffset, RendezvousState rendezvousState, DateTime now) {
    final firstDay = now.add(Duration(days: 7 * pageOffset)).toDay();
    final lastDay = now.add(Duration(days: (7 * pageOffset) + 6)).toDay();
    return "$firstDay au $lastDay";
  }

  @override
  String makeEmptyLabel(int pageOffset, RendezvousState rendezvousState, DateTime now) {
    return Strings.noRendezAutreCetteSemainePrefix + makeDateLabel(pageOffset, rendezvousState, now);
  }

  @override
  String makeAnalyticsLabel(int pageOffset) => AnalyticsScreenNames.rendezvousListWeek + pageOffset.toString();

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
        .filterSemaineGlissante(pageOffset, now)
        .groupedItemsBy((element) => element.date.toDayOfWeekWithFullMonthContextualized());
  }
}
