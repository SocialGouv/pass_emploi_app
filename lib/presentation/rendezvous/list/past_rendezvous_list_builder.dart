import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/rendezvous/rendezvous_state.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/rendezvous_list_builder.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/rendezvous_list_view_model.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

class PastRendezVousListBuilder implements RendezVousListBuilder {
  @override
  String makeTitle() => Strings.rendezVousPassesTitre;

  @override
  String makeDateLabel(int pageOffset, RendezvousState rendezvousState, DateTime now) {
    if (rendezvousState is! RendezvousSuccessState) return "";

    final oldestRendezvousDate = _oldestRendezvousDate(rendezvousState.rendezvous);
    if (oldestRendezvousDate == null) return "";

    if (oldestRendezvousDate.isInPreviousDay(now)) {
      return Strings.rendezvousSinceDate(oldestRendezvousDate.toDay());
    } else {
      return "";
    }
  }

  @override
  String makeEmptyLabel(int pageOffset, RendezvousState rendezvousState, DateTime now) =>
      Strings.noRendezAvantCetteSemaine;

  @override
  String makeAnalyticsLabel(int pageOffset) => AnalyticsScreenNames.rendezvousListPast;

  @override
  List<RendezVousItem> rendezvousItems(
    RendezvousState rendezvousState,
    LoginState loginState,
    DateTime now,
    int pageOffset,
  ) {
    if (rendezvousState is! RendezvousSuccessState) return [];

    return rendezvousState.rendezvous
        .sortedFromRecentToOldest()
        .where((element) => element.date.isBefore(DateUtils.dateOnly(now)))
        .groupedItemsBy((element) => element.date.toFullMonthAndYear());
  }
}

DateTime? _oldestRendezvousDate(List<Rendezvous> list) {
  if (list.isEmpty) return null;
  return list.reduce((value, element) => value.date.isAfter(element.date) ? element : value).date;
}