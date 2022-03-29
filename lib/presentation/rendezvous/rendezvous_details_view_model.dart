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
  final String conseillerPresenceLabel;
  final Color conseillerPresenceColor;
  final bool isAnnule;
  final bool withConseillerPresencePart;
  final bool withDescriptionPart;
  final bool withModalityPart;
  final VisioButtonState visioButtonState;
  final String trackingPageName;
  final String? commentTitle;
  final String? comment;
  final String? modality;
  final String? organism;
  final String? phone;
  final String? address;
  final Uri? addressRedirectUri;
  final String? visioRedirectUrl;
  final String? theme;
  final String? description;

  RendezvousDetailsViewModel({
    required this.title,
    required this.date,
    required this.hourAndDuration,
    required this.conseillerPresenceLabel,
    required this.conseillerPresenceColor,
    required this.isAnnule,
    required this.withConseillerPresencePart,
    required this.withDescriptionPart,
    required this.withModalityPart,
    required this.visioButtonState,
    required this.trackingPageName,
    this.commentTitle,
    this.comment,
    this.modality,
    this.organism,
    this.phone,
    this.address,
    this.addressRedirectUri,
    this.visioRedirectUrl,
    this.theme,
    this.description,
  });

  factory RendezvousDetailsViewModel.create(Store<AppState> store, String rdvId, Platform platform) {
    final rdv = getRendezvousFromStore(store, rdvId);
    final address = _address(rdv);
    final comment = (rdv.comment != null && rdv.comment!.trim().isNotEmpty) ? rdv.comment : null;
    return RendezvousDetailsViewModel(
      title: takeTypeLabelOrPrecision(rdv),
      date: rdv.date.toDayWithFullMonthContextualized(),
      hourAndDuration: _hourAndDuration(rdv),
      modality: _modality(rdv),
      conseillerPresenceLabel: rdv.withConseiller ? Strings.conseillerIsPresent : Strings.conseillerIsNotPresent,
      conseillerPresenceColor: rdv.withConseiller ? AppColors.secondary : AppColors.warning,
      isAnnule: rdv.isAnnule,
      withConseillerPresencePart: rdv.type.code != RendezvousTypeCode.ENTRETIEN_INDIVIDUEL_CONSEILLER,
      withDescriptionPart: rdv.description != null || rdv.theme != null,
      withModalityPart: _withModalityPart(rdv),
      visioButtonState: _visioButtonState(rdv),
      visioRedirectUrl: rdv.visioRedirectUrl,
      trackingPageName: _trackingPageName(rdv.type.code),
      commentTitle: _commentTitle(rdv, comment),
      comment: comment,
      organism: _shouldHidePresentielInformations(rdv) ? null : rdv.organism,
      address: address,
      phone: rdv.phone != null ? Strings.phone(rdv.phone!) : null,
      addressRedirectUri: address != null ? UriHandler().mapsUri(address, platform) : null,
      theme: rdv.theme,
      description: rdv.description,
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
      isAnnule,
      withConseillerPresencePart,
      withDescriptionPart,
      withModalityPart,
      visioButtonState,
      trackingPageName,
      commentTitle,
      comment,
      organism,
      phone,
      address,
      addressRedirectUri?.toString(),
      visioRedirectUrl,
      theme,
      description,
    ];
  }
}

enum VisioButtonState { ACTIVE, INACTIVE, HIDDEN }

bool _shouldHidePresentielInformations(Rendezvous rdv) {
  return rdv.isInVisio || rdv.phone != null;
}

String? _address(Rendezvous rdv) {
  return _shouldHidePresentielInformations(rdv) ? null : rdv.address;
}

String _hourAndDuration(Rendezvous rdv) {
  final hour = rdv.date.toHour();
  return rdv.duration != null ? "$hour (${_toDuration(rdv.duration!)})" : hour;
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

String? _modality(Rendezvous rdv) {
  if (rdv.isInVisio) return Strings.rendezvousVisioModalityMessage;
  if (rdv.modality == null) return null;
  final modality = rdv.modality!.firstLetterLowerCased();
  final conseiller = rdv.conseiller;
  if (rdv.withConseiller && conseiller != null) {
    return Strings.rendezvousModalityWithConseillerDetailsMessage(
      modality,
      '${conseiller.firstName} ${conseiller.lastName}',
    );
  }
  return Strings.rendezvousModalityDetailsMessage(modality);
}

bool _withModalityPart(Rendezvous rdv) {
  return rdv.modality != null || rdv.address != null || rdv.organism != null || rdv.phone != null || rdv.isInVisio;
}

VisioButtonState _visioButtonState(Rendezvous rdv) {
  if (rdv.isInVisio && rdv.visioRedirectUrl != null) return VisioButtonState.ACTIVE;
  if (rdv.isInVisio && rdv.visioRedirectUrl == null) return VisioButtonState.INACTIVE;
  return VisioButtonState.HIDDEN;
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
    case RendezvousTypeCode.PRESTATION:
      return AnalyticsScreenNames.rendezvousPrestation;
    case RendezvousTypeCode.AUTRE:
      return AnalyticsScreenNames.rendezvousAutre;
  }
}
