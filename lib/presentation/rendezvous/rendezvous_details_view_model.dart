import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/features/mon_suivi/mon_suivi_state.dart';
import 'package:pass_emploi_app/features/rendezvous/details/rendezvous_details_actions.dart';
import 'package:pass_emploi_app/features/rendezvous/details/rendezvous_details_state.dart';
import 'package:pass_emploi_app/features/session_milo_details/session_milo_details_actions.dart';
import 'package:pass_emploi_app/features/session_milo_details/session_milo_details_state.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/presentation/chat/chat_partage_page_view_model.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_state_source.dart';
import 'package:pass_emploi_app/presentation/rendezvous/rendezvous_store_extension.dart';
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
  final String date;
  final String hourAndDuration;
  final String conseillerPresenceLabel;
  final Color conseillerPresenceColor;
  final bool isAnnule;
  final bool isInscrit;
  final bool isComplet;
  final bool withConseillerPresencePart;
  final bool withDescriptionPart;
  final bool withModalityPart;
  final bool withIfAbsentPart;
  final String? withAnimateur;
  final String? withDateDerniereMiseAJour;
  final RendezvousCtaVm? shareToConseillerButton;
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
  final String? nombreDePlacesRestantes;

  RendezvousDetailsViewModel({
    required this.displayState,
    required this.navbarTitle,
    required this.id,
    required this.tag,
    required this.date,
    required this.hourAndDuration,
    required this.conseillerPresenceLabel,
    required this.conseillerPresenceColor,
    required this.isInscrit,
    required this.isComplet,
    required this.isAnnule,
    required this.withConseillerPresencePart,
    required this.withDescriptionPart,
    required this.withModalityPart,
    required this.withIfAbsentPart,
    this.withAnimateur,
    this.withDateDerniereMiseAJour,
    this.shareToConseillerButton,
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
    this.nombreDePlacesRestantes,
  });

  factory RendezvousDetailsViewModel.create({
    required Store<AppState> store,
    required RendezvousStateSource source,
    required String rdvId,
    required Platform platform,
  }) {
    final rdv = _getRendezvous(store, source, rdvId);
    final dateDerniereMiseAJour = _getDateDerniereMiseAJour(store, source);
    if (rdv == null) return RendezvousDetailsViewModel._createBlankRendezvous(store, source, rdvId);
    final address = _address(rdv);
    final comment = (rdv.comment != null && rdv.comment!.trim().isNotEmpty) ? rdv.comment : null;
    final isConseillerPresent = rdv.withConseiller ?? false;
    final isInscrit = rdv.estInscrit ?? false;
    return RendezvousDetailsViewModel(
      displayState: DisplayState.CONTENT,
      navbarTitle: _navbarTitle(source, rdv),
      id: rdv.id,
      tag: _takeTypeLabelOrPrecision(rdv),
      date: rdv.date.toDayWithFullMonthContextualized(),
      hourAndDuration: _hours(rdv),
      modality: _modality(rdv),
      conseiller: _conseiller(rdv),
      createur: _createur(source, rdv),
      conseillerPresenceLabel: isConseillerPresent ? Strings.conseillerIsPresent : Strings.conseillerIsNotPresent,
      conseillerPresenceColor: isConseillerPresent ? AppColors.success : AppColors.warning,
      isInscrit: isInscrit,
      isComplet: _isComplet(rdv, isInscrit),
      isAnnule: rdv.isAnnule,
      withConseillerPresencePart: _shouldDisplayConseillerPresence(rdv),
      withDescriptionPart: _withDescription(source, rdv),
      withModalityPart: _withModalityPart(rdv),
      withIfAbsentPart: _estCeQueMaPresenceEstRequise(source, isInscrit),
      withAnimateur: _withAnimateur(source, rdv.animateur),
      withDateDerniereMiseAJour: _withDateDerniereMiseAJour(dateDerniereMiseAJour),
      shareToConseillerButton: _shareToConseillerButton(source, rdv),
      visioButtonState: _visioButtonState(rdv),
      visioRedirectUrl: rdv.visioRedirectUrl,
      onRetry: () => {},
      trackingPageName: _trackingPageName(source, rdv.type.code),
      title: rdv.title,
      commentTitle: _commentTitle(source, rdv, comment),
      comment: _comment(source, comment),
      organism: _shouldHidePresentielInformation(rdv) ? null : rdv.organism,
      address: address,
      phone: rdv.phone != null ? Strings.phone(rdv.phone!) : null,
      addressRedirectUri: address != null ? UriHandler().mapsUri(address, platform) : null,
      theme: rdv.theme,
      description: _descriptionFromSource(source, rdv),
      nombreDePlacesRestantes: _nombreDePlacesRestantes(rdv),
    );
  }

  factory RendezvousDetailsViewModel._createBlankRendezvous(
    Store<AppState> store,
    RendezvousStateSource source,
    String rdvId,
  ) {
    final isFailure = source.isMiloDetails
        ? store.state.sessionMiloDetailsState is SessionMiloDetailsFailureState
        : store.state.rendezvousDetailsState is RendezvousDetailsFailureState;
    return RendezvousDetailsViewModel(
      displayState: isFailure ? DisplayState.FAILURE : DisplayState.LOADING,
      navbarTitle: Strings.eventTitle,
      id: '',
      tag: '',
      date: '',
      hourAndDuration: '',
      conseillerPresenceLabel: '',
      conseillerPresenceColor: Colors.transparent,
      isInscrit: false,
      isComplet: false,
      isAnnule: false,
      withConseillerPresencePart: false,
      withDescriptionPart: false,
      withModalityPart: false,
      withIfAbsentPart: false,
      visioButtonState: VisioButtonState.HIDDEN,
      nombreDePlacesRestantes: null,
      onRetry: () {
        source.isMiloDetails
            ? store.dispatch(SessionMiloDetailsRequestAction(rdvId))
            : store.dispatch(RendezvousDetailsRequestAction(rdvId));
      },
    );
  }

  @override
  List<Object?> get props {
    return [
      displayState,
      navbarTitle,
      id,
      tag,
      date,
      hourAndDuration,
      conseillerPresenceLabel,
      conseillerPresenceColor,
      isInscrit,
      isComplet,
      isAnnule,
      withConseillerPresencePart,
      withDescriptionPart,
      withModalityPart,
      withIfAbsentPart,
      withDateDerniereMiseAJour,
      shareToConseillerButton,
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
      nombreDePlacesRestantes,
    ];
  }
}

DateTime? _getDateDerniereMiseAJour(Store<AppState> store, RendezvousStateSource source) {
  if (source == RendezvousStateSource.monSuivi && store.state.monSuiviState is MonSuiviSuccessState) {
    return (store.state.monSuiviState as MonSuiviSuccessState).monSuivi.dateDerniereMiseAJourPoleEmploi;
  }
  return null;
}

String? _withDateDerniereMiseAJour(DateTime? dateDerniereMiseAJour) {
  if (dateDerniereMiseAJour == null) return null;
  return Strings.dateDerniereMiseAJourRendezvous(dateDerniereMiseAJour.toDayAndHour());
}

enum VisioButtonState { ACTIVE, INACTIVE, HIDDEN }

Rendezvous? _getRendezvous(Store<AppState> store, RendezvousStateSource source, String rdvId) {
  return _shouldGetRendezvous(source, store) ? store.getRendezvous(source, rdvId) : null;
}

String? _nombreDePlacesRestantes(Rendezvous rdv) {
  if (rdv.nombreDePlacesRestantes == null || rdv.nombreDePlacesRestantes == 0) return null;
  return Strings.placesRestantes(rdv.nombreDePlacesRestantes!);
}

bool _shouldGetRendezvous(RendezvousStateSource source, Store<AppState> store) {
  return switch (source) {
    RendezvousStateSource.noSource => store.state.rendezvousDetailsState is RendezvousDetailsSuccessState,
    RendezvousStateSource.sessionMiloDetails => store.state.sessionMiloDetailsState is SessionMiloDetailsSuccessState,
    _ => true,
  };
}

String _navbarTitle(RendezvousStateSource source, Rendezvous rendezvous) {
  if (!source.isFromEvenements && !source.isMiloDetails) return Strings.myRendezVous;
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

String _takeTypeLabelOrPrecision(Rendezvous rdv) {
  return (rdv.type.code == RendezvousTypeCode.AUTRE && rdv.precision != null) ? rdv.precision! : rdv.type.label;
}

String _hours(Rendezvous rdv) {
  final heureDebut = rdv.date.toHourWithHSeparator();
  final heureFin = rdv.duration != null && rdv.duration != 0
      ? rdv.date.add(Duration(minutes: rdv.duration!)).toHourWithHSeparator()
      : null;
  final period = "$heureDebut${heureFin != null ? " - $heureFin" : ""}";
  return period;
}

String? _commentTitle(RendezvousStateSource source, Rendezvous rdv, String? comment) {
  if (source.isMiloDetails) {
    return Strings.rendezVousCommentaire;
  }
  if (comment != null && rdv.conseiller == null) {
    return Strings.commentWithoutConseiller;
  }
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

String? _createur(RendezvousStateSource source, Rendezvous rdv) {
  if (source.isFromEvenements) return null;
  if (rdv.source.isMilo) return null;
  final createur = rdv.createur;
  return createur != null ? Strings.rendezvousCreateur('${createur.firstName} ${createur.lastName}') : null;
}

bool _isComplet(Rendezvous rdv, bool isInscrit) {
  return !isInscrit && rdv.nombreDePlacesRestantes == 0;
}

bool _withModalityPart(Rendezvous rdv) {
  return rdv.modality != null || rdv.address != null || rdv.organism != null || rdv.phone != null || rdv.isInVisio;
}

VisioButtonState _visioButtonState(Rendezvous rdv) {
  if (rdv.isInVisio && rdv.visioRedirectUrl != null) return VisioButtonState.ACTIVE;
  if (rdv.isInVisio && rdv.visioRedirectUrl == null) return VisioButtonState.INACTIVE;
  return VisioButtonState.HIDDEN;
}

String? _trackingPageName(RendezvousStateSource source, RendezvousTypeCode type) {
  if (source.isMiloDetails) return AnalyticsScreenNames.sessionMiloDetails;
  if ([RendezvousTypeCode.ATELIER, RendezvousTypeCode.INFORMATION_COLLECTIVE].contains(type)) {
    return AnalyticsScreenNames.animationCollectiveDetails;
  }
  return AnalyticsScreenNames.rendezvousDetails;
}

String? _withAnimateur(RendezvousStateSource source, String? animateur) {
  if (source.isMiloDetails) {
    return animateur ?? "--";
  }
  return null;
}

bool _withDescription(RendezvousStateSource source, Rendezvous rdv) {
  if (source.isMiloDetails) return true;
  return rdv.description != null || rdv.theme != null;
}

String? _descriptionFromSource(RendezvousStateSource source, Rendezvous rdv) {
  if (source.isMiloDetails) return rdv.description ?? "--";
  return rdv.description;
}

String? _comment(RendezvousStateSource source, String? comment) {
  if (source.isMiloDetails) return comment ?? "--";
  return comment;
}

bool _estCeQueMaPresenceEstRequise(RendezvousStateSource source, bool isInscrit) {
  return (!source.isFromEvenements && !source.isMiloDetails) || isInscrit;
}

RendezvousCtaVm? _shareToConseillerButton(RendezvousStateSource source, Rendezvous rdv) {
  if (rdv.estInscrit == true) return null;
  if (source.isFromEvenements) return RendezVousShareToConseiller(chatPartageSource: ChatPartageEventSource(rdv.id));
  if (source.isMiloDetails) return _miloCta(rdv);
  return null;
}

RendezvousCtaVm _miloCta(Rendezvous rdv) {
  if (rdv.autoInscriptionAvailable) {
    return RendezVousAutoInscription(
        onPressed: () => {
              // TODO: dispatch autoinscription action
            });
  }
  if (rdv.isComplet) return RendezVousShareToConseiller(chatPartageSource: ChatPartageSessionMiloSource(rdv.id));
  return RendezVousShareToConseillerDemandeInscription(
      onPressed: () => {
            // TODO: dispatch send message
          });
}

sealed class RendezvousCtaVm extends Equatable {
  final void Function()? onPressed;
  final String label;

  RendezvousCtaVm({required this.onPressed, required this.label});

  @override
  List<Object?> get props => [label];
}

class RendezVousAutoInscription extends RendezvousCtaVm {
  RendezVousAutoInscription({required super.onPressed}) : super(label: Strings.autoInscriptionCta);
}

class RendezVousShareToConseillerDemandeInscription extends RendezvousCtaVm {
  RendezVousShareToConseillerDemandeInscription({required super.onPressed})
      : super(label: Strings.shareToConseillerDemandeInscription);
}

class RendezVousShareToConseiller extends RendezvousCtaVm {
  final ChatPartageSource chatPartageSource;

  RendezVousShareToConseiller({required this.chatPartageSource})
      : super(label: Strings.shareToConseiller, onPressed: null);
}
