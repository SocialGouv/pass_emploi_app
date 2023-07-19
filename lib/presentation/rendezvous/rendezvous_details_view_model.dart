import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/features/agenda/agenda_state.dart';
import 'package:pass_emploi_app/features/rendezvous/details/rendezvous_details_actions.dart';
import 'package:pass_emploi_app/features/rendezvous/details/rendezvous_details_state.dart';
import 'package:pass_emploi_app/features/session_milo_details/session_milo_details_state.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_state_source.dart';
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
  final DisplayState displayState;
  final String navbarTitle;
  final String id;
  final String tag;
  final bool greenTag;
  final String date;
  final String hourAndDuration;
  final String conseillerPresenceLabel;
  final Color conseillerPresenceColor;
  final bool isAnnule;
  final bool isInscrit;
  final bool withConseillerPresencePart;
  final bool withDescriptionPart;
  final bool withModalityPart;
  final bool withIfAbsentPart;
  final bool withSessionLeader;
  final String? withDateDerniereMiseAJour;
  final bool isShareable;
  final VisioButtonState visioButtonState;
  final Function() onRetry;
  final String? trackingPageName;
  final String? title;
  final String? commentTitle;
  final String? comment;
  final String? modality;
  final String? conseiller;
  final String? createur;
  final String? organism;
  final String? phone;
  final String? address;
  final Uri? addressRedirectUri;
  final String? visioRedirectUrl;
  final String? theme;
  final String? description;

  RendezvousDetailsViewModel({
    required this.displayState,
    required this.navbarTitle,
    required this.id,
    required this.tag,
    required this.greenTag,
    required this.date,
    required this.hourAndDuration,
    required this.conseillerPresenceLabel,
    required this.conseillerPresenceColor,
    required this.isInscrit,
    required this.isAnnule,
    required this.withConseillerPresencePart,
    required this.withDescriptionPart,
    required this.withModalityPart,
    required this.withIfAbsentPart,
    required this.withSessionLeader,
    this.withDateDerniereMiseAJour,
    required this.isShareable,
    required this.visioButtonState,
    required this.onRetry,
    this.trackingPageName,
    this.title,
    this.commentTitle,
    this.comment,
    this.modality,
    this.conseiller,
    this.createur,
    this.organism,
    this.phone,
    this.address,
    this.addressRedirectUri,
    this.visioRedirectUrl,
    this.theme,
    this.description,
  });

  factory RendezvousDetailsViewModel.create({
    required Store<AppState> store,
    required RendezvousStateSource source,
    required String rdvId,
    required Platform platform,
  }) {
    final rdv = _getRendezvous(store, source, rdvId);
    final dateDerniereMiseAJour = _getDateDerniereMiseAJour(store, source);
    if (rdv == null) return RendezvousDetailsViewModel._createBlankRendezvous(store, rdvId);
    final address = _address(rdv);
    final comment = (rdv.comment != null && rdv.comment!.trim().isNotEmpty) ? rdv.comment : null;
    final isConseillerPresent = rdv.withConseiller ?? false;
    final isInscrit = rdv.estInscrit ?? false;
    return RendezvousDetailsViewModel(
      displayState: DisplayState.CONTENT,
      navbarTitle: _navbarTitle(source, rdv),
      id: rdv.id,
      tag: takeTypeLabelOrPrecision(rdv),
      greenTag: isRendezvousGreenTag(rdv),
      date: rdv.date.toDayWithFullMonthContextualized(),
      hourAndDuration: _hourAndDuration(rdv),
      modality: _modality(rdv),
      conseiller: _conseiller(rdv),
      createur: _createur(rdv),
      conseillerPresenceLabel: isConseillerPresent ? Strings.conseillerIsPresent : Strings.conseillerIsNotPresent,
      conseillerPresenceColor: isConseillerPresent ? AppColors.secondary : AppColors.warning,
      isInscrit: isInscrit,
      isAnnule: rdv.isAnnule,
      withConseillerPresencePart: _shouldDisplayConseillerPresence(rdv),
      withDescriptionPart: rdv.description != null || rdv.theme != null,
      withModalityPart: _withModalityPart(rdv),
      withIfAbsentPart:
          ((source != RendezvousStateSource.eventList && source != RendezvousStateSource.sessionMiloDetails) ||
              isInscrit),
      withSessionLeader: source == RendezvousStateSource.sessionMiloDetails,
      withDateDerniereMiseAJour: _withDateDerniereMiseAJour(dateDerniereMiseAJour),
      isShareable: (source == RendezvousStateSource.eventList && isInscrit == false),
      visioButtonState: _visioButtonState(rdv),
      visioRedirectUrl: rdv.visioRedirectUrl,
      onRetry: () => {},
      trackingPageName: _trackingPageName(rdv.type.code),
      title: rdv.title,
      commentTitle: _commentTitle(rdv, comment),
      comment: comment,
      organism: _shouldHidePresentielInformation(rdv) ? null : rdv.organism,
      address: address,
      phone: rdv.phone != null ? Strings.phone(rdv.phone!) : null,
      addressRedirectUri: address != null ? UriHandler().mapsUri(address, platform) : null,
      theme: rdv.theme,
      description: rdv.description,
    );
  }

  factory RendezvousDetailsViewModel._createBlankRendezvous(Store<AppState> store, String rdvId) {
    final state = store.state.rendezvousDetailsState;
    return RendezvousDetailsViewModel(
      displayState: state is RendezvousDetailsFailureState ? DisplayState.FAILURE : DisplayState.LOADING,
      navbarTitle: Strings.eventTitle,
      id: '',
      tag: '',
      greenTag: false,
      date: '',
      hourAndDuration: '',
      conseillerPresenceLabel: '',
      conseillerPresenceColor: Colors.transparent,
      isInscrit: false,
      isAnnule: false,
      withConseillerPresencePart: false,
      withDescriptionPart: false,
      withModalityPart: false,
      withIfAbsentPart: false,
      withSessionLeader: false,
      isShareable: false,
      visioButtonState: VisioButtonState.HIDDEN,
      onRetry: () => store.dispatch(RendezvousDetailsRequestAction(rdvId)),
    );
  }

  @override
  List<Object?> get props {
    return [
      displayState,
      navbarTitle,
      id,
      tag,
      greenTag,
      date,
      hourAndDuration,
      conseillerPresenceLabel,
      conseillerPresenceColor,
      isInscrit,
      isAnnule,
      withConseillerPresencePart,
      withDescriptionPart,
      withModalityPart,
      withIfAbsentPart,
      withDateDerniereMiseAJour,
      isShareable,
      visioButtonState,
      trackingPageName,
      title,
      commentTitle,
      comment,
      modality,
      conseiller,
      createur,
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

DateTime? _getDateDerniereMiseAJour(Store<AppState> store, RendezvousStateSource source) {
  if (source == RendezvousStateSource.agenda && store.state.agendaState is AgendaSuccessState) {
    return (store.state.agendaState as AgendaSuccessState).agenda.dateDerniereMiseAJour;
  } else if (source == RendezvousStateSource.rendezvousList) {
    return store.state.rendezvousListState.dateDerniereMiseAJour;
  }
  return null;
}

String? _withDateDerniereMiseAJour(DateTime? dateDerniereMiseAJour) {
  if (dateDerniereMiseAJour == null) return null;
  return Strings.dateDerniereMiseAJourRendezvous(dateDerniereMiseAJour.toDayandHour());
}

enum VisioButtonState { ACTIVE, INACTIVE, HIDDEN }

Rendezvous? _getRendezvous(Store<AppState> store, RendezvousStateSource source, String rdvId) {
  if (source != RendezvousStateSource.noSource && store.state.rendezvousDetailsState is RendezvousDetailsSuccessState ||
      store.state.sessionMiloDetailsState is SessionMiloDetailsSuccessState) {
    return getRendezvous(store, source, rdvId);
  } else {
    return null;
  }
}

String _navbarTitle(RendezvousStateSource source, Rendezvous rendezvous) {
  if (source != RendezvousStateSource.eventList) return Strings.myRendezVous;
  return rendezvous.estInscrit == true ? Strings.myRendezVous : Strings.eventTitle;
}

bool _shouldHidePresentielInformation(Rendezvous rdv) {
  return rdv.isInVisio || rdv.modalityType() == RendezvousModalityType.TELEPHONE;
}

bool _shouldDisplayConseillerPresence(Rendezvous rdv) {
  if (rdv.source.isMilo) return false;
  return rdv.type.code != RendezvousTypeCode.ENTRETIEN_INDIVIDUEL_CONSEILLER &&
      rdv.type.code != RendezvousTypeCode.PRESTATION &&
      rdv.withConseiller != null;
}

String? _address(Rendezvous rdv) {
  return _shouldHidePresentielInformation(rdv) ? null : rdv.address;
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
  if (comment != null && rdv.conseiller != null) return Strings.rendezVousConseillerCommentLabel;
  return null;
}

String? _modality(Rendezvous rdv) {
  if (rdv.isInVisio) return Strings.rendezvousVisioModalityMessage;
  if (rdv.modality == null) return null;
  return Strings.rendezvousModalityDetailsMessage(rdv.modality!.firstLetterLowerCased());
}

String? _conseiller(Rendezvous rdv) {
  if (rdv.source.isMilo) return null;
  if (rdv.isInVisio || rdv.modality == null) return null;
  final conseiller = rdv.conseiller;
  final withConseiller = rdv.withConseiller;
  if (withConseiller != null && withConseiller && conseiller != null) {
    return Strings.rendezvousWithConseiller('${conseiller.firstName} ${conseiller.lastName}');
  }
  return null;
}

String? _createur(Rendezvous rdv) {
  if (rdv.source.isMilo) return null;
  final createur = rdv.createur;
  return createur != null ? Strings.rendezvousCreateur('${createur.firstName} ${createur.lastName}') : null;
}

bool _withModalityPart(Rendezvous rdv) {
  return rdv.modality != null || rdv.address != null || rdv.organism != null || rdv.phone != null || rdv.isInVisio;
}

VisioButtonState _visioButtonState(Rendezvous rdv) {
  if (rdv.isInVisio && rdv.visioRedirectUrl != null) return VisioButtonState.ACTIVE;
  if (rdv.isInVisio && rdv.visioRedirectUrl == null) return VisioButtonState.INACTIVE;
  return VisioButtonState.HIDDEN;
}

String? _trackingPageName(RendezvousTypeCode code) {
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
    case RendezvousTypeCode.WORKSHOP:
      return AnalyticsScreenNames.sessionWorkshop;
    case RendezvousTypeCode.COLLECTIVE_INFORMATION:
      return AnalyticsScreenNames.sessionCollectiveInformation;
  }
}
