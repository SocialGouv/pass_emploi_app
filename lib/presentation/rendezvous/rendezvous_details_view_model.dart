import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_view_model_helper.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/app_colors.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:pass_emploi_app/utils/platform.dart';
import 'package:pass_emploi_app/utils/string_extensions.dart';
import 'package:pass_emploi_app/utils/uri_handler.dart';
import 'package:redux/redux.dart';

class RendezvousDetailsViewModel extends Equatable {
  final String title;
  final String date;
  final String hourAndDuration;
  final String modality;
  final String conseillerPresenceLabel;
  final Color conseillerPresenceColor;
  final String trackingPageName;
  final String? commentTitle;
  final String? comment;
  final String? organism;
  final String? address;
  final Uri? addressRedirectUri;

  RendezvousDetailsViewModel({
    required this.title,
    required this.date,
    required this.hourAndDuration,
    required this.modality,
    required this.conseillerPresenceLabel,
    required this.conseillerPresenceColor,
    required this.trackingPageName,
    this.commentTitle,
    this.comment,
    this.organism,
    this.address,
    this.addressRedirectUri,
  });

  factory RendezvousDetailsViewModel.create(Store<AppState> store, String rdvId, Platform platform) {
    final rdv = getRendezvousFromStore(store, rdvId);
    final comment = (rdv.comment != null && rdv.comment!.trim().isNotEmpty) ? rdv.comment : null;
    return RendezvousDetailsViewModel(
      title: takeTypeLabelOrPrecision(rdv),
      date: rdv.date.toDayWithFullMonthContextualized(),
      hourAndDuration: "${rdv.date.toHour()} (${_toDuration(rdv.duration)})",
      modality: Strings.rendezvousModalityMessage(rdv.modality.firstLetterLowerCased()),
      conseillerPresenceLabel: rdv.withConseiller ? Strings.conseillerIsPresent : Strings.conseillerIsNotPresent,
      conseillerPresenceColor: rdv.withConseiller ? AppColors.secondary : AppColors.warning,
      trackingPageName: _trackingPageName(rdv.type.code),
      commentTitle: _commentTitle(rdv, comment),
      comment: comment,
      organism: rdv.organism,
      address: rdv.address,
      addressRedirectUri: rdv.address != null ? UriHandler().mapsUri(rdv.address!, platform) : null,
    );
  }

  @override
  List<Object?> get props {
    return [
      title,
      date,
      hourAndDuration,
      modality,
      conseillerPresenceLabel,
      conseillerPresenceColor,
      trackingPageName,
      commentTitle,
      comment,
      organism,
      address,
      addressRedirectUri?.toString(),
    ];
  }
}

String _toDuration(int duration) {
  final hours = duration ~/ 60;
  final minutes = duration % 60;
  if (hours == 0) return '${minutes}min';
  if (minutes == 0) return '${hours}h';
  return '${hours}h$minutes';
}

String? _commentTitle(Rendezvous rdv, String? comment) {
  if (comment != null && rdv.conseiller == null) return Strings.commentWithoutConseiller;
  if (comment != null && rdv.conseiller != null) return Strings.commentWithConseiller(rdv.conseiller!.firstName);
  return null;
}

String _trackingPageName(RendezvousTypeCode code) {
  switch (code) {
    case RendezvousTypeCode.ACTIVITE_EXTERIEURES:
      return AnalyticsScreenNames.rendezvousActivitesExterieures;
    case RendezvousTypeCode.ATELIER:
      return AnalyticsScreenNames.rendezvousAtelier;
    case RendezvousTypeCode.ENTRETIEN_INDIVIDUEL_CONSEILLER:
      return AnalyticsScreenNames.rendezvousEntretienIndividuel;
    case RendezvousTypeCode.ENTRETIEN_PARTENAIRE:
      return AnalyticsScreenNames.rendezvousEntretienPartenaire;
    case RendezvousTypeCode.INFORMATION_COLLECTIVE:
      return AnalyticsScreenNames.rendezvousInformationCollective;
    case RendezvousTypeCode.VISITE:
      return AnalyticsScreenNames.rendezvousVisite;
    case RendezvousTypeCode.AUTRE:
      return AnalyticsScreenNames.rendezvousAutre;
  }
}
