import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/cvm/cvm_actions.dart';
import 'package:pass_emploi_app/features/cvm/cvm_state.dart';
import 'package:pass_emploi_app/models/chat/cvm_message.dart';
import 'package:pass_emploi_app/models/chat/sender.dart';
import 'package:pass_emploi_app/presentation/chat/cvm_chat_item.dart';
import 'package:pass_emploi_app/presentation/display_state.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/ui/strings.dart';
import 'package:pass_emploi_app/utils/date_extensions.dart';
import 'package:redux/redux.dart';

class CvmChatPageViewModel extends Equatable {
  final DisplayState displayState;
  final String? brouillon;
  final List<CvmChatItem> items;
  final Function(String message) onSendMessage;
  final Function() onRetry;

  CvmChatPageViewModel({
    required this.displayState,
    required this.brouillon,
    required this.items,
    required this.onSendMessage,
    required this.onRetry,
  });

  factory CvmChatPageViewModel.create(Store<AppState> store) {
    final chatState = store.state.cvmState;
    return CvmChatPageViewModel(
      displayState: _displayState(chatState),
      brouillon: store.state.chatBrouillonState.brouillon,
      items: chatState is CvmSuccessState ? _messagesToChatItems(chatState.messages) : [],
      onSendMessage: (String message) => store.dispatch(CvmSendMessageAction(message)),
      onRetry: () => store.dispatch(CvmRequestAction()),
    );
  }

  @override
  List<Object?> get props => [displayState, brouillon, items];
}

DisplayState _displayState(CvmState state) {
  if (state is CvmLoadingState) return DisplayState.LOADING;
  if (state is CvmFailureState) return DisplayState.FAILURE;
  return DisplayState.CONTENT;
}

List<CvmChatItem> _messagesToChatItems(List<CvmMessage> messages) {
  return _messagesWithDaySections(messages).map<CvmChatItem>((element) {
    if (element is String) {
      return DayItem(element);
    } else {
      final message = element as CvmMessage;
      return switch (message) {
        final CvmTextMessage item => _textMessageItem(item),
        final CvmFileMessage item => _pieceJointeItem(item),
        CvmUnknownMessage() => InformationItem(Strings.unknownTypeTitle, Strings.unknownTypeDescription),
      };
    }
  }).toList();
}

CvmChatItem _textMessageItem(CvmTextMessage message) {
  return TextMessageItem(
    messageId: message.id,
    content: message.content,
    caption: message.date.toHour(),
    sender: message.sentBy,
  );
}

CvmChatItem _pieceJointeItem(CvmFileMessage message) {
  if (message.sentBy == Sender.conseiller) {
    return PieceJointeConseillerMessageItem(
      messageId: message.id,
      content: message.content,
      attachmentUrl: message.url,
      caption: message.date.toHour(),
    );
  } else {
    return InformationItem(Strings.unknownTypeTitle, Strings.unknownTypeDescription);
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
