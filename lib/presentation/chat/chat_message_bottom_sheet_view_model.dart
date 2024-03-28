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

  ChatMessageBottomSheetViewModel({
    required this.content,
    required this.withDeleteOption,
    required this.onDelete,
  });

  factory ChatMessageBottomSheetViewModel.create(Store<AppState> store, String messageId) {
    final chatState = store.state.chatState;
    final message = (chatState as ChatSuccessState).messages.firstWhere((element) => element.id == messageId);
    return ChatMessageBottomSheetViewModel(
      content: _content(message),
      withDeleteOption: _withDeleteOption(message),
      onDelete: () => store.dispatch(DeleteMessageAction(message)),
    );
  }

  @override
  List<Object?> get props => [content, withDeleteOption];
}

String _content(Message message) {
  return message.content;
}

bool _withDeleteOption(Message message) {
  return message.sentBy == Sender.jeune &&
      message.sendingStatus == MessageSendingStatus.sent &&
      message.contentStatus != MessageContentStatus.deleted;
}
