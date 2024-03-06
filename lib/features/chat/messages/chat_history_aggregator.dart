import 'package:collection/collection.dart';
import 'package:pass_emploi_app/models/chat/message.dart';

class ChatHistoryAggregator {
  List<Message> _messages = [];
  List<Message> get messages => _messages;
  bool _historyEnded = false;
  bool get historyEnded => _historyEnded;

  void onNewMessages(List<Message> newMessages) {
    if (_didNotLooseHistory(newMessages)) {
      _messages = [
        ..._messages.whereMessageIdNotIn(newMessages),
        ...newMessages,
      ];
    } else {
      _messages = newMessages;
    }
    _messages.sortFromOldestToNewest();
  }

  void onOldMessages(List<Message> oldMessages, int numberOfHistoryMessageRequested) {
    _messages = [
      ...oldMessages,
      ..._messages.whereMessageIdNotIn(oldMessages),
    ];
    _messages.sortFromOldestToNewest();
    _historyEnded = oldMessages.length < numberOfHistoryMessageRequested;
  }

  void addMessage(Message message) {
    _messages = [
      ..._messages.whereMessageIdNotIn([message]),
      message,
    ];
    _messages.sortFromOldestToNewest();
  }

  /// Si on reçoit trop de nouveaux messages pendant que le stream est hors-connexion, on peut perdre des messages.
  bool _didNotLooseHistory(List<Message> newMessages) {
    if (messages.isEmpty) return true;
    return newMessages.any((element) => _messages.containsId(element.id));
  }

  DateTime? oldestMessageDate() {
    return _messages.firstOrNull?.creationDate;
  }

  void reset() {
    _messages = [];
    _historyEnded = false;
  }
}

extension _IterableMessage on Iterable<Message> {
  Iterable<Message> whereMessageIdNotIn(Iterable<Message> messages) {
    return where((element) => !messages.containsId(element.id));
  }

  bool containsId(String id) {
    return any((element) => element.id == id);
  }
}

extension _ListMessage on List<Message> {
  void sortFromOldestToNewest() {
    sort((a, b) => a.creationDate.compareTo(b.creationDate));
  }
}
