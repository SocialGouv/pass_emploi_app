import 'package:pass_emploi_app/presentation/rendezvous_view_model.dart';
import 'package:pass_emploi_app/presentation/user_action_view_model.dart';

abstract class HomeItem {
  HomeItem._();

  factory HomeItem.section(String title) = SectionItem;

  factory HomeItem.message(String message) = MessageItem;

  factory HomeItem.action(UserActionViewModel action) = ActionItem;

  factory HomeItem.allActionsButton() = AllActionsButtonItem;

  factory HomeItem.rendezvous(RendezvousViewModel rendezvous) = RendezvousItem;
}

class SectionItem extends HomeItem {
  final String title;

  SectionItem(this.title) : super._();
}

class MessageItem extends HomeItem {
  final String message;

  MessageItem(this.message) : super._();
}

class ActionItem extends HomeItem {
  final UserActionViewModel action;

  ActionItem(this.action) : super._();
}

class AllActionsButtonItem extends HomeItem {
  AllActionsButtonItem() : super._();
}

class RendezvousItem extends HomeItem {
  final RendezvousViewModel rendezvous;

  RendezvousItem(this.rendezvous) : super._();
}
