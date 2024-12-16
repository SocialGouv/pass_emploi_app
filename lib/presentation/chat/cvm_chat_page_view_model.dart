import 'dart:io';

import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/analytics/analytics_constants.dart';
import 'package:pass_emploi_app/features/chat/status/chat_status_state.dart';
import 'package:pass_emploi_app/features/cvm/cvm_actions.dart';
import 'package:pass_emploi_app/features/cvm/cvm_state.dart';
import 'package:pass_emploi_app/models/chat/cvm_message.dart';
import 'package:pass_emploi_app/models/chat/sender.dart';
import 'package:pass_emploi_app/presentation/chat/cvm_chat_item.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:pass_emploi_app/utils/pass_emploi_matomo_tracker.dart';
import 'package:redux/redux.dart';

class CvmChatPageViewModel extends Equatable {
  final DisplayState displayState;
  final String? brouillon;
  final List<CvmChatItem> items;
  final bool shouldShowOnboarding;
  final Function(String message) onSendMessage;
  final Function() onRetry;

  CvmChatPageViewModel({
    required this.displayState,
    required this.brouillon,
    required this.items,
    required this.shouldShowOnboarding,
    required this.onSendMessage,
    required this.onRetry,
  });

  factory CvmChatPageViewModel.create(Store<AppState> store) {
    final chatState = store.state.cvmState;
    final statusState = store.state.chatStatusState;
    final lastReading = (statusState is ChatStatusSuccessState) ? statusState.lastConseillerReading : minDateTime;
    return CvmChatPageViewModel(
      displayState: _displayState(chatState),
      brouillon: store.state.chatBrouillonState.brouillon,
      items: chatState is CvmSuccessState ? _messagesToChatItems(chatState.messages, lastReading) : [],
      shouldShowOnboarding: store.state.onboardingState.showChatOnboarding,
      onSendMessage: (String message) => _sendMessage(store, message),
      onRetry: () => store.dispatch(CvmRequestAction()),
    );
  }

  @override
  List<Object?> get props => [displayState, brouillon, items, shouldShowOnboarding];
}

DisplayState _displayState(CvmState state) {
  if (state is CvmLoadingState) return DisplayState.LOADING;
  if (state is CvmFailureState) return DisplayState.FAILURE;
  return DisplayState.CONTENT;
}

void _sendMessage(Store<AppState> store, String message) {
  store.dispatch(CvmSendMessageAction(message));
  PassEmploiMatomoTracker.instance.trackEvent(
    eventCategory: AnalyticsEventNames.cvmMessageCategory,
    action: Platform.isIOS ? AnalyticsEventNames.cvmMessageIosAction : AnalyticsEventNames.cvmMessageAndroidAction,
  );
}

List<CvmChatItem> _messagesToChatItems(List<CvmMessage> messages, DateTime lastConseillerReading) {
  return _messagesWithDaySections(messages).map<CvmChatItem>((element) {
    if (element is String) {
      return CvmDayItem(element);
    } else {
      final message = element as CvmMessage;
      return switch (message) {
        final CvmTextMessage item => _textMessageItem(item, lastConseillerReading),
        final CvmFileMessage item => _pieceJointeItem(item),
        CvmUnknownMessage() => CvmInformationItem(Strings.unknownTypeTitle, Strings.unknownTypeDescription),
      };
    }
  }).toList();
}

CvmChatItem _textMessageItem(CvmTextMessage message, DateTime lastConseillerReading) {
  return CvmTextMessageItem(
    messageId: message.id,
    content: message.content,
    caption: _caption(message, lastConseillerReading),
    sender: message.sentBy,
  );
}

String _caption(CvmTextMessage message, DateTime lastConseillerReading) {
  final date = message.date;
  final hourLabel = date.toHour();
  if (message.sentBy == Sender.conseiller) return hourLabel;
  final status = date == lastConseillerReading || date.isBefore(lastConseillerReading) ? Strings.read : Strings.sent;
  return "$hourLabel · $status";
}

CvmChatItem _pieceJointeItem(CvmFileMessage message) {
  if (message.sentBy == Sender.conseiller) {
    return CvmPieceJointeConseillerMessageItem(
      sender: message.sentBy,
      messageId: message.id,
      url: message.url,
      fileName: message.fileName,
      fileId: message.fileId,
      caption: message.date.toHour(),
    );
  } else {
    return CvmInformationItem(Strings.unknownTypeTitle, Strings.unknownTypeDescription);
  }
}

List<dynamic> _messagesWithDaySections(List<CvmMessage> messages) {
  final messagesWithDaySections = <dynamic>[];
  groupBy(messages, (message) => _getDayLabel(message.date)).forEach((day, messagesOfDay) {
    messagesWithDaySections.add(day);
    messagesWithDaySections.addAll(messagesOfDay);
  });
  return messagesWithDaySections;
}

String _getDayLabel(DateTime dateTime) {
  return dateTime.isAtSameDayAs(DateTime.now()) ? Strings.today : Strings.simpleDayFormat(dateTime.toDay());
}
