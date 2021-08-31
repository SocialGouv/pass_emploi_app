import 'package:pass_emploi_app/models/user_action.dart';
import 'package:pass_emploi_app/presentation/rendezvous_view_model.dart';

abstract class HomeItem {
  HomeItem._();

  factory HomeItem.section(String title) = SectionItem;

  factory HomeItem.message(String message) = MessageItem;

  factory HomeItem.action(UserAction action) = ActionItem;

  factory HomeItem.allActionsButton() = AllActionsButton;

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
  final UserAction action;

  ActionItem(this.action) : super._();
}

class AllActionsButton extends HomeItem {
  AllActionsButton() : super._();
}

class RendezvousItem extends HomeItem {
  final RendezvousViewModel rendezvous;

  RendezvousItem(this.rendezvous) : super._();
}
