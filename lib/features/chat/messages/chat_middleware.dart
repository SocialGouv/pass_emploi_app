import 'dart:async';

import 'package:pass_emploi_app/features/chat/messages/chat_actions.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_history_aggregator.dart';
import 'package:pass_emploi_app/features/chat/messages/chat_state.dart';
import 'package:pass_emploi_app/features/login/login_actions.dart';
import 'package:pass_emploi_app/features/login/login_state.dart';
import 'package:pass_emploi_app/features/mode_demo/mode_demo_chat_repository.dart';
import 'package:pass_emploi_app/models/chat/message.dart';
import 'package:pass_emploi_app/models/login_mode.dart';
import 'package:pass_emploi_app/redux/app_state.dart';
import 'package:pass_emploi_app/repositories/chat_repository.dart';
import 'package:pass_emploi_app/ui/animation_durations.dart';
import 'package:pass_emploi_app/usecases/piece_jointe/piece_jointe_use_case.dart';
import 'package:redux/redux.dart';

class ChatMiddleware extends MiddlewareClass<AppState> {
  final ChatRepository _chatRepository;
  final PieceJointeUseCase _pieceJointeUseCase;
  StreamSubscription<List<Message>>? _subscription;
  final ChatHistoryAggregator _chatHistoryAggregator = ChatHistoryAggregator();

  ChatMiddleware(
    this._chatRepository,
    this._pieceJointeUseCase,
  );

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    final loginState = store.state.loginState;
    if (action is LoginSuccessAction || action is RequestLogoutAction || action is NotLoggedInAction) {
      _chatHistoryAggregator.reset();
    }
    if (loginState is LoginSuccessState) {
      final userId = loginState.user.id;
      if (action is SubscribeToChatAction) {
        if (loginState.user.loginMode == LoginMode.DEMO_MILO || loginState.user.loginMode == LoginMode.DEMO_PE) {
          store.dispatch(ChatSuccessAction(modeDemoChat()));
        } else {
          _displayLoaderOnFirstTimeAndCurrentMessagesAfter(store);
          _subscribeToChatStream(userId, store);
        }
      } else if (!loginState.user.loginMode.isDemo()) {
        if (action is UnsubscribeFromChatAction) {
          _subscription?.cancel();
        } else if (action is SendMessageAction) {
          _sendMessage(store, userId, action.message);
        } else if (action is DeleteMessageAction) {
          _deleteMessage(store, userId, action.message);
        } else if (action is SendImageAction) {
          _sendImage(store, userId, action.imagePath);
        } else if (action is SendFileAction) {
          _sendFile(store, userId, action.imagePath);
        } else if (action is EditMessageAction) {
          _editMessage(store, userId, action.message, action.newContent);
        } else if (action is LastMessageSeenAction) {
          _chatRepository.setLastMessageSeen(userId);
        } else if (action is ChatRequestMorePastAction) {
          _loadOldMessages(userId, store);
        }
      }
    }
  }

  void _sendMessage(Store<AppState> store, String userId, String messageText) async {
    final message = Message.fromText(messageText);
    _addMessageToLocal(store, message);
    // Delayed to show the sending message animation
    Future.delayed(AnimationDurations.slow, () => _addMessageToRemote(store, userId, message));
  }

  void _deleteMessage(Store<AppState> store, String userId, Message message) async {
    _chatRepository.deleteMessage(userId, message);
  }

  void _sendImage(Store<AppState> store, String userId, String imagePath) async {
    final message = Message.fromImage(imagePath);
    _addMessageToLocal(store, message);
    final result = await _pieceJointeUseCase.sendImagePieceJointe(userId, message, imagePath);
    if (!result) _addMessageToLocal(store, message.copyWith(sendingStatus: MessageSendingStatus.failed));
  }

  void _sendFile(Store<AppState> store, String userId, String filePath) async {
    final message = Message.fromFile(filePath);
    _addMessageToLocal(store, message);
    final result = await _pieceJointeUseCase.sendFilePieceJointe(userId, message, filePath);
    if (!result) _addMessageToLocal(store, message.copyWith(sendingStatus: MessageSendingStatus.failed));
  }

  void _editMessage(Store<AppState> store, String userId, Message message, String content) async {
    _chatRepository.editMessage(userId, message, content);
  }

  Future<void> _addMessageToRemote(Store<AppState> store, String userId, Message message) async {
    final sendMessageSuceed = await _chatRepository.sendMessage(userId, message);
    if (!sendMessageSuceed) {
      _addMessageToLocal(store, message.copyWith(sendingStatus: MessageSendingStatus.failed));
    }
  }

  void _displayLoaderOnFirstTimeAndCurrentMessagesAfter(Store<AppState> store) {
    final currentChatState = store.state.chatState;
    if (currentChatState is ChatSuccessState) {
      store.dispatch(ChatSuccessAction(currentChatState.messages));
    } else {
      store.dispatch(ChatLoadingAction());
    }
  }

  void _subscribeToChatStream(String userId, Store<AppState> store) {
    _subscription = _chatRepository.messagesStream(userId).listen(
      (messages) {
        _chatHistoryAggregator.onNewMessages(messages);
        _dispatchAllMessages(store);
      },
      onError: (Object error) {
        if (error is ChatNotInitializedError) {
          store.dispatch(TryConnectChatAgainAction());
        }
        return store.dispatch(ChatFailureAction());
      },
    );
  }

  void _loadOldMessages(String userId, Store<AppState> store) async {
    if (_chatHistoryAggregator.historyEnded) return;

    final oldestMessageDate = _chatHistoryAggregator.oldestMessageDate();
    if (oldestMessageDate == null) return;

    final messages = await _chatRepository.oldMessages(userId, oldestMessageDate);
    _chatHistoryAggregator.onOldMessages(messages, _chatRepository.numberOfHistoryMessage);
    _dispatchAllMessages(store);
  }

  void _addMessageToLocal(Store<AppState> store, Message message) {
    _chatHistoryAggregator.addMessage(message);
    _dispatchAllMessages(store);
  }

  void _dispatchAllMessages(Store<AppState> store) {
    store.dispatch(ChatSuccessAction(_chatHistoryAggregator.messages));
  }
}

class ChatNotInitializedError implements Exception {}
