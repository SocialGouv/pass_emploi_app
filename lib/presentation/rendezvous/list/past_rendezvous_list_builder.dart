import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/features/rendezvous/list/rendezvous_list_state.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/rendezvous_list_builder.dart';
import 'package:pass_emploi_app/presentation/rendezvous/list/rendezvous_list_view_model.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';

class PastRendezVousListBuilder implements RendezVousListBuilder {
  final RendezvousListStatus _pastRendezVousStatus;
  final List<Rendezvous> _allRendezvous;
  final DateTime _now;

  PastRendezVousListBuilder(this._pastRendezVousStatus, this._allRendezvous, this._now);

  @override
  String makeTitle() => Strings.rendezVousPassesTitre;

  @override
  String makeDateLabel() {
    if (_pastRendezVousStatus != RendezvousListStatus.SUCCESS) return "";

    final oldestRendezvousDate = _oldestRendezvousDate();
    if (oldestRendezvousDate == null) return "";

    if (oldestRendezvousDate.isInPreviousDay(_now)) {
      return Strings.rendezvousSinceDate(oldestRendezvousDate.toDay());
    } else {
      return "";
    }
  }

  @override
  String makeEmptyLabel() => Strings.noRendezAvantCetteSemaine;

  @override
  String? makeEmptySubtitleLabel() => null;

  @override
  int? nextRendezvousPageOffset() => null;

  @override
  String makeAnalyticsLabel() => AnalyticsScreenNames.rendezvousListPast;

  @override
  List<RendezvousSection> makeSections() {
    if (_pastRendezVousStatus != RendezvousListStatus.SUCCESS) return [];

    return _allRendezvous
        .sortedFromRecentToOldest()
        .where((element) => element.date.isBefore(DateUtils.dateOnly(_now)))
        .sections(displayCount: true, expandable: true, groupedBy: (element) => element.date.toFullMonthAndYear());
  }

  DateTime? _oldestRendezvousDate() {
    if (_allRendezvous.isEmpty) return null;
    return _allRendezvous.reduce((value, element) => value.date.isAfter(element.date) ? element : value).date;
  }
}
