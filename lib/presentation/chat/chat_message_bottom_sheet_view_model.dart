import 'package:equatable/equatable.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_actions.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_state.dart';
import 'package:pass_emploi_app/models/chat/message.dart';
import 'package:pass_emploi_app/models/chat/sender.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:redux/redux.dart';

class ChatMessageBottomSheetViewModel extends Equatable {
  final String content;
  final bool withDeleteOption;
  final void Function() onDelete;
  final bool withEditOption;
  final void Function(String) onEdit;

  ChatMessageBottomSheetViewModel({
    required this.content,
    required this.withDeleteOption,
    required this.onDelete,
    required this.withEditOption,
    required this.onEdit,
  });

  factory ChatMessageBottomSheetViewModel.create(Store<AppState> store, String messageId) {
    final chatState = store.state.chatState;
    final message = (chatState as ChatSuccessState).messages.firstWhere((element) => element.id == messageId);
    final candEditMessage = _canEditMessage(message);
    return ChatMessageBottomSheetViewModel(
      content: _content(message),
      withDeleteOption: candEditMessage,
      onDelete: () => store.dispatch(DeleteMessageAction(message)),
      withEditOption: candEditMessage,
      onEdit: (content) => store.dispatch(EditMessageAction(message, content)),
    );
  }

  @override
  List<Object?> get props => [content, withDeleteOption];
}

String _content(Message message) {
  return message.content;
}

bool _canEditMessage(Message message) {
  return message.sentBy == Sender.jeune &&
      message.sendingStatus == MessageSendingStatus.sent &&
      message.contentStatus != MessageContentStatus.deleted;
}
