import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/features/accueil/accueil_state.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_actions.dart';
import 'package:pass_emploi_app/features/chat/partage/chat_partage_actions.dart';
import 'package:pass_emploi_app/features/chat/partage/chat_partage_state.dart';
import 'package:pass_emploi_app/features/evenement_emploi/details/evenement_emploi_details_state.dart';
import 'package:pass_emploi_app/features/events/list/event_list_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/details/offre_emploi_details_state.dart';
import 'package:pass_emploi_app/features/session_milo_details/session_milo_details_state.dart';
import 'package:pass_emploi_app/models/chat/message.dart';
import 'package:pass_emploi_app/models/chat/offre_partagee.dart';
import 'package:pass_emploi_app/models/evenement_emploi/evenement_emploi_details.dart';
import 'package:pass_emploi_app/models/evenement_emploi_partage.dart';
import 'package:pass_emploi_app/models/event_partage.dart';
import 'package:pass_emploi_app/models/offre_emploi_details.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/models/session_milo_partage.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

sealed class ChatPartageSource extends Equatable {
  @override
  List<Object?> get props => [];
}

class ChatPartageOffreEmploiSource extends ChatPartageSource {
  final OffreType type;

  ChatPartageOffreEmploiSource(this.type);

  @override
  List<Object?> get props => [type];
}

class ChatPartageEventSource extends ChatPartageSource {
  final String eventId;

  ChatPartageEventSource(this.eventId);

  @override
  List<Object?> get props => [eventId];
}

class ChatPartageEvenementEmploiSource extends ChatPartageSource {}

class ChatPartageSessionMiloSource extends ChatPartageSource {
  final String sessionId;

  ChatPartageSessionMiloSource(this.sessionId);

  @override
  List<Object?> get props => [sessionId];
}

class ChatPartageBottomSheetViewModel extends Equatable {
  final String pageTitle;
  final String willShareTitle;
  final String defaultMessage;
  final String information;
  final String shareButtonTitle;
  final String shareableTitle;
  final Function(String message) onShare;
  final DisplayState snackbarState;
  final Function snackbarDisplayed;
  final String snackbarSuccessText;
  final String snackbarSuccessTracking;

  ChatPartageBottomSheetViewModel({
    required this.pageTitle,
    required this.willShareTitle,
    required this.defaultMessage,
    required this.information,
    required this.shareButtonTitle,
    required this.shareableTitle,
    required this.onShare,
    required this.snackbarState,
    required this.snackbarDisplayed,
    required this.snackbarSuccessText,
    required this.snackbarSuccessTracking,
  });

  factory ChatPartageBottomSheetViewModel.fromSource(Store<AppState> store, ChatPartageSource source) {
    return switch (source) {
      ChatPartageOffreEmploiSource() => ChatPartageBottomSheetViewModel.sharingOffre(store, source),
      ChatPartageEventSource() => ChatPartageBottomSheetViewModel.sharingEvent(store, source),
      ChatPartageEvenementEmploiSource() => ChatPartageBottomSheetViewModel.sharingEvenementEmploi(store, source),
      ChatPartageSessionMiloSource() => ChatPartageBottomSheetViewModel.sharingSessionMilo(store, source),
    };
  }

  factory ChatPartageBottomSheetViewModel.sharingOffre(Store<AppState> store, ChatPartageOffreEmploiSource source) {
    final offreEmploiDetailsState = store.state.offreEmploiDetailsState;
    if (offreEmploiDetailsState is! OffreEmploiDetailsSuccessState) {
      throw Exception("ChatPartagePageViewModel must be created with a OffreEmploiDetailsSuccessState.");
    }
    return ChatPartageBottomSheetViewModel(
      pageTitle:
          source.type == OffreType.alternance ? Strings.partageOffreAlternanceNavTitle : Strings.partageOffreNavTitle,
      willShareTitle: Strings.souhaitDePartagerOffre,
      defaultMessage: Strings.partageOffreDefaultMessage,
      information: Strings.infoOffrePartageChat,
      shareButtonTitle:
          source.type == OffreType.alternance ? Strings.partagerOffreAlternance : Strings.partagerOffreEmploi,
      shareableTitle: offreEmploiDetailsState.offre.title,
      onShare: (message) => _partagerOffre(store, offreEmploiDetailsState.offre, source.type, message),
      snackbarState: _snackbarState(store),
      snackbarDisplayed: () => store.dispatch(ChatPartageResetAction()),
      snackbarSuccessText: Strings.partageOffreSuccess,
      snackbarSuccessTracking: AnalyticsScreenNames.emploiPartagePageSuccess,
    );
  }

  factory ChatPartageBottomSheetViewModel.sharingEvent(Store<AppState> store, ChatPartageEventSource source) {
    final eventListState = store.state.eventListState;
    final accueilState = store.state.accueilState;
    final Rendezvous? event;

    if (eventListState is EventListSuccessState) {
      event = eventListState.animationsCollectives.firstWhereOrNull((e) => e.id == source.eventId);
    } else if (accueilState is AccueilSuccessState) {
      event = accueilState.accueil.animationsCollectives?.firstWhereOrNull((e) => e.id == source.eventId);
    } else {
      throw Exception(
        "ChatPartagePageViewModel must be created with an EventListSuccessState or an AccueilSuccessState.",
      );
    }

    if (event == null) {
      throw Exception("Event not found.");
    }
    return ChatPartageBottomSheetViewModel(
      pageTitle: Strings.partageEventNavTitle,
      willShareTitle: Strings.souhaitDePartagerEvent,
      defaultMessage: Strings.partageEventDefaultMessage,
      information: Strings.infoEventPartageChat,
      shareButtonTitle: Strings.partagerAuConseiller,
      shareableTitle: event.title ?? "",
      onShare: (message) => _partagerEvent(store, event!, message),
      snackbarState: _snackbarState(store),
      snackbarDisplayed: () => store.dispatch(ChatPartageResetAction()),
      snackbarSuccessText: Strings.partageEventSuccess,
      snackbarSuccessTracking: AnalyticsScreenNames.animationCollectivePartagePageSuccess,
    );
  }

  factory ChatPartageBottomSheetViewModel.sharingEvenementEmploi(
    Store<AppState> store,
    ChatPartageEvenementEmploiSource source,
  ) {
    final evenementEmploiDetailsState = store.state.evenementEmploiDetailsState;
    if (evenementEmploiDetailsState is! EvenementEmploiDetailsSuccessState) {
      throw Exception("ChatPartagePageViewModel must be created with a EvenementEmploiDetailsSuccessState.");
    }

    return ChatPartageBottomSheetViewModel(
      pageTitle: Strings.partageEvenementEmploiNavTitle,
      willShareTitle: Strings.souhaitDePartagerEvenementEmploi,
      defaultMessage: Strings.partageEvenementEmploiDefaultMessage,
      information: Strings.infoEvenementEmploiPartageChat,
      shareButtonTitle: Strings.partagerEvenementEmploiAuConseiller,
      shareableTitle: evenementEmploiDetailsState.details.titre ?? "",
      onShare: (message) => _partagerEvenementEmploi(store, evenementEmploiDetailsState.details, message),
      snackbarState: _snackbarState(store),
      snackbarDisplayed: () => store.dispatch(ChatPartageResetAction()),
      snackbarSuccessText: Strings.partageEvenementEmploiSuccess,
      snackbarSuccessTracking: AnalyticsScreenNames.evenementEmploiPartagePageSuccess,
    );
  }

  factory ChatPartageBottomSheetViewModel.sharingSessionMilo(
      Store<AppState> store, ChatPartageSessionMiloSource source) {
    final sessionMiloDetailsState = store.state.sessionMiloDetailsState;
    if (sessionMiloDetailsState is! SessionMiloDetailsSuccessState) {
      throw Exception("ChatPartagePageViewModel must be created with a SessionMiloDetailsSuccessState.");
    }

    return ChatPartageBottomSheetViewModel(
      pageTitle: Strings.partageSessionMiloNavTitle,
      willShareTitle: Strings.souhaitDePartagerSessionMilo,
      defaultMessage: Strings.partageSessionMiloDefaultMessage,
      information: Strings.infoSessionMiloPartageChat,
      shareButtonTitle: Strings.partagerSessionMiloAuConseiller,
      shareableTitle: sessionMiloDetailsState.details.displayableTitle,
      onShare: (message) => _partagerSessionMilo(store, sessionMiloDetailsState.details.toRendezVous, message),
      snackbarState: _snackbarState(store),
      snackbarDisplayed: () => store.dispatch(ChatPartageResetAction()),
      snackbarSuccessText: Strings.partageSessionMiloSuccess,
      snackbarSuccessTracking: AnalyticsScreenNames.sessionMiloPartagePageSuccess,
    );
  }

  @override
  List<Object?> get props => [shareableTitle, snackbarState];
}

DisplayState _snackbarState(Store<AppState> store) {
  return switch (store.state.chatPartageState) {
    ChatPartageNotInitializedState() => DisplayState.EMPTY,
    ChatPartageLoadingState() => DisplayState.LOADING,
    ChatPartageSuccessState() => DisplayState.CONTENT,
    ChatPartageFailureState() => DisplayState.FAILURE
  };
}

void _partagerEvent(Store<AppState> store, Rendezvous event, String message) {
  store.dispatch(
    ChatPartagerEventAction(
      EventPartage(
        id: event.id,
        type: event.type,
        titre: event.title ?? "",
        date: event.date,
        message: message,
      ),
    ),
  );
}

void _partagerOffre(Store<AppState> store, OffreEmploiDetails offre, OffreType type, String message) {
  store.dispatch(
    ChatPartagerOffreAction(
      OffrePartagee(
        id: offre.id,
        titre: offre.title,
        url: offre.urlRedirectPourPostulation,
        message: message,
        type: type,
      ),
    ),
  );
}

void _partagerEvenementEmploi(Store<AppState> store, EvenementEmploiDetails evenementEmploiDetails, String message) {
  store.dispatch(
    ChatPartagerEvenementEmploiAction(
      EvenementEmploiPartage(
        id: evenementEmploiDetails.id,
        titre: evenementEmploiDetails.titre ?? "",
        url: evenementEmploiDetails.url ?? "",
        message: message,
      ),
    ),
  );
}

void _partagerSessionMilo(Store<AppState> store, Rendezvous sessionMilo, String message) {
  store.dispatch(
    ChatPartagerSessionMiloAction(
      SessionMiloPartage(
        id: sessionMilo.id,
        titre: sessionMilo.title ?? "",
        message: message,
      ),
    ),
  );
}
