import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_actions.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_state.dart';
import 'package:pass_emploi_app/features/tracking/tracking_evenement_engagement_action.dart';
import 'package:pass_emploi_app/models/chat/message.dart';
import 'package:pass_emploi_app/models/chat/sender.dart';
import 'package:pass_emploi_app/network/post_evenement_engagement.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class ChatMessageBottomSheetViewModel extends Equatable {
  final String content;
  final bool withEditOption;
  final bool withDeleteOption;
  final bool withCopyOption;
  final void Function() onDelete;
  final void Function(String) onEdit;

  ChatMessageBottomSheetViewModel({
    required this.content,
    required this.withEditOption,
    required this.withDeleteOption,
    required this.withCopyOption,
    required this.onDelete,
    required this.onEdit,
  });

  factory ChatMessageBottomSheetViewModel.create(Store<AppState> store, String messageId) {
    final chatState = store.state.chatState;
    final message = (chatState as ChatSuccessState).messages.firstWhere((element) => element.id == messageId);
    return ChatMessageBottomSheetViewModel(
      content: message.content,
      onDelete: () {
        store.dispatch(DeleteMessageAction(message));
        store.dispatch(TrackingEvenementEngagementAction(EvenementEngagement.MESSAGE_SUPPRIME));
      },
      withEditOption: _canEditMessage(message),
      withDeleteOption: _canDeleteMessage(message),
      withCopyOption: _canCopyMessage(message),
      onEdit: (content) {
        store.dispatch(EditMessageAction(message, content));
        store.dispatch(TrackingEvenementEngagementAction(EvenementEngagement.MESSAGE_MODIFIE));
      },
    );
  }

  @override
  List<Object?> get props => [content, withEditOption, withDeleteOption, withCopyOption];
}

bool _canEditMessage(Message message) {
  if (message.type == MessageType.messagePj) return false;

  return message.sentBy == Sender.jeune &&
      message.sendingStatus == MessageSendingStatus.sent &&
      message.contentStatus != MessageContentStatus.deleted;
}

bool _canDeleteMessage(Message message) {
  return message.sentBy == Sender.jeune &&
      message.sendingStatus == MessageSendingStatus.sent &&
      message.contentStatus != MessageContentStatus.deleted;
}

bool _canCopyMessage(Message message) {
  return !(message.type == MessageType.messagePj && message.sentBy == Sender.jeune);
}
