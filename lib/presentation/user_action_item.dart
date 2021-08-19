import 'package:pass_emploi_app/models/user_action.dart';

abstract class UserActionItem {}

class SectionItem extends UserActionItem {
  final String title;

  SectionItem(this.title);
}

class MessageItem extends UserActionItem {
  final String message;

  MessageItem(this.message);
}

class TodoActionItem extends UserActionItem {
  final UserAction action;

  TodoActionItem(this.action);
}

class DoneActionItem extends UserActionItem {
  final UserAction action;

  DoneActionItem(this.action);
}
