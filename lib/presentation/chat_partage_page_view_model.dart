import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_actions.dart';
import 'package:pass_emploi_app/features/chat/partage/chat_partage_actions.dart';
import 'package:pass_emploi_app/features/chat/partage/chat_partage_state.dart';
import 'package:pass_emploi_app/features/events/list/event_list_state.dart';
import 'package:pass_emploi_app/features/offre_emploi/details/offre_emploi_details_state.dart';
import 'package:pass_emploi_app/models/event_partage.dart';
import 'package:pass_emploi_app/models/message.dart';
import 'package:pass_emploi_app/models/offre_emploi_details.dart';
import 'package:pass_emploi_app/models/offre_partagee.dart';
import 'package:pass_emploi_app/models/rendezvous.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:redux/redux.dart';

abstract class ChatPartageSource {}

class ChatPartageOffreEmploiSource extends ChatPartageSource {
  final OffreType type;

  ChatPartageOffreEmploiSource(this.type);
}

class ChatPartageEventSource extends ChatPartageSource {
  final String eventId;

  ChatPartageEventSource(this.eventId);
}

class ChatPartagePageViewModel extends Equatable {
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

  ChatPartagePageViewModel({
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

  factory ChatPartagePageViewModel.fromSource(Store<AppState> store, ChatPartageSource source) {
    if (source is ChatPartageOffreEmploiSource) {
      return ChatPartagePageViewModel.sharingOffre(store, source);
    }
    if (source is ChatPartageEventSource) {
      return ChatPartagePageViewModel.sharingEvent(store, source);
    }
    throw Exception("Bad source type.");
  }

  factory ChatPartagePageViewModel.sharingOffre(Store<AppState> store, ChatPartageOffreEmploiSource source) {
    final offreEmploiDetailsState = store.state.offreEmploiDetailsState;
    if (offreEmploiDetailsState is! OffreEmploiDetailsSuccessState) {
      throw Exception("ChatPartagePageViewModel must be created with a OffreEmploiDetailsSuccessState.");
    }
    return ChatPartagePageViewModel(
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

  factory ChatPartagePageViewModel.sharingEvent(Store<AppState> store, ChatPartageEventSource source) {
    final eventListState = store.state.eventListState;
    if (eventListState is! EventListSuccessState) {
      throw Exception("ChatPartagePageViewModel must be created with a EventListSuccessState.");
    }
    final event = eventListState.events.firstWhereOrNull((element) => element.id == source.eventId);
    if (event == null) {
      throw Exception("Event not found.");
    }
    return ChatPartagePageViewModel(
      pageTitle: Strings.partageEventNavTitle,
      willShareTitle: Strings.souhaitDePartagerEvent,
      defaultMessage: Strings.partageEventDefaultMessage,
      information: Strings.infoEventPartageChat,
      shareButtonTitle: Strings.partagerAuConseiller,
      shareableTitle: event.title ?? "",
      onShare: (message) => _partagerEvent(store, event, message),
      snackbarState: _snackbarState(store),
      snackbarDisplayed: () => store.dispatch(ChatPartageResetAction()),
      snackbarSuccessText: Strings.partageEventSuccess,
      snackbarSuccessTracking: AnalyticsScreenNames.eventPartagePageSuccess,
    );
  }

  @override
  List<Object?> get props => [shareableTitle, snackbarState];
}

DisplayState _snackbarState(Store<AppState> store) {
  switch (store.state.chatPartageState) {
    case ChatPartageState.notInitialized:
      return DisplayState.EMPTY;
    case ChatPartageState.loading:
      return DisplayState.LOADING;
    case ChatPartageState.success:
      return DisplayState.CONTENT;
    case ChatPartageState.failure:
      return DisplayState.FAILURE;
  }
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
