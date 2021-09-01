import 'package:pass_emploi_app/models/user_action.dart';

abstract class UserActionItem {
  UserActionItem._();

  factory UserActionItem.section(String title) = SectionItem;

  factory UserActionItem.message(String message) = MessageItem;

  factory UserActionItem.todoAction(UserAction action) = TodoActionItem;

  factory UserActionItem.doneAction(UserAction action) = DoneActionItem;
}

class SectionItem extends UserActionItem {
  final String title;

  SectionItem(this.title) : super._();
}

class MessageItem extends UserActionItem {
  final String message;

  MessageItem(this.message) : super._();
}

class TodoActionItem extends UserActionItem {
  final UserAction action;

  TodoActionItem(this.action) : super._();
}

class DoneActionItem extends UserActionItem {
  final UserAction action;

  DoneActionItem(this.action) : super._();
}
