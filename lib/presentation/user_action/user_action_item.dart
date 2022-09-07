import 'package:pass_emploi_app/presentation/user_action/user_action_card_view_model.dart';

abstract class UserActionItem {
  UserActionItem._();

  factory UserActionItem.section(String title) = SectionItem;

  factory UserActionItem.message(String message) = MessageItem;

  factory UserActionItem.todoAction(UserActionCardViewModel action) = TodoActionItem;

  factory UserActionItem.doneAction(UserActionCardViewModel action) = DoneActionItem;
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
  final UserActionCardViewModel action;

  TodoActionItem(this.action) : super._();
}

class DoneActionItem extends UserActionItem {
  final UserActionCardViewModel action;

  DoneActionItem(this.action) : super._();
}
